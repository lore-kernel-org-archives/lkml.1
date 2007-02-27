Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbXB0Vhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbXB0Vhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 16:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbXB0Vhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 16:37:45 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53083 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751912AbXB0Vh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 16:37:26 -0500
Date: Tue, 27 Feb 2007 22:29:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: 2.6.21-rc1: mmc reader no longer works, usb oops
Message-ID: <20070227212939.GB1717@elf.ucw.cz>
References: <20070227103620.GA8205@elf.ucw.cz> <200702271146.53414.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702271146.53414.oneukum@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > MMC card reader in x60 no longer works in -rc1. (Will have to check if
> > it worked before s2ram).
> > 
> > When playing with usb-serial, I got this oops (upon trying to start
> > minicom /dev/ttyUSB0 while linux gadget on the other end was
> > crashing).
> 
> Does this help?

Not sure... two new oopsen why trying to use it... (But this time at
least I connected; I _hope_ I applied the patch _before_ loading the module...)

PM: Adding info for No Bus:usbdev2.11_ep83
PM: Adding info for usb:2-2:1.1
PM: Adding info for No Bus:usbdev2.11_ep81
PM: Adding info for No Bus:usbdev2.11_ep02
PM: Adding info for No Bus:usbdev2.11
usb 2-2: USB disconnect, address 11
PM: Removing info for No Bus:usbdev2.11_ep83
usb0: unregister 'cdc_ether' usb-0000:00:1d.0-2, CDC Ethernet Device
PM: Removing info for No Bus:usb0
PM: Removing info for usb:2-2:1.0
PM: Removing info for No Bus:usbdev2.11_ep81
PM: Removing info for No Bus:usbdev2.11_ep02
PM: Removing info for usb:2-2:1.1
PM: Removing info for No Bus:usbdev2.11
PM: Removing info for No Bus:usbdev2.11_ep00
PM: Removing info for usb:2-2
usb 2-2: new full speed USB device using uhci_hcd and address 12
PM: Adding info for usb:2-2
PM: Adding info for No Bus:usbdev2.12_ep00
usb 2-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-2:1.0
usbserial_generic 2-2:1.0: generic converter detected
PM: Adding info for usb-serial:ttyUSB0
PM: Removing info for usb-serial:ttyUSB0
usb-serial ttyUSB0: Error registering port device, continuing
PM: Adding info for No Bus:usbdev2.12_ep01
PM: Adding info for No Bus:usbdev2.12_ep82
PM: Adding info for No Bus:usbdev2.12_ep83
PM: Adding info for No Bus:usbdev2.12
PM: Removing info for No Bus:ttyUSB0
generic ttyUSB0: generic converter now disconnected from ttyUSB0
PM: Removing info for usb-serial:ttyUSB0
usb 2-2: USB disconnect, address 12
PM: Removing info for No Bus:usbdev2.12_ep01
PM: Removing info for No Bus:usbdev2.12_ep82
PM: Removing info for No Bus:usbdev2.12_ep83
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000010
 printing eip:
c061eca4
*pde = 00000000
BUG: soft lockup detected on CPU#1!
 [<c014fe19>] softlockup_tick+0xa9/0xd0
 [<c0131e83>] update_process_times+0x33/0x80
 [<c0143062>] tick_periodic+0x22/0x70
 [<c01430c7>] tick_handle_periodic+0x17/0x70
 [<c011b99e>] smp_apic_timer_interrupt+0x4e/0x80
 [<c0104b68>] apic_timer_interrupt+0x28/0x30
 [<c061007b>] _copy_to_pages+0x5b/0xc0
 [<c0258784>] delay_tsc+0x14/0x20
 [<c02587c6>] __delay+0x6/0x10
 [<c0120c4b>] do_page_fault+0x35b/0x600
 [<c01208f0>] do_page_fault+0x0/0x600
 [<c0621a4c>] error_code+0x7c/0x84
 [<c061eca4>] klist_del+0x14/0x50
 [<c032af5b>] device_del+0x1b/0x1d0
 [<c032b118>] device_unregister+0x8/0x10
 [<f8cc20a7>] destroy_serial+0x87/0x110 [usbserial]
 [<f8cc2020>] destroy_serial+0x0/0x110 [usbserial]
 [<c0254f1b>] kref_put+0x2b/0x80
 [<c013242e>] del_timer_sync+0xe/0x20
 [<f8cc1a60>] usb_serial_disconnect+0x70/0xd0 [usbserial]
 [<c0254f1b>] kref_put+0x2b/0x80
 [<c0458be0>] usb_unbind_interface+0x50/0xa0
 [<c032cea8>] __device_release_driver+0x68/0xb0
 [<c032d24e>] device_release_driver+0x1e/0x40
 [<c032c77b>] bus_remove_device+0x8b/0xa0
 [<c032b0a9>] device_del+0x169/0x1d0
 [<c0456b5d>] usb_disable_device+0x4d/0x100
 [<c0450baa>] usb_disconnect+0x9a/0x120
 [<c0453575>] hub_thread+0x3d5/0xe20
 [<c0121b61>] __activate_task+0x21/0x40
 [<c012494f>] try_to_wake_up+0x3f/0x420
 [<c013d170>] autoremove_wake_function+0x0/0x50
 [<c04531a0>] hub_thread+0x0/0xe20
 [<c013d0bc>] kthread+0xec/0xf0
 [<c013cfd0>] kthread+0x0/0xf0
 [<c0104cab>] kernel_thread_helper+0x7/0x1c
 =======================
Oops: 0000 [#1]
SMP 
Modules linked in: usbserial
CPU:    1
EIP:    0060:[<c061eca4>]    Not tainted VLI
EFLAGS: 00010296   (2.6.21-rc1 #404)
EIP is at klist_del+0x14/0x50
eax: 00000000   ebx: 00000000   ecx: f522d678   edx: 00000001
esi: f53a0510   edi: f52e0da8   ebp: f53a0510   esp: c22d5dd8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process khubd (pid: 271, ti=c22d4000 task=c2205a30 task.ti=c22d4000)
Stack: f52e0d94 f53a0510 f52e0d94 c032af5b f522d678 f52e0d94 f53a0510 00000000 
       f53a0510 c032b118 00000001 f8cc20a7 f7f6134c f7f61350 f53a0510 f53a0510 
       f53a0544 f8cc2020 f53a0514 f53a0510 c0254f1b c013242e f52e0d04 00000000 
Call Trace:
 [<c032af5b>] device_del+0x1b/0x1d0
 [<c032b118>] device_unregister+0x8/0x10
 [<f8cc20a7>] destroy_serial+0x87/0x110 [usbserial]
 [<f8cc2020>] destroy_serial+0x0/0x110 [usbserial]
 [<c0254f1b>] kref_put+0x2b/0x80
 [<c013242e>] del_timer_sync+0xe/0x20
 [<f8cc1a60>] usb_serial_disconnect+0x70/0xd0 [usbserial]
 [<c0254f1b>] kref_put+0x2b/0x80
 [<c0458be0>] usb_unbind_interface+0x50/0xa0
 [<c032cea8>] __device_release_driver+0x68/0xb0
 [<c032d24e>] device_release_driver+0x1e/0x40
 [<c032c77b>] bus_remove_device+0x8b/0xa0
 [<c032b0a9>] device_del+0x169/0x1d0
 [<c0456b5d>] usb_disable_device+0x4d/0x100
 [<c0450baa>] usb_disconnect+0x9a/0x120
 [<c0453575>] hub_thread+0x3d5/0xe20
 [<c0121b61>] __activate_task+0x21/0x40
 [<c012494f>] try_to_wake_up+0x3f/0x420
 [<c013d170>] autoremove_wake_function+0x0/0x50
 [<c04531a0>] hub_thread+0x0/0xe20
 [<c013d0bc>] kthread+0xec/0xf0
 [<c013cfd0>] kthread+0x0/0xf0
 [<c0104cab>] kernel_thread_helper+0x7/0x1c
 =======================
Code: 04 89 46 04 89 4a 04 89 11 c6 03 01 8b 1c 24 8b 74 24 04 83 c4 08 c3 83 ec 0c 89 7c 24 08 89 c7 89 1c 24 89 74 24 04 8b 18 89 d8 <8b> 73 10 e8 f4 29 00 00 89 f8 e8 ad fe ff ff 85 c0 b8 00 00 00 
EIP: [<c061eca4>] klist_del+0x14/0x50 SS:ESP 0068:c22d5dd8


> --- a/drivers/usb/serial/usb-serial.c	2007-02-21 05:32:30.000000000 +0100
> +++ b/drivers/usb/serial/usb-serial.c	2007-02-26 15:32:50.000000000 +0100
> @@ -826,7 +826,6 @@
>  			num_ports = type->num_ports;
>  	}
>  
> -	serial->minor = minor;
>  	serial->num_ports = num_ports;
>  	serial->num_bulk_in = num_bulk_in;
>  	serial->num_bulk_out = num_bulk_out;
> @@ -980,6 +979,7 @@
>  		dev_err(&interface->dev, "No more free serial devices\n");
>  		goto probe_error;
>  	}
> +	serial->minor = minor;
>  
>  	/* register all of the individual ports with the driver core */
>  	for (i = 0; i < num_ports; ++i) {

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
