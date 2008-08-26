Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbYHZB44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbYHZB44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 21:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbYHZB4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 21:56:46 -0400
Received: from n6.bullet.mail.ac4.yahoo.com ([76.13.13.234]:34857 "HELO
	n6.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754102AbYHZB4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 21:56:44 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 596550.24643.bm@omp102.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=sdb5WqprIbriqte84zxBMlugYdoIwEcwNXa+imh5lAzhoD3ZX8mPYZIPOCbenw3qpUVHq++5NRAsEjBSQHoAgFn6uzwBKtX3JInGWB157G6DntOGAtWcmI1ZZ9jBHYZJ0lJ66GeLM/POlsAwO3Nob+Ff3QfChUgTIFR3oa6yU1Y=;
X-YMail-OSG: NzMfgkMVM1lU_Y5KkYvj2m0NXKE_nfp4khUzFxB_9rv_7gNxcZClwbIkq1qWMnN.9LdnFdWbAAPVZGZsusijInF_CtV.VwiFmWmiyYd8LzrRs3Z2gXegG4Qwe7qmZV_rgMQuX6v7rLYEtIVX2RgNJrA-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Mon, 25 Aug 2008 18:56:42 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: USB Serial device disconnect causes IRQ disable after using ehci_info
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <781960.93140.qm@web45208.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <802020.99602.qm@web45205.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Alan
I have observed that IRQ status has changed to c028, how do I decode the irq status. This causes the IRQ disabled.Detailed log is below.

[  469.393023] ehci_hcd 0000:00:1d.7: irq status c028 masked 20
[  507.575453] ehci_hcd 0000:00:1d.7: irq status 600b masked 3
[  507.575465] ehci_hcd 0000:00:1d.7: devpath 2 ep2in 3strikes

Thanks
Amruth p.v


--- On Mon, 8/25/08, amruth <amruth_pv@yahoo.com> wrote:

> From: amruth <amruth_pv@yahoo.com>
> Subject: USB Serial device disconnect causes IRQ disable after using ehci_info
> To: "Alan Stern" <stern@rowland.harvard.edu>
> Cc: "Oliver Neukum" <oliver@neukum.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Monday, August 25, 2008, 4:12 PM
> Hi
> Alan
> 
> > That was the full-speed device.  Does it make any
> > difference if you use 
> > only one of them instead of both?
> > 
> The problem is seen when both are used.
> 
> > Try adding a statement saying:
> > 
> >ehci_info(ehci, "irq status %x masked
> %x\n",
> > status,
> >status & INTR_MASK);
> >> to ehci-hcd.c inside ehci_irq(), just before the
> line that
> > does 	status &= INTR_MASK;
> > 
> > Then let's see what happens.
> Here is the output after using ehci_info
> 
> [  310.517577] usbcore: registered new interface driver
> usbserial
> [  310.519417] usbserial: USB Serial support registered for
> generic
> [  310.521129] usbcore: registered new interface driver
> usbserial_generic
> [  310.521141] usbserial: USB Serial Driver core
> [  310.600476] usbserial: USB Serial support registered for
> TI USB 3410 1 port adapter
> [  310.602481] usbserial: USB Serial support registered for
> TI USB 5052 2 port adapter
> [  310.602481] usbcore: registered new interface driver
> ti_usb_3410_5052
> [  310.602481] ti_usb_3410_5052: TI USB 3410/5052 Serial
> Driver v0.9
> [  416.344945] ehci_hcd 0000:00:1d.7: irq status c masked 4
> [  416.344982] hub 5-0:1.0: state 7 ports 8 chg 0000 evt
> 0020
> [  416.344994] ehci_hcd 0000:00:1d.7: GetStatus port 5
> status 001803 POWER sig=j CSC CONNECT
> [  416.345005] hub 5-0:1.0: port 5, status 0501, change
> 0001, 480 Mb/s
> [  416.448335] hub 5-0:1.0: debounce: port 5: total 100ms
> stable 100ms status 0x501
> [  416.499523] ehci_hcd 0000:00:1d.7: port 5 full speed
> --> companion
> [  416.499533] ehci_hcd 0000:00:1d.7: GetStatus port 5
> status 003801 POWER OWNER sig=j CONNECT
> [  416.499547] usb usb3: wakeup_rh (auto-start)
> [  416.499565] hub 5-0:1.0: port 5 not reset yet, waiting
> 50ms
> [  416.503458] ehci_hcd 0000:00:1d.7: irq status c masked 4
> [  416.550314] ehci_hcd 0000:00:1d.7: GetStatus port 5
> status 003002 POWER OWNER sig=se0 CSC
> [  416.550353] hub 3-0:1.0: state 7 ports 2 chg 0000 evt
> 0002
> [  416.550366] uhci_hcd 0000:00:1d.2: port 1 portsc 0093,00
> [  416.550379] hub 3-0:1.0: port 1, status 0101, change
> 0001, 12 Mb/s
> [  416.654286] hub 3-0:1.0: debounce: port 1: total 100ms
> stable 100ms status 0x101
> [  416.756259] usb 3-1: new full speed USB device using
> uhci_hcd and address 2
> [  416.876237] usb 3-1: ep0 maxpacket = 8
> [  416.899501] usb 3-1: default language 0x0409
> [  416.914558] usb 3-1: uevent
> [  416.914605] usb 3-1: usb_probe_device
> [  416.914612] usb 3-1: configuration #1 chosen from 1
> choice
> [  416.917621] usb 3-1: adding 3-1:1.0 (config #1,
> interface 0)
> [  416.917683] usb 3-1:1.0: uevent
> [  416.917944] usbserial_generic 3-1:1.0:
> usb_probe_interface
> [  416.917950] usbserial_generic 3-1:1.0:
> usb_probe_interface - got id
> [  416.920536] drivers/usb/core/inode.c: creating file
> '002'
> [  416.920736] usb 3-1: New USB device found,
> idVendor=0801, idProduct=000a
> [  416.920742] usb 3-1: New USB device strings: Mfr=1,
> Product=2, SerialNumber=0
> [  416.920749] usb 3-1: Product: IntelliStripe 65
> [  416.920753] usb 3-1: Manufacturer: MagTek
> [  416.920762] hub 5-0:1.0: state 7 ports 8 chg 0000 evt
> 0020
> [  417.604928] usbserial: USB Serial support registered for
> Magtek 75/Excella USB card reader
> [  417.606929] magtek 3-1:1.0: usb_probe_interface
> [  417.606929] magtek 3-1:1.0: usb_probe_interface - got id
> [  417.606929] magtek 3-1:1.0: Magtek 75/Excella USB card
> reader converter detected
> [  417.606929] drivers/usb/serial/magtek.c: magtek_startup
> [  417.606929] uhci_hcd 0000:00:1d.2: reserve dev 2
> ep81-INT, period 8, phase 4, 61 us
> [  417.606929] drivers/usb/serial/magtek.c: magtek_startup
> - usb_submit_urb(int urb)
> [  417.606929] usb 3-1: Magtek 75/Excella USB card reader
> converter now attached to ttyUSB0
> [  417.607927] usbcore: registered new interface driver
> magtek
> [  417.607927] magtek: v1.01 Amruth Vamadev
> [  417.607927] magtek: MAGTEK 75/Excella check USB Chipcard
> Reader Driver
> [  469.065999] ehci_hcd 0000:00:1d.7: irq status c masked 4
> [  469.066035] hub 5-0:1.0: state 7 ports 8 chg 0000 evt
> 0004
> [  469.066045] ehci_hcd 0000:00:1d.7: GetStatus port 2
> status 001803 POWER sig=j CSC CONNECT
> [  469.066056] hub 5-0:1.0: port 2, status 0501, change
> 0001, 480 Mb/s
> [  469.169441] hub 5-0:1.0: debounce: port 2: total 100ms
> stable 100ms status 0x501
> [  469.220697] ehci_hcd 0000:00:1d.7: port 2 high speed
> [  469.220708] ehci_hcd 0000:00:1d.7: GetStatus port 2
> status 001005 POWER sig=se0 PE CONNECT
> [  469.271415] usb 5-2: new high speed USB device using
> ehci_hcd and address 4
> [  469.272398] ehci_hcd 0000:00:1d.7: irq status 8009
> masked 1
> [  469.276912] ehci_hcd 0000:00:1d.7: irq status 8028
> masked 20
> [  469.323607] ehci_hcd 0000:00:1d.7: port 2 high speed
> [  469.323617] ehci_hcd 0000:00:1d.7: GetStatus port 2
> status 001005 POWER sig=se0 PE CONNECT
> [  469.374478] ehci_hcd 0000:00:1d.7: irq status 8009
> masked 1
> [  469.374601] ehci_hcd 0000:00:1d.7: irq status 8028
> masked 20
> [  469.387239] ehci_hcd 0000:00:1d.7: irq status 8009
> masked 1
> [  469.387365] ehci_hcd 0000:00:1d.7: irq status 8009
> masked 1
> [  469.387414] ehci_hcd 0000:00:1d.7: irq status 8009
> masked 1
> [  469.387460] ehci_hcd 0000:00:1d.7: irq status 8009
> masked 1
> [  469.387513] usb 5-2: default language 0x0409
> [  469.387710] ehci_hcd 0000:00:1d.7: irq status 8009
> masked 1
> [  469.387836] ehci_hcd 0000:00:1d.7: irq status 8009
> masked 1
> [  469.387960] ehci_hcd 0000:00:1d.7: irq status 8009
> masked 1
> [  469.388033] usb 5-2: uevent
> [  469.388101] usb 5-2: usb_probe_device
> [  469.388108] usb 5-2: configuration #1 chosen from 1
> choice
> [  469.388211] ehci_hcd 0000:00:1d.7: irq status 8009
> masked 1
> [  469.388336] usb 5-2: adding 5-2:1.0 (config #1,
> interface 0)
> [  469.388385] usb 5-2:1.0: uevent
> [  469.388429] usbserial_generic 5-2:1.0:
> usb_probe_interface
> [  469.388435] usbserial_generic 5-2:1.0:
> usb_probe_interface - got id
> [  469.388454] magtek 5-2:1.0: usb_probe_interface
> [  469.388458] magtek 5-2:1.0: usb_probe_interface - got id
> [  469.388496] magtek 5-2:1.0: Magtek 75/Excella USB card
> reader converter detected
> [  469.388508] drivers/usb/serial/magtek.c: magtek_startup
> [  469.388663] usb 5-2: link qh0-00ff/ded71100 start 0 [1/0
> us]
> [  469.388719] drivers/usb/serial/magtek.c: magtek_startup
> - usb_submit_urb(int urb)
> [  469.388835] usb 5-2: Magtek 75/Excella USB card reader
> converter now attached to ttyUSB1
> [  469.389651] drivers/usb/core/inode.c: creating file
> '004'
> [  469.389759] usb 5-2: New USB device found,
> idVendor=0801, idProduct=2231
> [  469.389766] usb 5-2: New USB device strings: Mfr=1,
> Product=2, SerialNumber=3
> [  469.389772] usb 5-2: Product: STX
> [  469.389777] usb 5-2: Manufacturer: MagTek
> [  469.389781] usb 5-2: SerialNumber: STX001
> [  469.393023] ehci_hcd 0000:00:1d.7: irq status c028
> masked 20
> [  507.575453] ehci_hcd 0000:00:1d.7: irq status 600b
> masked 3
> [  507.575465] ehci_hcd 0000:00:1d.7: devpath 2 ep2in
> 3strikes
> [  507.575470] drivers/usb/serial/magtek.c:
> magtek_read_int_callback - port 1
> [  507.575484] usb 5-2: unlink qh0-00ff/ded71100 start 0
> [1/0 us]
> [  507.576084] usb 5-2: link qh0-00ff/ded71100 start 0 [1/0
> us]
> [  507.576548] usb 5-2: unlink qh0-00ff/ded71100 start 0
> [1/0 us]
> [  507.576548] ehci_hcd 0000:00:1d.7: HC died; cleaning up
> [  507.579131] hub 5-0:1.0: state 0 ports 8 chg 0000 evt
> 0000
> [  507.579137] usb 5-2: USB disconnect, address 4
> [  507.579141] usb 5-2: unregistering device
> [  507.579145] usb 5-2: usb_disable_device nuking all URBs
> [  507.579155] usb 5-2: unregistering interface 5-2:1.0
> [  507.579261] drivers/usb/serial/magtek.c: magtek_shutdown
> [  507.579418] magtek ttyUSB1: Magtek 75/Excella USB card
> reader converter now disconnected from ttyUSB1
> [  507.579450] magtek 5-2:1.0: device disconnected
> [  507.579464] usb 5-2:1.0: uevent
> [  507.581083] usb 5-2: uevent
> [  507.877032] irq 23: nobody cared (try booting with the
> "irqpoll" option)
> [  507.877042] Pid: 0, comm: swapper Not tainted
> 2.6.26patched #2
> [  507.877063]  [<c044c0cc>]
> __report_bad_irq+0x2e/0x6f
> [  507.877078]  [<c044c2e4>]
> note_interrupt+0x1d7/0x20b
> [  507.877089]  [<c044b852>] ?
> handle_IRQ_event+0x21/0x48
> [  507.877103]  [<c044ca0f>]
> handle_fasteoi_irq+0x8b/0xac
> [  507.877114]  [<c044c984>] ?
> handle_fasteoi_irq+0x0/0xac
> [  507.877123]  [<c040598c>] do_IRQ+0xa9/0xd1
> [  507.877131]  [<c04025f2>] ? default_idle+0x0/0x42
> [  507.877142]  [<c040429b>]
> common_interrupt+0x23/0x28
> [  507.877148]  [<c04025f2>] ? default_idle+0x0/0x42
> [  507.877167]  [<c040261f>] ? default_idle+0x2d/0x42
> [  507.877178]  [<c040256d>] cpu_idle+0x8b/0x9f
> [  507.877187]  [<c0610d62>] rest_init+0x4e/0x50
> [  507.877204]  =======================
> [  507.877207] handlers:
> [  507.877209] [<c057649d>] (usb_hcd_irq+0x0/0x58)
> [  507.877217] Disabling IRQ #23
> 
> 
> Thanks
> Amruth p.v
> 
> 
> --- On Mon, 8/25/08, Alan Stern
> <stern@rowland.harvard.edu> wrote:
> 
> > From: Alan Stern <stern@rowland.harvard.edu>
> > Subject: Re: USB Serial device disconnect causes IRQ
> disable not working after patch
> > To: "amruth" <amruth_pv@yahoo.com>
> > Cc: "Oliver Neukum"
> <oliver@neukum.org>, linux-usb@vger.kernel.org,
> linux-kernel@vger.kernel.org
> > Date: Monday, August 25, 2008, 1:50 PM
> > On Mon, 25 Aug 2008, amruth wrote:
> > 
> > > Hi
> > > Alan
> > > The patch suggested by you did not work. I tried
> in
> > another computer and found same issue. I have detailed
> log
> > below.
> > 
> > This log shows you have 2 Magtek devices: one running
> at
> > high speed and 
> > one running at full speed:
> > 
> > > [  143.041808] hub 1-0:1.0: state 7 ports 6 chg
> 0000
> > evt 0002
> > > [  143.041808] ehci_hcd 0000:00:1d.7: GetStatus
> port 1
> > status 001803 POWER sig=j CSC CONNECT
> > > [  143.041808] hub 1-0:1.0: port 1, status 0501,
> > change 0001, 480 Mb/s
> > > [  143.168024] hub 1-0:1.0: debounce: port 1:
> total
> > 100ms stable 100ms status 0x501
> > > [  143.224309] ehci_hcd 0000:00:1d.7: port 1 high
> > speed
> > > [  143.224323] ehci_hcd 0000:00:1d.7: GetStatus
> port 1
> > status 001005 POWER sig=se0 PE CONNECT
> > > [  143.280021] usb 1-1: new high speed USB device
> > using ehci_hcd and address 4
> > > [  143.336281] ehci_hcd 0000:00:1d.7: port 1 high
> > speed
> > > [  143.336292] ehci_hcd 0000:00:1d.7: GetStatus
> port 1
> > status 001005 POWER sig=se0 PE CONNECT
> > > [  143.412650] usb 1-1: default language 0x0409
> > > [  143.413121] usb 1-1: uevent
> > > [  143.417056] usb 1-1: usb_probe_device
> > > [  143.417068] usb 1-1: configuration #1 chosen
> from 1
> > choice
> > > [  143.417361] usb 1-1: adding 1-1:1.0 (config
> #1,
> > interface 0)
> > > [  143.417422] usb 1-1:1.0: uevent
> > > [  143.417622] usbserial_generic 1-1:1.0:
> > usb_probe_interface
> > > [  143.417627] usbserial_generic 1-1:1.0:
> > usb_probe_interface - got id
> > > [  143.417646] magtek 1-1:1.0:
> usb_probe_interface
> > > [  143.417650] magtek 1-1:1.0:
> usb_probe_interface -
> > got id
> > > [  143.417659] magtek 1-1:1.0: Magtek 75/Excella
> USB
> > card reader converter detected
> > 
> > That was the high-speed device.
> > 
> > > [  148.765273] hub 1-0:1.0: state 7 ports 6 chg
> 0000
> > evt 0004
> > > [  148.765273] ehci_hcd 0000:00:1d.7: GetStatus
> port 2
> > status 001803 POWER sig=j CSC CONNECT
> > > [  148.765273] hub 1-0:1.0: port 2, status 0501,
> > change 0001, 480 Mb/s
> > > [  148.892021] hub 1-0:1.0: debounce: port 2:
> total
> > 100ms stable 100ms status 0x501
> > > [  148.948172] ehci_hcd 0000:00:1d.7: port 2 full
> > speed --> companion
> > > [  148.948184] ehci_hcd 0000:00:1d.7: GetStatus
> port 2
> > status 003801 POWER OWNER sig=j CONNECT
> > > [  148.948201] usb usb2: wakeup_rh (auto-start)
> > > [  148.948222] hub 1-0:1.0: port 2 not reset yet,
> > waiting 50ms
> > > [  149.004019] ehci_hcd 0000:00:1d.7: GetStatus
> port 2
> > status 003002 POWER OWNER sig=se0 CSC
> > > [  149.004054] hub 2-0:1.0: state 7 ports 2 chg
> 0000
> > evt 0004
> > > [  149.004065] uhci_hcd 0000:00:1d.0: port 2
> portsc
> > 0093,00
> > > [  149.004075] hub 2-0:1.0: port 2, status 0101,
> > change 0001, 12 Mb/s
> > > [  149.132021] hub 2-0:1.0: debounce: port 2:
> total
> > 100ms stable 100ms status 0x101
> > > [  149.244042] usb 2-2: new full speed USB device
> > using uhci_hcd and address 2
> > > [  149.376015] usb 2-2: ep0 maxpacket = 8
> > > [  149.399097] usb 2-2: default language 0x0409
> > > [  149.408004] usb 2-2: uevent
> > > [  149.418007] usb 2-2: usb_probe_device
> > > [  149.418019] usb 2-2: configuration #1 chosen
> from 1
> > choice
> > > [  149.421042] usb 2-2: adding 2-2:1.0 (config
> #1,
> > interface 0)
> > > [  149.421112] usb 2-2:1.0: uevent
> > > [  149.421158] usbserial_generic 2-2:1.0:
> > usb_probe_interface
> > > [  149.421163] usbserial_generic 2-2:1.0:
> > usb_probe_interface - got id
> > > [  149.421182] magtek 2-2:1.0:
> usb_probe_interface
> > > [  149.421186] magtek 2-2:1.0:
> usb_probe_interface -
> > got id
> > > [  149.421193] magtek 2-2:1.0: Magtek 75/Excella
> USB
> > card reader converter detected
> > 
> > That was the full-speed device.  Does it make any
> > difference if you use 
> > only one of them instead of both?
> > 
> > > [  185.704529] irq 23: nobody cared (try booting
> with
> > the "irqpoll" option)
> > > [  185.704529] Pid: 3505, comm: automount Not
> tainted
> > 2.6.26-KGDB #1
> > > [  185.704529]  [<c013fe84>]
> > __report_bad_irq+0x2e/0x6f
> > > [  185.704529]  [<c0140098>]
> > note_interrupt+0x1d3/0x207
> > > [  185.704529]  [<c013f60e>] ?
> > handle_IRQ_event+0x21/0x48
> > > [  185.704529]  [<c01407c0>]
> > handle_fasteoi_irq+0x8a/0xaa
> > > [  185.704529]  [<c01056f2>]
> do_IRQ+0x71/0x8b
> > > [  185.704529]  [<c010416b>]
> > common_interrupt+0x23/0x28
> > > [  185.704529]  [<c012007b>] ?
> > prof_cpu_mask_write_proc+0xf/0x2f
> > > [  185.704529]  [<c0103747>] ?
> > sysenter_past_esp+0x38/0x91
> > > [  185.704529]  =======================
> > > [  185.704529] handlers:
> > > [  185.704529] [<c03428d9>]
> > (usb_hcd_irq+0x0/0x58)
> > 
> > Try adding a statement saying:
> > 
> > 	ehci_info(ehci, "irq status %x masked
> %x\n",
> > status,
> > 			status & INTR_MASK);
> > 
> > to ehci-hcd.c inside ehci_irq(), just before the line
> that
> > does
> > 
> > 	status &= INTR_MASK;
> > 
> > Then let's see what happens.
> > 
> > Alan Stern
> > 
> > --
> > To unsubscribe from this list: send the line
> > "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at 
> > http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
>       
> 
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


      

