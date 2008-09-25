Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbYIYU1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbYIYU1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbYIYU1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:27:22 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:50097 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbYIYU1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uTpvPyzamoapIMtGpmE+Xh86rVKkSlaUkRClh/Wng03tThbxKVxXAbLLmiO60uFhJf
         2dyTT/D1Zu+YWzW0+wN4rwKEOIZRwGiSoi8MF7Cdf8UkLBP/iRWINKYSD3zCyTfpk4h1
         Wfofad7GZeLquz618+Ol1cnfuTw61SOIafl2g=
Message-ID: <e8ca35370809251327x19dd4731n18aafc6ca4f40d70@mail.gmail.com>
Date: Thu, 25 Sep 2008 22:27:19 +0200
From: "Pascal Terjan" <pterjan@gmail.com>
To: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
Subject: Re: Turning off camera also kills card reader on EeePC 900
Cc: "Sitsofe Wheeler" <sitsofe@yahoo.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Corentin Chary" <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
In-Reply-To: <48CE650B.6000708@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48CE217A.1080409@tuffmail.co.uk> <48CE52EC.9060505@yahoo.com>
	 <48CE650B.6000708@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 3:37 PM, Alan Jenkins
<alan-jenkins@tuffmail.co.uk> wrote:
> Sitsofe Wheeler wrote:
> The "HC died" message is interesting.  Sounds like the controller for
> these two USB devices stops working.  Maybe try unloading and reloading
> the ehci module?  I don't think I can help any more though.

The issue also exist on 701 on 2.6.27-rc7 so the regression is in the
kernel not in the hardware

Disabling camera :

ehci_hcd 0000:00:1d.7: HC died; cleaning up
hub 1-0:1.0: hub_port_status failed (err = -19)
hub 1-0:1.0: connect-debounce failed, port 8 disabled
usb 1-8: USB disconnect, address 3
usb 1-5: USB disconnect, address 2

Enabling it again :

irq 23: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.27-desktop-0.rc6.3.2mnb #1
 [<c0380022>] ? printk+0x18/0x1e
 [<c016bdc7>] __report_bad_irq+0x27/0x90
 [<c016c08c>] note_interrupt+0x25c/0x290
 [<c016aef9>] ? handle_IRQ_event+0x39/0x70
 [<c016c63b>] handle_fasteoi_irq+0xab/0xd0
 [<c0106eb0>] do_IRQ+0x40/0x80
 [<c01048bf>] common_interrupt+0x23/0x28
 [<c0150eba>] ? tick_nohz_stop_sched_tick+0xca/0x350
 [<c01027aa>] cpu_idle+0x2a/0x130
 [<c0372b3e>] rest_init+0x4e/0x60
 =======================
handlers:
[<e005b800>] (usb_hcd_irq+0x0/0x90 [usbcore])
[<e005b800>] (usb_hcd_irq+0x0/0x90 [usbcore])
Disabling IRQ #23

Reloading ehci_hcd

ehci_hcd 0000:00:1d.7: remove, state 0
usb usb1: USB disconnect, address 1
ehci_hcd 0000:00:1d.7: USB bus 1 deregistered
ehci_hcd 0000:00:1d.7: PCI INT A disabled
usb 4-1: new full speed USB device using uhci_hcd and address 2
usb 4-1: configuration #1 chosen from 1 choice
scsi3 : SCSI emulation for USB Mass Storage devices
usb 4-1: New USB device found, idVendor=0951, idProduct=1606
usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=4
usb 4-1: Product: UB6225
usb 4-1: Manufacturer: ENE
usb 4-1: SerialNumber: 146030377350
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usb 5-2: new full speed USB device using uhci_hcd and address 2
usb 5-2: configuration #1 chosen from 1 choice
uvcvideo: Found UVC 1.00 device <unnamed> (eb1a:2761)
uvcvideo: Using UVC_MAX_ISO_PACKETS=40
input: UVC Camera (eb1a:2761) as /class/input/input10
usb 5-2: New USB device found, idVendor=eb1a, idProduct=2761
usb 5-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usbcore: registered new interface driver ub
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
uvcvideo: Non-zero status (-84) in status completion handler.
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27-desktop-0.rc6.3.2mnb ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
usb 4-1: USB disconnect, address 2
usb 5-2: USB disconnect, address 2
usb 1-5: new high speed USB device using ehci_hcd and address 2
usb 1-5: configuration #1 chosen from 1 choice
scsi4 : SCSI emulation for USB Mass Storage devices
usb 1-5: New USB device found, idVendor=0951, idProduct=1606
usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=4
usb 1-5: Product: UB6225
usb 1-5: Manufacturer: ENE
usb 1-5: SerialNumber: 146030377350
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usb 1-8: new high speed USB device using ehci_hcd and address 3
usb 1-8: configuration #1 chosen from 1 choice
uvcvideo: Found UVC 1.00 device <unnamed> (eb1a:2761)
uvcvideo: Using UVC_MAX_ISO_PACKETS=40
input: UVC Camera (eb1a:2761) as /class/input/input11
usb 1-8: New USB device found, idVendor=eb1a, idProduct=2761
usb 1-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
scsi 4:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
sd 4:0:0:0: [sdb] Attached SCSI removable disk
sd 4:0:0:0: Attached scsi generic sg1 type 0
usb-storage: device scan complete

Disabling camera:

eeepc: switch_camera from 1
ehci_hcd 0000:00:1d.7: HC died; cleaning up
hub 1-0:1.0: hub_port_status failed (err = -19)
hub 1-0:1.0: connect-debounce failed, port 8 disabled
usb 1-8: USB disconnect, address 3
usb 1-5: USB disconnect, address 2

Reloading ehci_hcd:

ehci_hcd 0000:00:1d.7: remove, state 0
usb usb1: USB disconnect, address 1
ehci_hcd 0000:00:1d.7: USB bus 1 deregistered
ehci_hcd 0000:00:1d.7: PCI INT A disabled
usb 4-1: new full speed USB device using uhci_hcd and address 3
usb 4-1: configuration #1 chosen from 1 choice
scsi5 : SCSI emulation for USB Mass Storage devices
usb 4-1: New USB device found, idVendor=0951, idProduct=1606
usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=4
usb 4-1: Product: UB6225
usb 4-1: Manufacturer: ENE
usb 4-1: SerialNumber: 146030377350
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb 4-1: USB disconnect, address 3
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27-desktop-0.rc6.3.2mnb ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
usb 1-5: new high speed USB device using ehci_hcd and address 2
usb 1-5: configuration #1 chosen from 1 choice
scsi6 : SCSI emulation for USB Mass Storage devices
usb 1-5: New USB device found, idVendor=0951, idProduct=1606
usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=4
usb 1-5: Product: UB6225
usb 1-5: Manufacturer: ENE
usb 1-5: SerialNumber: 146030377350
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
scsi 6:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
sd 6:0:0:0: [sdb] Attached SCSI removable disk
sd 6:0:0:0: Attached scsi generic sg1 type 0
usb-storage: device scan complete

Enabling camera:

eeepc: switch_camera from 0
usb 1-8: new high speed USB device using ehci_hcd and address 3
usb 1-8: configuration #1 chosen from 1 choice
uvcvideo: Found UVC 1.00 device <unnamed> (eb1a:2761)
uvcvideo: Using UVC_MAX_ISO_PACKETS=40
input: UVC Camera (eb1a:2761) as /class/input/input12
usb 1-8: New USB device found, idVendor=eb1a, idProduct=2761
usb 1-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0

So it looks like an ehci_hcd issue when the camera is disabled
