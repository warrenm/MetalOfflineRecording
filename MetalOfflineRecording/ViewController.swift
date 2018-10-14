
import Cocoa

class ViewController: NSViewController {

    var renderer: Renderer!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported on this device")
            return
        }

        guard let newRenderer = Renderer(device: defaultDevice) else {
            print("Renderer cannot be initialized")
            return
        }

        renderer = newRenderer
        
        let dataURLString = NSString(string: "~/").expandingTildeInPath
        let movieURL = URL(fileURLWithPath: "movie.m4v", relativeTo: URL(fileURLWithPath: dataURLString))
        try? FileManager.default.removeItem(at: movieURL)

        renderer.renderMovie(size: CGSize(width: 800, height: 600), duration: 6.3, url: movieURL) {
            DispatchQueue.main.async {
                NSWorkspace.shared.activateFileViewerSelecting([movieURL.absoluteURL])
                self.view.window?.close()
            }
        }
    }
}
