Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYHYSu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYHYSu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbYHYSuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:50:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47671 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753996AbYHYSuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:50:12 -0400
Date: Mon, 25 Aug 2008 14:50:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: amruth <amruth_pv@yahoo.com>
cc: Oliver Neukum <oliver@neukum.org>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: USB Serial device disconnect causes IRQ disable not working
 after patch
In-Reply-To: <334606.17794.qm@web45209.mail.sp1.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.0808251442510.6639-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2008, amruth wrote:

> Hi
> Alan
> The patch suggested by you did not work. I tried in another computer and found same issue. I have detailed log below.

This log shows you have 2 Magtek devices: one running at high speed and 
one running at full speed:

> [  143.041808] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0002
> [  143.041808] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
> [  143.041808] hub 1-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
> [  143.168024] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
> [  143.224309] ehci_hcd 0000:00:1d.7: port 1 high speed
> [  143.224323] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
> [  143.280021] usb 1-1: new high speed USB device using ehci_hcd and address 4
> [  143.336281] ehci_hcd 0000:00:1d.7: port 1 high speed
> [  143.336292] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
> [  143.412650] usb 1-1: default language 0x0409
> [  143.413121] usb 1-1: uevent
> [  143.417056] usb 1-1: usb_probe_device
> [  143.417068] usb 1-1: configuration #1 chosen from 1 choice
> [  143.417361] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
> [  143.417422] usb 1-1:1.0: uevent
> [  143.417622] usbserial_generic 1-1:1.0: usb_probe_interface
> [  143.417627] usbserial_generic 1-1:1.0: usb_probe_interface - got id
> [  143.417646] magtek 1-1:1.0: usb_probe_interface
> [  143.417650] magtek 1-1:1.0: usb_probe_interface - got id
> [  143.417659] magtek 1-1:1.0: Magtek 75/Excella USB card reader converter detected

That was the high-speed device.

> [  148.765273] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
> [  148.765273] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
> [  148.765273] hub 1-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
> [  148.892021] hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
> [  148.948172] ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
> [  148.948184] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
> [  148.948201] usb usb2: wakeup_rh (auto-start)
> [  148.948222] hub 1-0:1.0: port 2 not reset yet, waiting 50ms
> [  149.004019] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
> [  149.004054] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
> [  149.004065] uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
> [  149.004075] hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
> [  149.132021] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
> [  149.244042] usb 2-2: new full speed USB device using uhci_hcd and address 2
> [  149.376015] usb 2-2: ep0 maxpacket = 8
> [  149.399097] usb 2-2: default language 0x0409
> [  149.408004] usb 2-2: uevent
> [  149.418007] usb 2-2: usb_probe_device
> [  149.418019] usb 2-2: configuration #1 chosen from 1 choice
> [  149.421042] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
> [  149.421112] usb 2-2:1.0: uevent
> [  149.421158] usbserial_generic 2-2:1.0: usb_probe_interface
> [  149.421163] usbserial_generic 2-2:1.0: usb_probe_interface - got id
> [  149.421182] magtek 2-2:1.0: usb_probe_interface
> [  149.421186] magtek 2-2:1.0: usb_probe_interface - got id
> [  149.421193] magtek 2-2:1.0: Magtek 75/Excella USB card reader converter detected

That was the full-speed device.  Does it make any difference if you use 
only one of them instead of both?

> [  185.704529] irq 23: nobody cared (try booting with the "irqpoll" option)
> [  185.704529] Pid: 3505, comm: automount Not tainted 2.6.26-KGDB #1
> [  185.704529]  [<c013fe84>] __report_bad_irq+0x2e/0x6f
> [  185.704529]  [<c0140098>] note_interrupt+0x1d3/0x207
> [  185.704529]  [<c013f60e>] ? handle_IRQ_event+0x21/0x48
> [  185.704529]  [<c01407c0>] handle_fasteoi_irq+0x8a/0xaa
> [  185.704529]  [<c01056f2>] do_IRQ+0x71/0x8b
> [  185.704529]  [<c010416b>] common_interrupt+0x23/0x28
> [  185.704529]  [<c012007b>] ? prof_cpu_mask_write_proc+0xf/0x2f
> [  185.704529]  [<c0103747>] ? sysenter_past_esp+0x38/0x91
> [  185.704529]  =======================
> [  185.704529] handlers:
> [  185.704529] [<c03428d9>] (usb_hcd_irq+0x0/0x58)

Try adding a statement saying:

	ehci_info(ehci, "irq status %x masked %x\n", status,
			status & INTR_MASK);

to ehci-hcd.c inside ehci_irq(), just before the line that does

	status &= INTR_MASK;

Then let's see what happens.

Alan Stern

