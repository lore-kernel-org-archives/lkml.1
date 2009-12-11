Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbZLKV1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbZLKV1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762661AbZLKV1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:27:40 -0500
Received: from kroah.org ([198.145.64.141]:35912 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbZLKV13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:27:29 -0500
Date: Fri, 11 Dec 2009 13:26:46 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.33-git
Message-ID: <20091211212646.GB6624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big USB merge for the 2.6.33-git tree.

Lots of different things here, mostly all just driver updates and a few
new additions.  There was some prep work for future power api changes
done as well. All of the details are in the shortlog below.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------


 Documentation/ABI/testing/sysfs-bus-usb            |   13 +
 .../ABI/testing/sysfs-class-uwb_rc-wusbhc          |   13 +
 Documentation/kernel-parameters.txt                |    2 +
 Documentation/powerpc/dts-bindings/xilinx.txt      |   11 +
 Documentation/usb/power-management.txt             |   69 +-
 MAINTAINERS                                        |    4 +-
 arch/arm/plat-mxc/Makefile                         |    1 +
 arch/arm/plat-mxc/ehci.c                           |   92 +
 arch/arm/plat-mxc/include/mach/mxc_ehci.h          |   37 +
 drivers/bluetooth/btusb.c                          |    2 +-
 drivers/hid/usbhid/hid-core.c                      |    8 +-
 drivers/net/wimax/i2400m/usb.c                     |    7 +-
 drivers/usb/Kconfig                                |    2 +
 drivers/usb/Makefile                               |    2 +
 drivers/usb/class/cdc-acm.c                        |   58 +-
 drivers/usb/class/usbtmc.c                         |   54 +-
 drivers/usb/core/driver.c                          |  135 +-
 drivers/usb/core/file.c                            |    1 +
 drivers/usb/core/generic.c                         |    2 +-
 drivers/usb/core/hcd.c                             |   82 +-
 drivers/usb/core/hcd.h                             |   19 +-
 drivers/usb/core/hub.c                             |  142 +-
 drivers/usb/core/message.c                         |   82 +-
 drivers/usb/core/sysfs.c                           |   61 +-
 drivers/usb/core/urb.c                             |   22 +-
 drivers/usb/core/usb.c                             |   69 +-
 drivers/usb/core/usb.h                             |    1 +
 drivers/usb/gadget/Kconfig                         |   60 +
 drivers/usb/gadget/Makefile                        |    4 +
 drivers/usb/gadget/at91_udc.c                      |    6 +-
 drivers/usb/gadget/audio.c                         |  115 -
 drivers/usb/gadget/composite.c                     |   59 +-
 drivers/usb/gadget/ether.c                         |   16 +-
 drivers/usb/gadget/f_acm.c                         |   28 +
 drivers/usb/gadget/f_audio.c                       |   76 +-
 drivers/usb/gadget/f_mass_storage.c                | 3091 ++++++++++++++++++++
 drivers/usb/gadget/f_rndis.c                       |   35 +-
 drivers/usb/gadget/file_storage.c                  |  879 +-----
 drivers/usb/gadget/mass_storage.c                  |  240 ++
 drivers/usb/gadget/multi.c                         |  358 +++
 drivers/usb/gadget/storage_common.c                |  778 +++++
 drivers/usb/gadget/u_ether.h                       |    2 +-
 drivers/usb/host/Kconfig                           |   22 +-
 drivers/usb/host/ehci-hcd.c                        |   19 +-
 drivers/usb/host/ehci-hub.c                        |    2 +-
 drivers/usb/host/ehci-mxc.c                        |  296 ++
 drivers/usb/host/ehci-omap.c                       |  756 +++++
 drivers/usb/host/ehci-q.c                          |   32 +-
 drivers/usb/host/ehci-sched.c                      |   36 +-
 drivers/usb/host/ehci-xilinx-of.c                  |  300 ++
 drivers/usb/host/isp1362.h                         |    4 +-
 drivers/usb/host/ohci-at91.c                       |   10 +-
 drivers/usb/host/ohci-pnx4008.c                    |    8 +-
 drivers/usb/host/r8a66597-hcd.c                    |    4 -
 drivers/usb/host/whci/debug.c                      |   20 +-
 drivers/usb/host/whci/hcd.c                        |    1 +
 drivers/usb/host/whci/qset.c                       |  350 ++-
 drivers/usb/host/whci/whcd.h                       |    9 +
 drivers/usb/host/whci/whci-hc.h                    |   14 +-
 drivers/usb/host/xhci-hcd.c                        |  139 +-
 drivers/usb/host/xhci-mem.c                        |  255 ++-
 drivers/usb/host/xhci-pci.c                        |    2 +
 drivers/usb/host/xhci-ring.c                       |  343 ++-
 drivers/usb/host/xhci.h                            |   37 +-
 drivers/usb/misc/usbtest.c                         |    7 +-
 drivers/usb/mon/mon_bin.c                          |   51 +-
 drivers/usb/mon/mon_text.c                         |   23 +-
 drivers/usb/musb/Kconfig                           |    5 +-
 drivers/usb/musb/blackfin.c                        |   16 +-
 drivers/usb/musb/blackfin.h                        |   37 +
 drivers/usb/musb/musb_core.c                       |   10 +-
 drivers/usb/musb/musb_core.h                       |    8 +
 drivers/usb/musb/musb_dma.h                        |   11 +
 drivers/usb/musb/musb_gadget.c                     |  196 +-
 drivers/usb/musb/musb_gadget.h                     |    4 +-
 drivers/usb/musb/musb_gadget_ep0.c                 |   70 +-
 drivers/usb/musb/musb_host.c                       |   10 +-
 drivers/usb/musb/musb_regs.h                       |    4 +-
 drivers/usb/musb/musbhsdma.c                       |   12 +-
 drivers/usb/musb/omap2430.c                        |    2 +-
 drivers/usb/otg/Kconfig                            |    9 +
 drivers/usb/otg/Makefile                           |    1 +
 drivers/usb/otg/twl4030-usb.c                      |    4 +-
 drivers/usb/otg/ulpi.c                             |  136 +
 drivers/usb/serial/ark3116.c                       |  975 +++++--
 drivers/usb/serial/ftdi_sio.c                      |   32 +-
 drivers/usb/serial/ftdi_sio.h                      |   14 +
 drivers/usb/serial/mos7840.c                       |   24 +-
 drivers/usb/serial/option.c                        |   39 +-
 drivers/usb/serial/sierra.c                        |   91 +-
 drivers/usb/storage/scsiglue.c                     |    3 +-
 drivers/usb/storage/transport.c                    |   17 +-
 drivers/usb/storage/unusual_devs.h                 |    7 +
 drivers/usb/storage/usb.c                          |   43 +-
 drivers/usb/storage/usb.h                          |    1 +
 drivers/usb/usb-skeleton.c                         |    4 +-
 drivers/usb/wusbcore/devconnect.c                  |    7 +-
 drivers/usb/wusbcore/security.c                    |    6 +-
 drivers/usb/wusbcore/wusbhc.c                      |   32 +
 drivers/usb/wusbcore/wusbhc.h                      |    1 +
 include/linux/usb.h                                |   33 +-
 include/linux/usb/composite.h                      |    1 +
 include/linux/usb/otg.h                            |   68 +-
 include/linux/usb/ulpi.h                           |    7 +
 include/linux/usb_usual.h                          |    4 +-
 scripts/mod/file2alias.c                           |   93 +-
 106 files changed, 9634 insertions(+), 1881 deletions(-)
 create mode 100644 arch/arm/plat-mxc/ehci.c
 create mode 100644 arch/arm/plat-mxc/include/mach/mxc_ehci.h
 create mode 100644 drivers/usb/gadget/f_mass_storage.c
 create mode 100644 drivers/usb/gadget/mass_storage.c
 create mode 100644 drivers/usb/gadget/multi.c
 create mode 100644 drivers/usb/gadget/storage_common.c
 create mode 100644 drivers/usb/host/ehci-mxc.c
 create mode 100644 drivers/usb/host/ehci-omap.c
 create mode 100644 drivers/usb/host/ehci-xilinx-of.c
 create mode 100644 drivers/usb/otg/ulpi.c
 create mode 100644 include/linux/usb/ulpi.h

---------------

Adrian Taylor (1):
      USB: Exposing second ACM channel as tty for Nokia S60 phones.

Aguilar Pena, Leed (1):
      USB: twl4030: Enable USB regulators before enabling USB charging

Alan Stern (9):
      USB: don't use a fixed DMA mapping for hub status URBs
      USB: add a "remove hardware" sysfs attribute
      USB: fix a bug in the scatter-gather library
      USB: EHCI: add native scatter-gather support
      USB: add scatter-gather support to usbmon
      USB: remove the auto_pm flag
      USB: prepare for changover to Runtime PM framework
      USB: usb-storage: add BAD_SENSE flag
      USB: usb-storage: fix bug in fill_inquiry

Anand Gadiyar (2):
      USB: ehci: Allow EHCI to be built on OMAP3
      USB: MUSB: save hardware revision at init

Andre Herms (1):
      USB: usbtmc: repeat usb_bulk_msg until whole message is transfered

Bryan Wu (3):
      USB: musb: kill compile warning for Blackfin systems
      USB: musb: kill some useless comments in Blackfin driver
      USB: musb: fix musb_platform_set_mode() definition

CHENG Renquan (1):
      USB: add remove_id sysfs attr for usb drivers

Cliff Brake (2):
      USB: ftdi_sio: add USB device ID's for B&B Electronics line
      USB: mos7840: add device IDs for B&B electronics devices

Cliff Cai (2):
      USB: musb: clear the Blackfin interrupt pending bits early in the ISR
      USB: musb: Blackfin code needs NOP_USB_XCEIV too

Dan Carpenter (2):
      USB: r8a66597: clean up. remove unneeded null checks
      USB: fix possible null deref in init_usb_class()

Daniel Mack (3):
      USB OTG: add support for ulpi connected external transceivers
      USB OTG: Add generic driver for ULPI OTG transceiver
      USB: Add EHCI support for MX27 and MX31 based boards

David Vrabel (9):
      USB: make urb scatter-gather support more generic
      USB: whci-hcd: support urbs with scatter-gather lists
      USB: allow interrupt transfers to WUSB devices
      USB: whci-hcd: fix type and format warnings in sg code
      usb: whci-hcd: decode more QHead fields in the debug files
      USB: wusb: add wusb_phy_rate sysfs file to host controllers
      USB: whci-hcd: correctly handle sg lists longer than QTD_MAX_XFER_SIZE.
      USB: wusb: don't leak urb in certain error cases
      USB: wusb: correctly check size of security descriptor.

Elina Pasheva (1):
      USB: serial: sierra driver memory reduction

Felipe Balbi (7):
      USB: host: ehci: introduce omap ehci-hcd driver
      USB: core: fix sparse warning for static function
      USB: core: hub: fix sparse warning
      USB: core: message: fix sparse warning
      USB: musb: omap2430: fix sparse warning
      USB: musb: musb_gadget: fix sparse warning
      USB: musb: musb_host: fix sparse warning

Greg Kroah-Hartman (1):
      USB: add devpath sysfs attribute

H Hartley Sweeten (1):
      USB: hcd.c: quiet NULL pointer sparse noise

Hong Xu (1):
      USB: modifications for at91sam9g10

Jason Wessel (1):
      USB: ehci-hub: Remove redundant ehci->debug check

Jean Delvare (1):
      USB: Add missing static markers to ohci-pnx4008

Julia Lawall (3):
      USB: skeleton: Correct use of ! and &
      USB: xhci-mem.c: introduce missing kfree
      USB: ehci-omap.c: introduce missing kfree

Julie Zhu (1):
      USB: Add support for Xilinx USB host controller

Larry Finger (1):
      USB: Check results of dma_map_single

Laurent Pinchart (2):
      USB gadget: Handle endpoint requests at the function level
      USB audio gadget: handle endpoint control requests at the function level

Matthew Wilcox (3):
      USB: Convert a dev_info to a dev_dbg
      USB: usb-storage: Associate the name of the interface with the scsi host
      USB Storage: Make driver less chatty when it finds a new device

Michal Nazarewicz (19):
      USB: g_file_storage: parts of file_storage.c moved to separate file
      USB: g_file_storage: "fsg_" prefix added to some identifiers
      USB: g_file_storage: per-LUN ro, removable and cdrom flags handling changed
      USB: g_file_storage: more code from file_storage.c moved to storage_common.c
      USB: g_mass_storage: template f_mass_storage.c file created
      USB: g_mass_storage: testing code from f_mass_storage.c removed
      USB: g_mass_storage: parts of fsg_dev moved to fsg_common structure
      USB: g_mass_storage: constant length buffers used
      USB: g_mass_storage: fsg_common_init() created
      USB: Interface Association Descriptors added to CDC & RNDIS
      USB: g_mass_storage: Mass Storage Function created
      USB: g_mass_storage: fsg_config added & module params handlig changed
      USB: g_mass_storage: lun_name_format and thread_name added
      USB: g_mass_storage: code cleaned up and comments updated
      USB: g_mass_storage: most data moved to fsg_common
      USB: composite: usb_composite_unregister() no longer __exit
      USB: g_mass_storage: thread_exits callback added
      USB: g_multi: Multifunction Composite Gadget added
      USB: Added USB_ETH_RNDIS to use instead of CONFIG_USB_ETH_RNDIS

Mike Frysinger (2):
      USB: musb: tweak musb_read_fifo() to avoid unused warnings
      USB: musb: fix printf warning in debug code

Nathaniel McCallum (2):
      USB: add hex/bcd detection to usb modalias generation
      USB: handle bcd incrementation in usb modalias generation

Oliver Neukum (2):
      USB: usbtmc: minor formatting cleanups
      USB: improved error handling in usb_port_suspend()

Randy Dunlap (1):
      USB: g_multi kconfig: fix depends and help text

Roel Kluin (1):
      USB: FIX bitfield istl_flip:1, make it unsigned.

Roland Koebler (1):
      USB: serial: ftdi_sio: add space/mark parity

Russ Dill (1):
      USB: Close usb_find_interface race

Sarah Sharp (17):
      USB: xhci: Handle URB cancel, complete and resubmit race.
      USB: xhci: Re-purpose xhci_quiesce().
      USB: xhci: Add watchdog timer for URB cancellation.
      USB: xhci: Remove unused HCD statistics code.
      USB: ehci: Minor constant fix for SCHEDULE_SLOP.
      USB: ehci: Respect IST when scheduling new split iTDs.
      USB: xhci: Add tests for TRB address translation.
      USB: xhci: Set transfer descriptor size field correctly.
      USB: xhci: Return -EPROTO on a split transaction error.
      USB: xhci: Return success for vendor-specific info codes.
      USB: xhci: Handle errors that cause endpoint halts.
      USB: xhci: Add correct email and files to MAINTAINERS entry.
      USB: usbtmc: Use usb_clear_halt() instead of custom code.
      USB: xhci: Make reverting an alt setting "unfailable".
      USB: xhci: Fix command completion after a drop endpoint.
      USB: Refactor code to find alternate interface settings.
      USB: Check bandwidth when switching alt settings.

Sergei Shtylyov (4):
      USB: musb_gadget_ep0: fix unhandled endpoint 0 IRQs, again
      USB: musb_gadget: implement set_wedge() method
      USB: musb_gadget_ep0: stop abusing musb_gadget_set_halt()
      USB: musb_gadget: remove pointless loop

Sonic Zhang (4):
      USB: musb: update Blackfin processor dependency
      USB: musb: add notes for Blackfin anomalies
      USB: musb: add work around for Blackfin anomaly 05000456
      USB: musb: error out when anomaly 05000380 is applicable

Vikram Pandita (1):
      usbtest: make module param pattern writeable

Zhang Le (1):
      USB: option.c: add support for D-Link DWM-162-U5

bart.hartgers@gmail.com (6):
      USB: ark3116: Setup some basic infrastructure for new ark3116 driver.
      USB: ark3116: Make existing functions 16450-aware and add close and release functions.
      USB: ark3116: Replace cmget
      USB: ark3116: Add cmset and break
      USB: ark3116: Callbacks for interrupt and bulk read
      USB: ark3116: Cleanup of now unneeded functions

zhao.ming9@zte.com.cn (1):
      USB: option: add pid for ZTE

