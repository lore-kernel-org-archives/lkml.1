Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYGVIzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYGVIzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYGVIzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:55:18 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:19286 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbYGVIzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=FxM17xlqigvxwLIomlq9+KQZ33Ki0oWs1SX/RdokNwvl3zEPFhlmK1/Yxm9Hl2H+NC
         8rmH9aWU19XPY1jHNpEQibEzJZ+eR2oq46smxpelIEwx+UuTn30UCHX1dj4yXESrr1Gm
         sNJIAwaSslBSd9Xp475lRzDEWoZueSK72IQkw=
Message-ID: <4885A05B.1090401@panasas.com>
Date: Tue, 22 Jul 2008 11:54:51 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.26
References: <20080721223038.GA2051@suse.de>
In-Reply-To: <20080721223038.GA2051@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You mean for 2.6.27, right?

Benny

On Jul. 22, 2008, 1:30 +0300, Greg KH <gregkh@suse.de> wrote:
> Here are some USB patches for your 2.6.26-git tree.
> 
> They include a big gadget rework that has been pending for a while, some
> core suspend/resume fixes, some host controller fixes, the removal of a
> driver that is no longer needed (airprime), and lots of other good
> things.
> 
> Please pull from:
> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
> 
> All of these patches have been in the -mm tree for a while, as well as
> the -next releases
> 
> The full patches will be sent to the linux-usb mailing list, if anyone
> wants to see them.
> 
> thanks,
> 
> greg k-h
> 
> ------------
> 
>  Documentation/DocBook/gadget.tmpl    |   38 +
>  Documentation/usb/gadget_serial.txt  |   35 +-
>  Documentation/usb/persist.txt        |    7 +-
>  Documentation/usb/uhci.txt           |  165 ---
>  drivers/hid/usbhid/hid-core.c        |    2 +-
>  drivers/usb/atm/cxacru.c             |    1 -
>  drivers/usb/atm/speedtch.c           |    1 -
>  drivers/usb/class/cdc-acm.c          |  177 ++-
>  drivers/usb/class/cdc-acm.h          |    5 +
>  drivers/usb/class/cdc-wdm.c          |  127 ++-
>  drivers/usb/core/devices.c           |    4 -
>  drivers/usb/core/devio.c             |   94 +-
>  drivers/usb/core/driver.c            |  168 ++-
>  drivers/usb/core/endpoint.c          |    4 +-
>  drivers/usb/core/file.c              |   10 +-
>  drivers/usb/core/hcd.c               |    6 +-
>  drivers/usb/core/hcd.h               |    4 +-
>  drivers/usb/core/hub.c               |  536 ++++---
>  drivers/usb/core/inode.c             |   16 +-
>  drivers/usb/core/message.c           |   22 +-
>  drivers/usb/core/usb.c               |    7 +-
>  drivers/usb/core/usb.h               |   19 +-
>  drivers/usb/gadget/Kconfig           |   14 +
>  drivers/usb/gadget/Makefile          |   13 +-
>  drivers/usb/gadget/amd5536udc.c      |    2 +-
>  drivers/usb/gadget/at91_udc.c        |   13 +
>  drivers/usb/gadget/cdc2.c            |  246 ++++
>  drivers/usb/gadget/composite.c       | 1041 ++++++++++++++
>  drivers/usb/gadget/config.c          |   76 +-
>  drivers/usb/gadget/dummy_hcd.c       |    4 +-
>  drivers/usb/gadget/epautoconf.c      |    1 +
>  drivers/usb/gadget/ether.c           | 2631 +++-------------------------------
>  drivers/usb/gadget/f_acm.c           |  589 ++++++++
>  drivers/usb/gadget/f_ecm.c           |  833 +++++++++++
>  drivers/usb/gadget/f_loopback.c      |  381 +++++
>  drivers/usb/gadget/f_rndis.c         |  827 +++++++++++
>  drivers/usb/gadget/f_serial.c        |  296 ++++
>  drivers/usb/gadget/f_sourcesink.c    |  587 ++++++++
>  drivers/usb/gadget/f_subset.c        |  423 ++++++
>  drivers/usb/gadget/file_storage.c    |    4 +-
>  drivers/usb/gadget/fsl_usb2_udc.c    |    2 +-
>  drivers/usb/gadget/g_zero.h          |   25 +
>  drivers/usb/gadget/gadget_chips.h    |   23 +
>  drivers/usb/gadget/goku_udc.c        |    2 +-
>  drivers/usb/gadget/inode.c           |   23 +-
>  drivers/usb/gadget/lh7a40x_udc.c     |    2 +-
>  drivers/usb/gadget/m66592-udc.c      |    2 +-
>  drivers/usb/gadget/ndis.h            |   10 +-
>  drivers/usb/gadget/net2280.c         |    2 +-
>  drivers/usb/gadget/omap_udc.c        |    2 +-
>  drivers/usb/gadget/printer.c         |    7 +-
>  drivers/usb/gadget/pxa25x_udc.c      |    2 +-
>  drivers/usb/gadget/pxa27x_udc.c      |    1 -
>  drivers/usb/gadget/rndis.c           |  421 ++-----
>  drivers/usb/gadget/rndis.h           |    9 +-
>  drivers/usb/gadget/serial.c          | 2315 ++----------------------------
>  drivers/usb/gadget/u_ether.c         |  967 +++++++++++++
>  drivers/usb/gadget/u_ether.h         |  127 ++
>  drivers/usb/gadget/u_serial.c        | 1246 ++++++++++++++++
>  drivers/usb/gadget/u_serial.h        |   58 +
>  drivers/usb/gadget/zero.c            | 1162 ++--------------
>  drivers/usb/host/ehci-au1xxx.c       |  369 +++---
>  drivers/usb/host/ehci-dbg.c          |    4 +-
>  drivers/usb/host/ehci-fsl.c          |   17 +-
>  drivers/usb/host/ehci-hcd.c          |    2 +-
>  drivers/usb/host/ehci-ixp4xx.c       |    8 +-
>  drivers/usb/host/ehci-orion.c        |    8 +-
>  drivers/usb/host/ehci-ps3.c          |    2 +-
>  drivers/usb/host/ehci-q.c            |   17 +-
>  drivers/usb/host/ehci.h              |    5 +-
>  drivers/usb/host/isp116x-hcd.c       |   25 +-
>  drivers/usb/host/isp1760-hcd.c       |   81 +-
>  drivers/usb/host/isp1760-hcd.h       |   20 +-
>  drivers/usb/host/isp1760-if.c        |   37 +-
>  drivers/usb/host/ohci-at91.c         |    9 +-
>  drivers/usb/host/ohci-au1xxx.c       |  327 ++---
>  drivers/usb/host/ohci-dbg.c          |    2 +-
>  drivers/usb/host/ohci-hcd.c          |    2 +-
>  drivers/usb/host/ohci-omap.c         |    2 +-
>  drivers/usb/host/ohci-pnx4008.c      |   28 +-
>  drivers/usb/host/ohci-ppc-of.c       |    2 +-
>  drivers/usb/host/ohci-ps3.c          |    2 +-
>  drivers/usb/host/ohci-q.c            |    3 -
>  drivers/usb/host/ohci-sm501.c        |    2 +-
>  drivers/usb/host/ohci-ssb.c          |    2 +-
>  drivers/usb/host/r8a66597-hcd.c      |   44 +-
>  drivers/usb/host/sl811-hcd.c         |    2 +-
>  drivers/usb/host/u132-hcd.c          |    2 +-
>  drivers/usb/host/uhci-hub.c          |    2 +-
>  drivers/usb/misc/auerswald.c         |   10 +-
>  drivers/usb/misc/emi62.c             |    2 -
>  drivers/usb/misc/ftdi-elan.c         |   24 -
>  drivers/usb/misc/iowarrior.c         |    8 +-
>  drivers/usb/misc/rio500.c            |    8 +-
>  drivers/usb/misc/sisusbvga/sisusb.c  |   13 +-
>  drivers/usb/misc/usblcd.c            |    6 +-
>  drivers/usb/mon/mon_stat.c           |   14 +-
>  drivers/usb/serial/Kconfig           |    8 -
>  drivers/usb/serial/Makefile          |    1 -
>  drivers/usb/serial/airprime.c        |  353 -----
>  drivers/usb/serial/cp2101.c          |   13 +-
>  drivers/usb/serial/digi_acceleport.c |    3 +-
>  drivers/usb/serial/io_ti.c           | 1860 +++++++++++-------------
>  drivers/usb/serial/ipaq.c            |    3 +-
>  drivers/usb/serial/ir-usb.c          |  490 ++++---
>  drivers/usb/serial/keyspan.h         |    5 +-
>  drivers/usb/serial/keyspan_pda.c     |    2 +-
>  drivers/usb/serial/kl5kusb105.c      |    2 +-
>  drivers/usb/serial/option.c          |    2 +
>  drivers/usb/serial/usb-serial.c      |   13 +-
>  drivers/usb/serial/usb_debug.c       |    9 +
>  drivers/usb/storage/datafab.c        |    2 -
>  drivers/usb/storage/debug.c          |    2 -
>  drivers/usb/storage/debug.h          |    2 -
>  drivers/usb/storage/dpcm.c           |    2 -
>  drivers/usb/storage/dpcm.h           |    2 -
>  drivers/usb/storage/freecom.c        |    2 -
>  drivers/usb/storage/freecom.h        |    2 -
>  drivers/usb/storage/initializers.c   |    2 -
>  drivers/usb/storage/initializers.h   |    2 -
>  drivers/usb/storage/isd200.c         |    8 +-
>  drivers/usb/storage/jumpshot.c       |    2 -
>  drivers/usb/storage/protocol.c       |    2 -
>  drivers/usb/storage/protocol.h       |    2 -
>  drivers/usb/storage/scsiglue.c       |   53 +-
>  drivers/usb/storage/scsiglue.h       |    2 -
>  drivers/usb/storage/sddr09.c         |    1 -
>  drivers/usb/storage/sddr09.h         |    2 -
>  drivers/usb/storage/sddr55.c         |    2 -
>  drivers/usb/storage/sddr55.h         |    2 -
>  drivers/usb/storage/shuttle_usbat.c  |    2 -
>  drivers/usb/storage/shuttle_usbat.h  |    2 -
>  drivers/usb/storage/transport.c      |   83 +-
>  drivers/usb/storage/transport.h      |    2 -
>  drivers/usb/storage/unusual_devs.h   |   13 +-
>  drivers/usb/storage/usb.c            |  111 +-
>  drivers/usb/storage/usb.h            |   25 +-
>  include/linux/usb.h                  |   12 +-
>  include/linux/usb/composite.h        |  338 +++++
>  include/linux/usb/gadget.h           |   27 +-
>  include/linux/usb/irda.h             |  151 ++
>  include/linux/usbdevice_fs.h         |    2 -
>  142 files changed, 11623 insertions(+), 8951 deletions(-)
>  delete mode 100644 Documentation/usb/uhci.txt
>  create mode 100644 drivers/usb/gadget/cdc2.c
>  create mode 100644 drivers/usb/gadget/composite.c
>  create mode 100644 drivers/usb/gadget/f_acm.c
>  create mode 100644 drivers/usb/gadget/f_ecm.c
>  create mode 100644 drivers/usb/gadget/f_loopback.c
>  create mode 100644 drivers/usb/gadget/f_rndis.c
>  create mode 100644 drivers/usb/gadget/f_serial.c
>  create mode 100644 drivers/usb/gadget/f_sourcesink.c
>  create mode 100644 drivers/usb/gadget/f_subset.c
>  create mode 100644 drivers/usb/gadget/g_zero.h
>  create mode 100644 drivers/usb/gadget/u_ether.c
>  create mode 100644 drivers/usb/gadget/u_ether.h
>  create mode 100644 drivers/usb/gadget/u_serial.c
>  create mode 100644 drivers/usb/gadget/u_serial.h
>  delete mode 100644 drivers/usb/serial/airprime.c
>  create mode 100644 include/linux/usb/composite.h
>  create mode 100644 include/linux/usb/irda.h
> 
> ---------------
> 
> Adrian Bunk (3):
>       USB: isp1760-hcd.c: make 2 functions static
>       USB: remove CVS keywords
>       USB: remove Documentation/usb/uhci.txt
> 
> Akinobu Mita (1):
>       USB: usbmon: use simple_read_from_buffer()
> 
> Alan Cox (8):
>       USB: io_ti: FIrst cut at a big clean up
>       USB: gadget: Push BKL down into drivers
>       USB: ftdi_usb: Eliminate ioctl and BKL ioctl use
>       USB: usblcd: Push down BKL into driver
>       USB: iowarrior: Push down BKL
>       USB: auerwald: Push down the BKL into the driver
>       USB: rio100: Push down the BKL
>       USB: sisusb: Push down the BKL
> 
> Alan Stern (20):
>       USB: add new routine for checking port-resume type
>       USB: debounce before unregistering
>       USB: simplify hub_restart() logic
>       USB: try to salvage lost power sessions
>       USB: optimize port debouncing during hub activation
>       USB: combine hub_activate and hub_restart
>       USB: combine hub_quiesce and hub_stop
>       usb-storage: separate dynamic flags from fixed flags
>       usb-storage: change remaining semaphore to completion
>       USB: implement "soft" unbinding
>       usb-storage: implement "soft" unbinding
>       USB Gadget: documentation update
>       USB: use standard SG iterator in the scatter-gather library
>       USB: Force unbinding of drivers lacking reset_resume or other methods
>       usbfs: send disconnect signals when device is unregistered
>       usbfs: simplify the lookup-by-minor routines
>       usbfs: fix race between open and unregister
>       usbfs: don't store bad pointers in registration
>       USB: use reset_resume when normal resume fails
>       usb-storage: revert DMA-alignment change for Wireless USB
> 
> Aleksey Gorelov (1):
>       USB: debug port converter does not accept more than 8 byte packets
> 
> Alexey Dobriyan (1):
>       USB: rndis: switch to seq_files
> 
> Andre Haupt (1):
>       USB: usb-serial: fix a sparse warning about different signedness
> 
> Andrew Lunn (1):
>       USB: storage: UNUSUAL_DEVS() for PanDigital Picture frame.
> 
> Andrew Morton (1):
>       USB: drivers/usb/host/isp1760-hcd.c: processor flags have type `unsigned long'
> 
> Ben Collins (1):
>       USB: keyspan: Remove duplicate device entries
> 
> Benny Halevy (1):
>       usb: fix uninitialized variable warning in keyspan_pda
> 
> Christophe Jaillet (1):
>       USB: AccessRunner: avoid unnecessary memset
> 
> Daniel Ribeiro (1):
>       USB: remove board-specific UP2OCR configuration from pxa27x-udc
> 
> David Brownell (20):
>       USB: at91_udc: updated fifo sizes
>       usb gadget: split out serial core
>       usb gadget: use new serial core
>       usb gadget: descriptor copying support
>       usb gadget: composite gadget core
>       usb gadget zero: split out source/sink config
>       usb gadget zero: split out loopback config
>       usb gadget zero: use composite gadget framework
>       usb gadget serial: split out CDC ACM function
>       usb gadget serial: split out generic serial function
>       usb gadget serial: use composite gadget framework
>       usb gadget: RNDIS cleanups
>       usb ethernet gadget: split out network core
>       usb ethernet gadget: split CDC Subset function
>       usb ethernet gadget: split CDC Ethernet function
>       usb ethernet gadget: split RNDIS function
>       usb gadget: new "CDC Composite" gadget driver
>       usb ethernet gadget: use composite gadget framework
>       USB: ehci-hcd unlink speedups
>       usb_gadget: composite cdc gadget fault handling
> 
> David Howells (1):
>       USB: Fix pointer/int cast in USB devio code
> 
> David Lopo (1):
>       usb gadget: minor USBCV fix for composite framework
> 
> Eric Miao (1):
>       USB: make SA1111 OHCI driver SA11x0 specific
> 
> Felipe Balbi (2):
>       usb: hub: add check for unsupported bus topology
>       usb: irda: cleanup on ir-usb module
> 
> Greg Kroah-Hartman (4):
>       USB: handle pci_name() being const
>       USB: revert "don't lose disconnections during suspend"
>       USB: revert "don't use reset-resume if drivers don't support it"
>       USB: delete airprime driver
> 
> Harvey Harrison (4):
>       USB: use get_unaligned_* helpers for kl5kusb105 driver
>       USB: digi_accelport.c trivial sparse lock annotation
>       USB: cp2101.c fix sparse signedness mismatch warnings
>       USB: speedtch.c fix sparse shadowed variable warning
> 
> Jean Delvare (1):
>       USB: ohci-pnx4008: I2C cleanups and fixes
> 
> Julien May (1):
>       USB: Fix bug with byte order in isp116x-hcd.c fio write/read
> 
> Kay Sievers (2):
>       USB: usb dev_name() instead of dev->bus_id
>       USB: usb dev_set_name() instead of dev->bus_id
> 
> Manuel Lauss (2):
>       USB: Au1xxx-usb: clean up ohci/ehci bus glue sources.
>       USB: Au1xxx-usb: suspend/resume support.
> 
> Ming Lei (5):
>       USB: host: mark const variable tables as "const"
>       USB: uhci: mark root_hub_hub_des[] as const
>       USB: remove interface parameter of usb_reset_composite_device
>       USB: fix comment of usb_set_configuration
>       USB: fix usb_reset_device and usb_reset_composite_device(take 3)
> 
> Nate Case (1):
>       USB: isp1760: Support board-specific hardware configurations
> 
> Oliver Neukum (7):
>       USB: cdc-wdm cleanup
>       USB: additional power savings for cdc-acm devices that support remote wakeup
>       USB: autosuspend for cdc-wdm
>       USB: fix usb serial pm counter decrement for disconnected interfaces
>       USB: fix disconnect bug in cdc-acm
>       USB: fix build error in cdc-acm for CONFIG_PM=n
>       USB: fix double kfree in ipaq in error case
> 
> Pete Zaitcev (2):
>       USB: missing usb_put_hcd to ohci-at91
>       USB: ohci_hcd hang: submit vs. rmmod race
> 
> Randy Dunlap (1):
>       usb gadget: g_cdc dependso on NET
> 
> Srikanth Srinivasan (1):
>       USB: EHCI: Reconciling USB register differences on MPC85xx vs MPC83xx
> 
> Stephen Rothwell (1):
>       USB: ohci-ppc-of: use linux/of_platform.h instead of asm
> 
> Yoshihiro Shimoda (2):
>       usb: r8a66597-hcd: fix interrupt trigger
>       usb: r8a66597-hcd: fix iinterval for Full/Low speed device
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

