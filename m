Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbYBSPrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbYBSPrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbYBSPqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:46:43 -0500
Received: from mail1.ugh.no ([80.239.42.168]:43300 "EHLO mail1.ugh.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbYBSPql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:46:41 -0500
X-Greylist: delayed 1643 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 10:46:41 EST
Message-ID: <47BAF36C.4000509@tomt.net>
Date: Tue, 19 Feb 2008 16:19:08 +0100
From: Andre Tomt <andre@tomt.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: USB OOPS 2.6.25-rc2-git1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this on a serial console today, using 2.6.25-rc2-git1. Machine was 
not doing anything interesting at the time, but has its / and kernel on 
a usb-storage device (usb pen drive).

Intel ICH8R chipset (and USB controller), running x86_64 kernel. I'll 
post .config and some additional info when I get home later if it isn't 
obvious what broke.

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
> IP: [<ffffffff88063d11>] :ehci_hcd:end_unlink_async+0x17/0xfa
> PGD 7f299067 PUD 7db7c067 PMD 0
> Oops: 0000 [1] SMP
> CPU 0
> Modules linked in: ac battery raid456 async_xor async_memcpy async_tx xor raid1 md_mod xfs loop evdev rtc pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support i2c_core button intel_agp e1000e dm_mirror dm_snapshot dm_mod ata_generic pata_acpi pata_jmicron ahci sata_sil24 libata uhci_hcd thermal processor fan scsi_wait_scan sd_mod usb_storage scsi_mod libusual ehci_hcd ohci_hcd usbcore ext3 jbd mbcache ext2
> Pid: 0, comm: swapper Not tainted 2.6.25-rc2-git1 #1
> RIP: 0010:[<ffffffff88063d11>]  [<ffffffff88063d11>] :ehci_hcd:end_unlink_async+0x17/0xfa
> RSP: 0018:ffffffff80501ec8  EFLAGS: 00010092
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff8045f390
> RDX: 0000000000000017 RSI: ffff81007dd03800 RDI: ffff81007dd03a70
> RBP: ffff81007dd03960 R08: ffffffff8020a166 R09: ffff81007dcf3c10
> R10: ffffffff804a3f58 R11: 000000007dd70240 R12: 0000000000000000
> R13: 0000000000000017 R14: ffff81007dd03800 R15: 0000000000000020
> FS:  0000000000000000(0000) GS:ffffffff80489000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000080 CR3: 000000007fb98000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffffffff804a2000, task ffffffff8045f390)
> Stack:  000000000000a028 ffff81007dd03960 0000000000000000 ffffffff88067b06
>  ffffffff80489510 ffff81007dd03800 0000000000000000 0000000000000000
>  0000000000000017 ffffffff804cd720 0000000000000000 ffffffff880416ba
> Call Trace:
>  <IRQ>  [<ffffffff88067b06>] ? :ehci_hcd:ehci_irq+0x65/0x169
>  [<ffffffff880416ba>] ? :usbcore:usb_hcd_irq+0x23/0x51
>  [<ffffffff80257b2c>] ? handle_IRQ_event+0x25/0x53
>  [<ffffffff8020a166>] ? default_idle+0x0/0x55
>  [<ffffffff80258f4f>] ? handle_fasteoi_irq+0x90/0xc8
>  [<ffffffff8020a166>] ? default_idle+0x0/0x55
>  [<ffffffff8020e340>] ? do_IRQ+0x6c/0xd4
>  [<ffffffff8020a2b2>] ? mwait_idle+0x0/0x42
>  [<ffffffff8020b5b1>] ? ret_from_intr+0x0/0xa
>  <EOI>  [<ffffffff8020a2ee>] ? mwait_idle+0x3c/0x42
>  [<ffffffff8020a24d>] ? cpu_idle+0x92/0xb8
> 
> 
> Code: 1a f6 ff ff 89 c2 41 5b 5b 5b 5d 41 5c 41 5d 41 5e 89 d0 c3 41 54 55 48 89 fd 53 48 8b 5f 28 48 8d bf 10 01 00 00 e8 5f 40 1d f8 <8b> 83 80 00 00 00 c6 83 88 00 00 00 03 48 c7 43 50 00 00 00 00
> RIP  [<ffffffff88063d11>] :ehci_hcd:end_unlink_async+0x17/0xfa
>  RSP <ffffffff80501ec8>
> CR2: 0000000000000080
> ---[ end trace 742c4d07c499608e ]---
> Kernel panic - not syncing: Aiee, killing interrupt handler!
