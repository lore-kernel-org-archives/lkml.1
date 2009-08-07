Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZHGE0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZHGE0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 00:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbZHGE0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 00:26:13 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60605 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZHGE0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 00:26:11 -0400
Date: Fri, 7 Aug 2009 09:56:03 +0530
From: Sripathi Kodi <sripathik@in.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
Message-ID: <20090807095603.44c21333@sripathi.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	<alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
	<alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	<alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	<alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	<alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	<alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	<alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	<alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	<alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	<alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	<alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	<alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	<alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009 02:48:04 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> We are pleased to announce the next update to our new preempt-rt
> series.
> 
>     - update to 2.6.31-rc4
> 
> This is a major rework of the rt patch series. Thanks to Clark
> Williams and John Kacur for providing the merge to 2.6.30 while I was
> stabilizing .29-rt. While the 30-rt series looked quite stable, we
> decided to skip 30-rt entirely to keep track with the ongoing mainline
> development for various reaons. The .31-rt series is planned to be
> stabilized as we have done with .29-rt.

I searched the mails in this chain, but did not find the following
BUG reported yet. I hit this once while booting up.

INIT: version 2.86 bootingBUG: unable to handle kernel NULL pointer dereference at 0000000000000024
IP: [<ffffffff81050fe6>] try_to_wake_up+0x3b/0x2e2
PGD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/block/sda/dev
CPU 5 
Modules linked in: dm_region_hash dm_log dm_mod ata_piix libata shpchp mptsas mptscsih mptbase scsi_transport_sas sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
Pid: 0, comm: swapper Not tainted 2.6.31-rc4-rt1 #1 IBM eServer BladeCenter HS21 -[7995AAA]-
RIP: 0010:[<ffffffff81050fe6>]  [<ffffffff81050fe6>] try_to_wake_up+0x3b/0x2e2
RSP: 0018:ffff880028199e38  EFLAGS: 00010082
RAX: 0000000000000000 RBX: 000000000000001e RCX: 0000000000000000
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000000
RBP: ffff880028199e88 R08: b000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 017dbbb7ec537836 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880028196000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000024 CR3: 0000000001001000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88022f342000, task ffff88022f340000)
Stack:
 ffffffff810bd00b 00000000ec537836 ffffffff81619840 ffff88022c58e640
<0> 017dbbb7ec537836 ffffffff81619840 ffff88022c58e640 0000000000000001
<0> 0000000000000004 0000000000000000 ffff880028199ea8 ffffffff810513fb
Call Trace:
 <IRQ> 
 [<ffffffff810bd00b>] ? handle_edge_irq+0x35/0x13d
 [<ffffffff810513fb>] wake_up_process+0x2a/0x40
 [<ffffffff810baf12>] handle_IRQ_event+0x169/0x1a1
 [<ffffffff810bd0b7>] handle_edge_irq+0xe1/0x13d
 [<ffffffff8100f031>] handle_irq+0x9d/0xbf
 [<ffffffff8100acc9>] ? exit_idle+0x33/0x49
 [<ffffffff813f0b12>] do_IRQ+0x72/0xd9
 [<ffffffff8100cc93>] ret_from_intr+0x0/0xa
 <EOI> 
 [<ffffffff810151dd>] ? mwait_idle+0x8b/0xb2
 [<ffffffff810151d0>] ? mwait_idle+0x7e/0xb2
 [<ffffffff8100abfe>] ? enter_idle+0x38/0x4e
 [<ffffffff8100b3da>] ? cpu_idle+0xae/0x100
 [<ffffffff813e3f4e>] ? start_secondary+0x19d/0x1b8
Code: 28 0f 1f 44 00 00 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 80 3d 09 e4 5c 00 00 41 89 d6 89 4d bc 49 89 fc 89 f3 44 0f 49 f0 <83> 7f 24 63 44 0f 4e f0 48 8d 75 c8 89 db e8 95 53 ff ff 48 89 
RIP  [<ffffffff81050fe6>] try_to_wake_up+0x3b/0x2e2
 RSP <ffff880028199e38>
CR2: 0000000000000024
---[ end trace f21e517c335b6dab ]---
Kernel panic - not syncing: Fatal exception in interrupt

Thanks,
Sripathi.

<snip>
