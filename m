Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbZIDDnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbZIDDnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 23:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbZIDDnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 23:43:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:46718 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588AbZIDDnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 23:43:14 -0400
Message-ID: <4AA08CD0.6000309@kernel.org>
Date: Fri, 04 Sep 2009 12:43:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: tfjellstrom@shaw.ca
CC: linux-kernel@vger.kernel.org
Subject: Re: BIOS update == more errors (was Re: sata exception frozen timeout?)
References: <200909010316.58715.tfjellstrom@shaw.ca> <200909031338.39785.tfjellstrom@shaw.ca>
In-Reply-To: <200909031338.39785.tfjellstrom@shaw.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 03:43:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thomas Fjellstrom wrote:
> I've updated my bios to try and see if it would help at all (it did seem to 
> fix other issues).
> 
> But now I'm getting the following warnings and errors from dmesg on boot: 
> (debian sid 2.6.30, with "noapic" to see if the original problem was an 
> interupt issue, as everyone seems to have hinted at).
> 
> [    1.024337] ------------[ cut here ]------------
> [    1.024408] WARNING: at /build/buildd-linux-2.6_2.6.30-6-amd64-
> s9DPiZ/linux-2.6-2.6.30/debian/build/source_amd64_none/drivers/ata/libata-
> core.c:6174 ata_host_activate+0x47/0xe0 [libata]()
> [    1.024492] Hardware name: GA-MA790FXT-UD5P
> [    1.024546] Modules linked in: crc_itu_t atiixp(+) ide_core pata_jmicron 
> ahci(+) ehci_hcd(+) libata scsi_mod r8169 mii thermal fan thermal_sys
> [    1.025196] Pid: 796, comm: work_for_cpu Not tainted 2.6.30-1-amd64 #1
> [    1.025252] Call Trace:
> [    1.025318]  [<ffffffffa0056101>] ? ata_host_activate+0x47/0xe0 [libata]
> [    1.025385]  [<ffffffffa0056101>] ? ata_host_activate+0x47/0xe0 [libata]
> [    1.025445]  [<ffffffff8024237f>] ? warn_slowpath_common+0x77/0xa3
> [    1.025505]  [<ffffffffa008e598>] ? ahci_interrupt+0x0/0x454 [ahci]
> [    1.025572]  [<ffffffffa0056101>] ? ata_host_activate+0x47/0xe0 [libata]
> [    1.025632]  [<ffffffffa008e578>] ? ahci_init_one+0xbb4/0xbd4 [ahci]
> [    1.025691]  [<ffffffff8025136e>] ? do_work_for_cpu+0x0/0x1b
> [    1.025749]  [<ffffffff8035fa16>] ? local_pci_probe+0x12/0x16
> [    1.025806]  [<ffffffff80251379>] ? do_work_for_cpu+0xb/0x1b
> [    1.025862]  [<ffffffff80254382>] ? kthread+0x54/0x80
> [    1.025918]  [<ffffffff80210aca>] ? child_rip+0xa/0x20
> [    1.025975]  [<ffffffff8025432e>] ? kthread+0x0/0x80
> [    1.026030]  [<ffffffff80210ac0>] ? child_rip+0x0/0x20
> [    1.026085] ---[ end trace 54d3fd405814ad85 ]---

This means that the controller wasn't assigned an irq.  Newer BIOSen
often break IRQ routing on !acpi.

> [   14.872233] ata10.15: qc timeout (cmd 0xe4)
> [   14.872925] ata10.15: failed to read PMP GSCR[0] (Emask=0x4)
> [   14.873256] ata9.15: qc timeout (cmd 0xe4)
> [   14.873344] ata10: limiting SATA link speed to 1.5 Gbps
> [   14.874008] ata9.15: failed to read PMP GSCR[0] (Emask=0x4)
> [   14.874271] ata9: limiting SATA link speed to 1.5 Gbps

So, probing of course can't be done properly.

> [   15.548002] irq 7: nobody cared (try booting with the "irqpoll" option)
> [   15.548121] Pid: 0, comm: swapper Tainted: G        W  2.6.30-1-amd64 #1
> [   15.548240] Call Trace:
> [   15.548346]  <IRQ>  [<ffffffff8027fe0f>] ? __report_bad_irq+0x30/0x7d
> [   15.548569]  [<ffffffff8027ff61>] ? note_interrupt+0x105/0x170
> [   15.548689]  [<ffffffff802805f1>] ? handle_level_irq+0x7c/0xaf
> [   15.548809]  [<ffffffff80212655>] ? handle_irq+0x17/0x1d
> [   15.548929]  [<ffffffff80211e7c>] ? do_IRQ+0x57/0xbf
> [   15.549044]  [<ffffffff80210453>] ? ret_from_intr+0x0/0x11
> [   15.549161]  <EOI>  [<ffffffff8064e140>] ? early_idt_handler+0x0/0x71
> [   15.549379]  [<ffffffff80227520>] ? native_safe_halt+0x2/0x3
> [   15.549497]  [<ffffffff80216995>] ? default_idle+0x40/0x68
> [   15.549612]  [<ffffffff8025d784>] ? clockevents_notify+0x2b/0x75
> [   15.549730]  [<ffffffff80216d48>] ? c1e_idle+0xe5/0x10d
> [   15.549848]  [<ffffffff8020edda>] ? cpu_idle+0x50/0x91
> [   15.549963]  [<ffffffff8064ec62>] ? start_kernel+0x37a/0x386
> [   15.550081]  [<ffffffff8064e3b7>] ? x86_64_start_kernel+0xf9/0x106
> [   15.550199] handlers:
> [   15.550311] [<ffffffff803de867>] (usb_hcd_irq+0x0/0x7e)
> [   15.550630] Disabling IRQ #7
> [   15.636304] irq 11: nobody cared (try booting with the "irqpoll" option)
> [   15.636377] Pid: 0, comm: swapper Tainted: G        W  2.6.30-1-amd64 #1
> [   15.636434] Call Trace:
> [   15.636486]  <IRQ>  [<ffffffff8027fe0f>] ? __report_bad_irq+0x30/0x7d
> [   15.636586]  [<ffffffff8027ff61>] ? note_interrupt+0x105/0x170
> [   15.636643]  [<ffffffff802805f1>] ? handle_level_irq+0x7c/0xaf
> [   15.636699]  [<ffffffff80212655>] ? handle_irq+0x17/0x1d
> [   15.636755]  [<ffffffff80211e7c>] ? do_IRQ+0x57/0xbf
> [   15.636811]  [<ffffffff80210453>] ? ret_from_intr+0x0/0x11
> [   15.636866]  <EOI>  [<ffffffff8064e140>] ? early_idt_handler+0x0/0x71
> [   15.636966]  [<ffffffff80227520>] ? native_safe_halt+0x2/0x3
> [   15.637022]  [<ffffffff80216995>] ? default_idle+0x40/0x68
> [   15.637078]  [<ffffffff8025d784>] ? clockevents_notify+0x2b/0x75
> [   15.637135]  [<ffffffff80216d48>] ? c1e_idle+0xe5/0x10d
> [   15.637191]  [<ffffffff8020edda>] ? cpu_idle+0x50/0x91
> [   15.637247]  [<ffffffff8064ec62>] ? start_kernel+0x37a/0x386
> [   15.637304]  [<ffffffff8064e3b7>] ? x86_64_start_kernel+0xf9/0x106
> [   15.637359] handlers:
> [   15.637411] [<ffffffff803de867>] (usb_hcd_irq+0x0/0x7e)
> [   15.637549] [<ffffffff803de867>] (usb_hcd_irq+0x0/0x7e)
> [   15.637687] [<ffffffff803de867>] (usb_hcd_irq+0x0/0x7e)
> [   15.637825] Disabling IRQ #11

And two nobody cared.  As the kernel doesn't have much idea how the
IRQs are being routed.  Hell breaking loose isn't much of a surprise.

> [  198.322072] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
> frozen
> [  198.322080] ata8.00: cmd b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
> [  198.322081]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 
> (timeout)
> [  198.322083] ata8.00: status: { DRDY }
> [  198.322088] ata8: hard resetting link
> [  198.916035] ata8: softreset failed (device not ready)
> [  198.916039] ata8: failed due to HW bug, retry pmp=0
> [  199.080024] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  199.092059] ata8.00: configured for UDMA/133
> [  199.092072] ata8: EH complete
> [  227.900583] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
> frozen
> [  227.900590] ata8.00: cmd b0/d8:00:01:4f:c2/00:00:00:00:00/00 tag 0
> [  227.900591]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4 
> (timeout)

Does disabling smartd make any difference?

Thanks.

-- 
tejun
