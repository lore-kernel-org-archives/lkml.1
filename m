Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZICTik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZICTik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbZICTik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:38:40 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43024 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbZICTii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:38:38 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=5UYT2sjzcE4A:10 a=w4iE+TBsmj5y1WloLYF40w==:17
 a=featX6LaNQ5vEptTNPoA:9 a=BVXHkfG3wMb_QqaEMQgA:7
 a=-p1Pa1Vl7hqV_pe6H5phyI8N44wA:4 a=gEqdWBYm7pd67Zy2:21 a=CafROr30-afcZAQJ:21
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: BIOS update == more errors (was Re: sata exception frozen timeout?)
Date: Thu, 3 Sep 2009 13:38:39 -0600
User-Agent: KMail/1.12.90 (Linux/2.6.30-1-amd64; KDE/4.3.64; x86_64; svn-1004284; 2009-07-29)
References: <200909010316.58715.tfjellstrom@shaw.ca>
In-Reply-To: <200909010316.58715.tfjellstrom@shaw.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909031338.39785.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've updated my bios to try and see if it would help at all (it did seem to 
fix other issues).

But now I'm getting the following warnings and errors from dmesg on boot: 
(debian sid 2.6.30, with "noapic" to see if the original problem was an 
interupt issue, as everyone seems to have hinted at).

[    1.024337] ------------[ cut here ]------------
[    1.024408] WARNING: at /build/buildd-linux-2.6_2.6.30-6-amd64-
s9DPiZ/linux-2.6-2.6.30/debian/build/source_amd64_none/drivers/ata/libata-
core.c:6174 ata_host_activate+0x47/0xe0 [libata]()
[    1.024492] Hardware name: GA-MA790FXT-UD5P
[    1.024546] Modules linked in: crc_itu_t atiixp(+) ide_core pata_jmicron 
ahci(+) ehci_hcd(+) libata scsi_mod r8169 mii thermal fan thermal_sys
[    1.025196] Pid: 796, comm: work_for_cpu Not tainted 2.6.30-1-amd64 #1
[    1.025252] Call Trace:
[    1.025318]  [<ffffffffa0056101>] ? ata_host_activate+0x47/0xe0 [libata]
[    1.025385]  [<ffffffffa0056101>] ? ata_host_activate+0x47/0xe0 [libata]
[    1.025445]  [<ffffffff8024237f>] ? warn_slowpath_common+0x77/0xa3
[    1.025505]  [<ffffffffa008e598>] ? ahci_interrupt+0x0/0x454 [ahci]
[    1.025572]  [<ffffffffa0056101>] ? ata_host_activate+0x47/0xe0 [libata]
[    1.025632]  [<ffffffffa008e578>] ? ahci_init_one+0xbb4/0xbd4 [ahci]
[    1.025691]  [<ffffffff8025136e>] ? do_work_for_cpu+0x0/0x1b
[    1.025749]  [<ffffffff8035fa16>] ? local_pci_probe+0x12/0x16
[    1.025806]  [<ffffffff80251379>] ? do_work_for_cpu+0xb/0x1b
[    1.025862]  [<ffffffff80254382>] ? kthread+0x54/0x80
[    1.025918]  [<ffffffff80210aca>] ? child_rip+0xa/0x20
[    1.025975]  [<ffffffff8025432e>] ? kthread+0x0/0x80
[    1.026030]  [<ffffffff80210ac0>] ? child_rip+0x0/0x20
[    1.026085] ---[ end trace 54d3fd405814ad85 ]---
...
[   14.872233] ata10.15: qc timeout (cmd 0xe4)
[   14.872925] ata10.15: failed to read PMP GSCR[0] (Emask=0x4)
[   14.873256] ata9.15: qc timeout (cmd 0xe4)
[   14.873344] ata10: limiting SATA link speed to 1.5 Gbps
[   14.874008] ata9.15: failed to read PMP GSCR[0] (Emask=0x4)
[   14.874271] ata9: limiting SATA link speed to 1.5 Gbps
[   15.548002] irq 7: nobody cared (try booting with the "irqpoll" option)
[   15.548121] Pid: 0, comm: swapper Tainted: G        W  2.6.30-1-amd64 #1
[   15.548240] Call Trace:
[   15.548346]  <IRQ>  [<ffffffff8027fe0f>] ? __report_bad_irq+0x30/0x7d
[   15.548569]  [<ffffffff8027ff61>] ? note_interrupt+0x105/0x170
[   15.548689]  [<ffffffff802805f1>] ? handle_level_irq+0x7c/0xaf
[   15.548809]  [<ffffffff80212655>] ? handle_irq+0x17/0x1d
[   15.548929]  [<ffffffff80211e7c>] ? do_IRQ+0x57/0xbf
[   15.549044]  [<ffffffff80210453>] ? ret_from_intr+0x0/0x11
[   15.549161]  <EOI>  [<ffffffff8064e140>] ? early_idt_handler+0x0/0x71
[   15.549379]  [<ffffffff80227520>] ? native_safe_halt+0x2/0x3
[   15.549497]  [<ffffffff80216995>] ? default_idle+0x40/0x68
[   15.549612]  [<ffffffff8025d784>] ? clockevents_notify+0x2b/0x75
[   15.549730]  [<ffffffff80216d48>] ? c1e_idle+0xe5/0x10d
[   15.549848]  [<ffffffff8020edda>] ? cpu_idle+0x50/0x91
[   15.549963]  [<ffffffff8064ec62>] ? start_kernel+0x37a/0x386
[   15.550081]  [<ffffffff8064e3b7>] ? x86_64_start_kernel+0xf9/0x106
[   15.550199] handlers:
[   15.550311] [<ffffffff803de867>] (usb_hcd_irq+0x0/0x7e)
[   15.550630] Disabling IRQ #7
[   15.636304] irq 11: nobody cared (try booting with the "irqpoll" option)
[   15.636377] Pid: 0, comm: swapper Tainted: G        W  2.6.30-1-amd64 #1
[   15.636434] Call Trace:
[   15.636486]  <IRQ>  [<ffffffff8027fe0f>] ? __report_bad_irq+0x30/0x7d
[   15.636586]  [<ffffffff8027ff61>] ? note_interrupt+0x105/0x170
[   15.636643]  [<ffffffff802805f1>] ? handle_level_irq+0x7c/0xaf
[   15.636699]  [<ffffffff80212655>] ? handle_irq+0x17/0x1d
[   15.636755]  [<ffffffff80211e7c>] ? do_IRQ+0x57/0xbf
[   15.636811]  [<ffffffff80210453>] ? ret_from_intr+0x0/0x11
[   15.636866]  <EOI>  [<ffffffff8064e140>] ? early_idt_handler+0x0/0x71
[   15.636966]  [<ffffffff80227520>] ? native_safe_halt+0x2/0x3
[   15.637022]  [<ffffffff80216995>] ? default_idle+0x40/0x68
[   15.637078]  [<ffffffff8025d784>] ? clockevents_notify+0x2b/0x75
[   15.637135]  [<ffffffff80216d48>] ? c1e_idle+0xe5/0x10d
[   15.637191]  [<ffffffff8020edda>] ? cpu_idle+0x50/0x91
[   15.637247]  [<ffffffff8064ec62>] ? start_kernel+0x37a/0x386
[   15.637304]  [<ffffffff8064e3b7>] ? x86_64_start_kernel+0xf9/0x106
[   15.637359] handlers:
[   15.637411] [<ffffffff803de867>] (usb_hcd_irq+0x0/0x7e)
[   15.637549] [<ffffffff803de867>] (usb_hcd_irq+0x0/0x7e)
[   15.637687] [<ffffffff803de867>] (usb_hcd_irq+0x0/0x7e)
[   15.637825] Disabling IRQ #11
[   17.536129] usb-storage: device scan complete
...
[   21.388126] ata9.15: qc timeout (cmd 0xe4)
[   21.388194] ata9.15: failed to read PMP GSCR[0] (Emask=0x4)
[   21.588135] ata10.15: qc timeout (cmd 0xe4)
[   21.588204] ata10.15: failed to read PMP GSCR[0] (Emask=0x4)
[   24.832135] ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   25.632183] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
...
[  198.322072] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
frozen
[  198.322080] ata8.00: cmd b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
[  198.322081]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 
(timeout)
[  198.322083] ata8.00: status: { DRDY }
[  198.322088] ata8: hard resetting link
[  198.916035] ata8: softreset failed (device not ready)
[  198.916039] ata8: failed due to HW bug, retry pmp=0
[  199.080024] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  199.092059] ata8.00: configured for UDMA/133
[  199.092072] ata8: EH complete
[  227.900583] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
frozen
[  227.900590] ata8.00: cmd b0/d8:00:01:4f:c2/00:00:00:00:00/00 tag 0
[  227.900591]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4 
(timeout)
[  227.900594] ata8.00: status: { DRDY }
[  227.900598] ata8: hard resetting link
[  228.384016] ata8: softreset failed (device not ready)
[  228.384020] ata8: failed due to HW bug, retry pmp=0
[  228.548024] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  228.560372] ata8.00: configured for UDMA/133
[  228.560385] ata8: EH complete
[  238.805198] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
frozen
[  238.805218] ata8.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[  238.805221]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[  238.805229] ata8.00: status: { DRDY }
[  238.805241] ata8: hard resetting link
[  239.404154] ata8: softreset failed (device not ready)
[  239.404163] ata8: failed due to HW bug, retry pmp=0
[  239.568186] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  239.580343] ata8.00: configured for UDMA/133
[  239.580374] ata8: EH complete
[  246.808086] ata8.00: NCQ disabled due to excessive errors
[  246.808099] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
frozen
[  246.808115] ata8.00: cmd b0/d8:00:01:4f:c2/00:00:00:00:00/00 tag 0
[  246.808119]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4 
(timeout)
[  246.808126] ata8.00: status: { DRDY }
[  246.808138] ata8: hard resetting link
[  247.292158] ata8: softreset failed (device not ready)
[  247.292167] ata8: failed due to HW bug, retry pmp=0
[  247.456174] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  247.468955] ata8.00: configured for UDMA/133
[  247.468984] ata8: EH complete
[  272.804207] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
frozen
[  272.804227] ata8.00: cmd b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
[  272.804231]          res 40/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x4 
(timeout)
[  272.804238] ata8.00: status: { DRDY }
[  272.804250] ata8: hard resetting link
[  273.292161] ata8: softreset failed (device not ready)
[  273.292169] ata8: failed due to HW bug, retry pmp=0
[  273.456173] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  273.468892] ata8.00: configured for UDMA/133
[  273.468916] ata8: EH complete

On boot, it seemed to hang the disk up for a good few minutes, even though 
nothing is using it at the moment (I have to manually bring up the mdraid0 
array, so it can't possibly be mounted), and smartctl was erroring out for a 
while, but now its fine, and smart shows no issues.

I'm going to try without noapic on 2.6.30, and 2.6.31-rc5 and see what 
happens.


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
