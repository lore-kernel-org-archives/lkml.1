Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbYHZTBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbYHZTBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759557AbYHZTAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:00:17 -0400
Received: from n3b.bullet.mail.ac4.yahoo.com ([76.13.13.73]:41568 "HELO
	n3b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759544AbYHZTAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:00:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 949509.32566.bm@omp110.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=vhMU71FU85801dEpQMmA+u3RzFYHPwZiSBF4jX3+vk7wiq0qKsp83fmyW1iprJN80zwqy3O+Z37gTmKlufEcrxFpjfj177gQEmCe+rWPXIrdSqfi8BqKoq9Uz5orTM+x+8fNSCQIPZhtDVKVIUTvOXNqdcdkYuXzn796bbWFg4E=;
X-YMail-OSG: _cBODsgVM1nOLdCTQPfPl4VHLvwu0AdWzOYgp8DTtHzWTmB_bC1wYv7aPKQNsfpbaXa395DuaXbVbBwk3bgcxVs6IeOjGPl.yK6SOGs.7RIhvXNG.hsELdG39uuzHkImkw--
X-Mailer: YahooMailWebService/0.7.218.2
Date: Tue, 26 Aug 2008 12:00:11 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: USB Serial device disconnect causes IRQ disable after using ehci controller halted
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <518137.79296.qm@web45209.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <214918.92613.qm@web45204.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Alan
I am posting below detail log after adding debug messages
[  307.695452] magtek 5-1:1.0: Magtek 75/Excella USB card reader converter detected
[  307.695452] drivers/usb/serial/magtek.c: magtek_startup
[  307.695452] usb 5-1: link qh0-00ff/ded67080 start 0 [1/0 us]
[  307.695452] drivers/usb/serial/magtek.c: magtek_startup - usb_submit_urb(int urb)
[  307.695452] usb 5-1: Magtek 75/Excella USB card reader converter now attached to ttyUSB0
[  307.695452] drivers/usb/core/inode.c: creating file '006'
[  307.696371] usb 5-1: New USB device found, idVendor=0801, idProduct=2231
[  307.696377] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  307.696383] usb 5-1: Product: STX
[  307.696387] usb 5-1: Manufacturer: MagTek
[  307.696391] usb 5-1: SerialNumber: STX001
[  307.700515] ehci_hcd 0000:00:1d.7: irq status c028 masked 20
[  307.700530] ehci_hcd 0000:00:1d.7: hcd state 1
[  307.700536] ehci_hcd 0000:00:1d.7: hcd state 1
[  307.700544] ehci_hcd 0000:00:1d.7: hcd state 1
[  308.850650] ehci_hcd 0000:00:1d.7: irq status 600b masked 3
[  308.850658] ehci_hcd 0000:00:1d.7: hcd state 1
[  308.850665] ehci_hcd 0000:00:1d.7: devpath 1 ep2in 3strikes
[  308.850670] drivers/usb/serial/magtek.c: magtek_read_int_callback - port 0
[  308.850683] usb 5-1: unlink qh0-00ff/ded67080 start 0 [1/0 us]
[  308.850846] usb 5-1: link qh0-00ff/ded67080 start 0 [1/0 us]
[  308.851537] usb 5-1: unlink qh0-00ff/ded67080 start 0 [1/0 us]
[  308.853487] ehci_hcd 0000:00:1d.7: handshake failed: controller halted
[  308.853487] Pid: 0, comm: swapper Not tainted 2.6.26EHCIDBG #3
[  308.853487]  [<e08405aa>] handshake_on_error_set_halt+0x45/0x51 [ehci_hcd]
[  308.853487]  [<e08405d6>] disable_periodic+0x20/0x40 [ehci_hcd]
[  308.853487]  [<e0841fb4>] ehci_work+0x5e6/0x6ad [ehci_hcd]
[  308.853487]  [<c0424230>] ? printk+0x15/0x17
[  308.853487]  [<e0845c7e>] ehci_irq+0x28a/0x2fd [ehci_hcd]
[  308.853487]  [<e090005d>] ? cdrom_newpc_intr+0x52e/0x544 [ide_cd_mod]
[  308.853487]  [<c042addd>] ? lock_timer_base+0x1f/0x3e
[  308.853487]  [<c05764c4>] usb_hcd_irq+0x27/0x58
[  308.853487]  [<c044b852>] handle_IRQ_event+0x21/0x48
[  308.853487]  [<c044c9fb>] handle_fasteoi_irq+0x77/0xac
[  308.853487]  [<c044c984>] ? handle_fasteoi_irq+0x0/0xac
[  308.853487]  [<c040598c>] do_IRQ+0xa9/0xd1
[  308.853487]  [<c04025f2>] ? default_idle+0x0/0x42
[  308.853487]  [<c040429b>] common_interrupt+0x23/0x28
[  308.853487]  [<c04025f2>] ? default_idle+0x0/0x42
[  308.853487]  [<c041007b>] ? acpi_save_state_mem+0xa/0x12b
[  308.853487]  [<c040261f>] ? default_idle+0x2d/0x42
[  308.853487]  [<c040256d>] cpu_idle+0x8b/0x9f
[  308.853487]  [<c061f329>] start_secondary+0x156/0x15b
[  308.853487]  =======================
[  308.853487] ehci_hcd 0000:00:1d.7: hcd state 0
[  308.853487] ehci_hcd 0000:00:1d.7: hcd state 0
[  308.853487] ehci_hcd 0000:00:1d.7: HC died; cleaning up
[  308.854983] hub 5-0:1.0: state 0 ports 8 chg 0000 evt 0000
[  308.854983] usb 5-1: USB disconnect, address 6
[  308.854983] usb 5-1: unregistering device
[  308.854983] usb 5-1: usb_disable_device nuking all URBs
[  308.854983] usb 5-1: unregistering interface 5-1:1.0
[  308.854983] drivers/usb/serial/magtek.c: magtek_shutdown
[  308.854983] magtek ttyUSB0: Magtek 75/Excella USB card reader converter now disconnected from ttyUSB0
[  308.854983] magtek 5-1:1.0: device disconnected
[  308.854983] usb 5-1:1.0: uevent
[  308.854983] usb 5-1: uevent
[  309.153998] irq 23: nobody cared (try booting with the "irqpoll" option)
[  309.154006] Pid: 0, comm: swapper Not tainted 2.6.26EHCIDBG #3
[  309.154027]  [<c044c0cc>] __report_bad_irq+0x2e/0x6f
[  309.154042]  [<c044c2e4>] note_interrupt+0x1d7/0x20b
[  309.154054]  [<c044b852>] ? handle_IRQ_event+0x21/0x48
[  309.154068]  [<c044ca0f>] handle_fasteoi_irq+0x8b/0xac
[  309.154078]  [<c044c984>] ? handle_fasteoi_irq+0x0/0xac
[  309.154087]  [<c040598c>] do_IRQ+0xa9/0xd1
[  309.154096]  [<c04025f2>] ? default_idle+0x0/0x42
[  309.154107]  [<c040429b>] common_interrupt+0x23/0x28
[  309.154112]  [<c04025f2>] ? default_idle+0x0/0x42
[  309.154132]  [<c040261f>] ? default_idle+0x2d/0x42
[  309.154579]  [<c040256d>] cpu_idle+0x8b/0x9f
[  309.154579]  [<c061f329>] start_secondary+0x156/0x15b
[  309.154579]  =======================
[  309.154579] handlers:
[  309.154579] [<c057649d>] (usb_hcd_irq+0x0/0x58)
[  309.154579] Disabling IRQ #23



Thanks
Amruth p.v





      

