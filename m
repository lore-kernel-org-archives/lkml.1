Return-Path: <linux-kernel-owner+w=401wt.eu-S2993085AbXDYUYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993085AbXDYUYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993088AbXDYUYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:24:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:39032 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993085AbXDYUYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=q+a7cqtsgyELB4YVZS+hOib9KrTHEDQgHOUgLSba6Y+n+LBFAoUA4jBZz0B95ApEbuTcPcQd7tlWQFHm2Zhahu2RDCpGzUfcmvteOptE4lZ4e1Poh5AVDI/23koCkp7sj9jjFSb6kaTXbuviuXZz3QiHbwkAAHx+mSz35rU5UBI=
Message-ID: <462FB8E6.9070501@googlemail.com>
Date: Wed, 25 Apr 2007 22:24:06 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net>
In-Reply-To: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-04-25-02-49.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-25-02-49.tar.gz
> 
> It contains the following patches against 2.6.21-rc7:
>

My network doesn't work

$ ping 192.168.0.1
connect: Network is unreachable

NIC: 
02:05.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T [Marvell] (rev 12)

quilt patches drivers/net/skge.c
patches/git-netdev-all.patch
patches/git-net.patch

Bisection...



Timing information is broken

[4294667.634000] initcall 0xc050fe9e: init_scsi+0x0/0x91() returned 0.
[4294667.634000] initcall 0xc050fe9e ran for 1 msecs: init_scsi+0x0/0x91()
[4294667.634000] Calling initcall 0xc0510211: ata_init+0x0/0x6e()
[    0.338094] libata version 2.20 loaded.
[    0.338149] initcall 0xc0510211: ata_init+0x0/0x6e() returned 0.
[    0.338274] initcall 0xc0510211 ran for 0 msecs: ata_init+0x0/0x6e()
[    0.338364] Calling initcall 0xc05102a9: usb_init+0x0/0x105()
[4294667.635000] usbcore: registered new interface driver usbfs
[4294667.635000] usbcore: registered new interface driver hub
[    0.339357] usbcore: registered new device driver usb
[    0.339413] initcall 0xc05102a9: usb_init+0x0/0x105() returned 0.
[    0.339540] initcall 0xc05102a9 ran for 0 msecs: usb_init+0x0/0x105()
[    0.339635] Calling initcall 0xc0510570: serio_init+0x0/0xad()
[4294667.636000] initcall 0xc0510570: serio_init+0x0/0xad() returned 0.
[4294667.636000] initcall 0xc0510570 ran for 0 msecs: serio_init+0x0/0xad()
[4294667.636000] Calling initcall 0xc051094b: input_init+0x0/0xfe()


Ingo, this might be interesting for you.

[4294667.296000] ------------------------
[4294667.296000] | Locking API testsuite:
[4294667.296000] ----------------------------------------------------------------------------
[4294667.296000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[4294667.296000]   --------------------------------------------------------------------------
[4294667.296000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[4294667.296000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[4294667.296001]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[4294667.296001]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[4294667.296002]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[4294667.296003]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[4294667.296004]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[4294667.296006]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[4294667.296006]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[4294667.296006]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[4294667.296007]   --------------------------------------------------------------------------
[4294667.296007]               recursive read-lock:             |  ok  |             |  ok  |
[4294667.296007]            recursive read-lock #2:             |  ok  |             |  ok  |
[4294667.296007]             mixed read-write-lock:             |  ok  |             |  ok  |
[4294667.296007]             mixed write-read-lock:             |  ok  |             |  ok  |
[4294667.296007]   --------------------------------------------------------------------------
[4294667.296007]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[4294667.296007]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[4294667.296007]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[4294667.296007]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[4294667.296007]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |irq event stamp: 472
[4294667.296008] hardirqs last  enabled at (472): [<c020fe3a>] irqsafe2A_rlock_12+0xb6/0xc7
[4294667.296008] hardirqs last disabled at (471): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (468): [<c020fe25>] irqsafe2A_rlock_12+0xa1/0xc7
[4294667.296008] softirqs last disabled at (464): [<c020fd90>] irqsafe2A_rlock_12+0xc/0xc7
[4294667.296008] FAILED| [<c01052e0>] dump_trace+0x63/0x1eb
[4294667.296008]  [<c0105482>] show_trace_log_lvl+0x1a/0x30
[4294667.296008]  [<c01060c4>] show_trace+0x12/0x14
[4294667.296008]  [<c0106161>] dump_stack+0x16/0x18
[4294667.296008]  [<c020da4f>] dotest+0x8d/0x3f4
[4294667.296008]  [<c02181dd>] locking_selftest+0x915/0x1a58
[4294667.296008]  [<c04f88ed>] start_kernel+0x277/0x349
[4294667.296008]  =======================
[4294667.296008]
[4294667.296008]        sirq-safe-A => hirqs-on/21:irq event stamp: 476
[4294667.296008] hardirqs last  enabled at (476): [<c020fb4b>] irqsafe2A_spin_21+0x1c/0xc7
[4294667.296008] hardirqs last disabled at (475): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (468): [<c020fe25>] irqsafe2A_rlock_12+0xa1/0xc7
[4294667.296008] softirqs last disabled at (464): [<c020fd90>] irqsafe2A_rlock_12+0xc/0xc7
[4294667.296008]   ok  |irq event stamp: 480
[4294667.296008] hardirqs last  enabled at (480): [<c020fcd9>] irqsafe2A_wlock_21+0x1c/0xc7
[4294667.296008] hardirqs last disabled at (479): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (468): [<c020fe25>] irqsafe2A_rlock_12+0xa1/0xc7
[4294667.296008] softirqs last disabled at (464): [<c020fd90>] irqsafe2A_rlock_12+0xc/0xc7
[4294667.296008]   ok  |irq event stamp: 484
[4294667.296008] hardirqs last  enabled at (484): [<c020fe67>] irqsafe2A_rlock_21+0x1c/0xc7
[4294667.296008] hardirqs last disabled at (483): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (468): [<c020fe25>] irqsafe2A_rlock_12+0xa1/0xc7
[4294667.296008] softirqs last disabled at (464): [<c020fd90>] irqsafe2A_rlock_12+0xc/0xc7
[4294667.296008] FAILED| [<c01052e0>] dump_trace+0x63/0x1eb
[4294667.296008]  [<c0105482>] show_trace_log_lvl+0x1a/0x30
[4294667.296008]  [<c01060c4>] show_trace+0x12/0x14
[4294667.296008]  [<c0106161>] dump_stack+0x16/0x18
[4294667.296008]  [<c020da4f>] dotest+0x8d/0x3f4
[4294667.296008]  [<c0218233>] locking_selftest+0x96b/0x1a58
[4294667.296008]  [<c04f88ed>] start_kernel+0x277/0x349
[4294667.296008]  =======================
[4294667.296008]
[4294667.296008]
[4294667.296008]          hard-safe-A + irqs-on/12:  ok  |  ok  |irq event stamp: 500
[4294667.296008] hardirqs last  enabled at (500): [<c02141d7>] irqsafe2B_hard_rlock_12+0xaf/0xc0
[4294667.296008] hardirqs last disabled at (499): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (468): [<c020fe25>] irqsafe2A_rlock_12+0xa1/0xc7
[4294667.296008] softirqs last disabled at (464): [<c020fd90>] irqsafe2A_rlock_12+0xc/0xc7
[4294667.296008] FAILED| [<c01052e0>] dump_trace+0x63/0x1eb
[4294667.296008]  [<c0105482>] show_trace_log_lvl+0x1a/0x30
[4294667.296008]  [<c01060c4>] show_trace+0x12/0x14
[4294667.296008]  [<c0106161>] dump_stack+0x16/0x18
[4294667.296008]  [<c020da4f>] dotest+0x8d/0x3f4
[4294667.296008]  [<c0218289>] locking_selftest+0x9c1/0x1a58
[4294667.296008]  [<c04f88ed>] start_kernel+0x277/0x349
[4294667.296008]  =======================
[4294667.296008]
[4294667.296008]          soft-safe-A + irqs-on/12:  ok  |  ok  |irq event stamp: 534
[4294667.296008] hardirqs last  enabled at (534): [<c012abd8>] local_bh_enable+0x1b9/0x1e5
[4294667.296008] hardirqs last disabled at (533): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (532): [<c0210151>] irqsafe2B_soft_rlock_12+0xb5/0xc5
[4294667.296008] softirqs last disabled at (530): [<c0210142>] irqsafe2B_soft_rlock_12+0xa6/0xc5
[4294667.296008] FAILED| [<c01052e0>] dump_trace+0x63/0x1eb
[4294667.296008]  [<c0105482>] show_trace_log_lvl+0x1a/0x30
[4294667.296008]  [<c01060c4>] show_trace+0x12/0x14
[4294667.296008]  [<c0106161>] dump_stack+0x16/0x18
[4294667.296008]  [<c020da4f>] dotest+0x8d/0x3f4
[4294667.296008]  [<c02182df>] locking_selftest+0xa17/0x1a58
[4294667.296008]  [<c04f88ed>] start_kernel+0x277/0x349
[4294667.296008]  =======================
[4294667.296008]
[4294667.296008]          hard-safe-A + irqs-on/21:irq event stamp: 538
[4294667.296008] hardirqs last  enabled at (538): [<c0214084>] irqsafe2B_hard_spin_21+0x1c/0xc0
[4294667.296008] hardirqs last disabled at (537): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (532): [<c0210151>] irqsafe2B_soft_rlock_12+0xb5/0xc5
[4294667.296008] softirqs last disabled at (530): [<c0210142>] irqsafe2B_soft_rlock_12+0xa6/0xc5
[4294667.296008]   ok  |irq event stamp: 542
[4294667.296008] hardirqs last  enabled at (542): [<c0214384>] irqsafe2B_hard_wlock_21+0x1c/0xc0
[4294667.296008] hardirqs last disabled at (541): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (532): [<c0210151>] irqsafe2B_soft_rlock_12+0xb5/0xc5
[4294667.296008] softirqs last disabled at (530): [<c0210142>] irqsafe2B_soft_rlock_12+0xa6/0xc5
[4294667.296008]   ok  |irq event stamp: 546
[4294667.296008] hardirqs last  enabled at (546): [<c0214204>] irqsafe2B_hard_rlock_21+0x1c/0xc0
[4294667.296008] hardirqs last disabled at (545): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (532): [<c0210151>] irqsafe2B_soft_rlock_12+0xb5/0xc5
[4294667.296008] softirqs last disabled at (530): [<c0210142>] irqsafe2B_soft_rlock_12+0xa6/0xc5
[4294667.296008] FAILED| [<c01052e0>] dump_trace+0x63/0x1eb
[4294667.296008]  [<c0105482>] show_trace_log_lvl+0x1a/0x30
[4294667.296008]  [<c01060c4>] show_trace+0x12/0x14
[4294667.296008]  [<c0106161>] dump_stack+0x16/0x18
[4294667.296008]  [<c020da4f>] dotest+0x8d/0x3f4
[4294667.296008]  [<c0218335>] locking_selftest+0xa6d/0x1a58
[4294667.296008]  [<c04f88ed>] start_kernel+0x277/0x349
[4294667.296008]  =======================
[4294667.296008]
[4294667.296008]          soft-safe-A + irqs-on/21:irq event stamp: 552
[4294667.296008] hardirqs last  enabled at (552): [<c012abd8>] local_bh_enable+0x1b9/0x1e5
[4294667.296008] hardirqs last disabled at (551): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (550): [<c020fff2>] irqsafe2B_soft_spin_21+0x1b/0xc5
[4294667.296008] softirqs last disabled at (548): [<c020ffe3>] irqsafe2B_soft_spin_21+0xc/0xc5
[4294667.296008]   ok  |irq event stamp: 558
[4294667.296008]
[4294667.296008]          soft-safe-A + irqs-on/21:irq event stamp: 552
[4294667.296008] hardirqs last  enabled at (552): [<c012abd8>] local_bh_enable+0x1b9/0x1e5
[4294667.296008] hardirqs last disabled at (551): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (550): [<c020fff2>] irqsafe2B_soft_spin_21+0x1b/0xc5
[4294667.296008] softirqs last disabled at (548): [<c020ffe3>] irqsafe2B_soft_spin_21+0xc/0xc5
[4294667.296008]   ok  |irq event stamp: 558
[4294667.296008] hardirqs last  enabled at (558): [<c012abd8>] local_bh_enable+0x1b9/0x1e5
[4294667.296008] hardirqs last disabled at (557): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (556): [<c0210306>] irqsafe2B_soft_wlock_21+0x1b/0xc5
[4294667.296008] softirqs last disabled at (554): [<c02102f7>] irqsafe2B_soft_wlock_21+0xc/0xc5
[4294667.296008]   ok  |irq event stamp: 564
[4294667.296008] hardirqs last  enabled at (564): [<c012abd8>] local_bh_enable+0x1b9/0x1e5
[4294667.296008] hardirqs last disabled at (563): [<c010a9f1>] sched_clock+0x78/0x120
[4294667.296008] softirqs last  enabled at (562): [<c021017c>] irqsafe2B_soft_rlock_21+0x1b/0xc5
[4294667.296008] softirqs last disabled at (560): [<c021016d>] irqsafe2B_soft_rlock_21+0xc/0xc5
[4294667.296008] FAILED| [<c01052e0>] dump_trace+0x63/0x1eb
[4294667.296008]  [<c0105482>] show_trace_log_lvl+0x1a/0x30
[4294667.296008]  [<c01060c4>] show_trace+0x12/0x14
[4294667.296008]  [<c0106161>] dump_stack+0x16/0x18
[4294667.296008]  [<c020da4f>] dotest+0x8d/0x3f4
[4294667.296008]  [<c021838b>] locking_selftest+0xac3/0x1a58
[4294667.296008]  [<c04f88ed>] start_kernel+0x277/0x349
[4294667.296008]  =======================
[4294667.296008]
[4294667.296008]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[4294667.296008]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[4294667.296009]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[4294667.296009]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[4294667.296009]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[4294667.296010]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[4294667.296010]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[4294667.296010]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[4294667.296010]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[4294667.296010]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[4294667.296011]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[4294667.296011]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[4294667.296011]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[4294667.296011]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[4294667.296012]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[4294667.296012]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[4294667.296012]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[4294667.296012]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[4294667.296012]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[4294667.296013]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[4294667.296013]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[4294667.296013]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[4294667.296013]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[4294667.296013]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[4294667.296014]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[4294667.296014]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[4294667.296014]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[4294667.296014]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[4294667.296014]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[4294667.296015]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[4294667.296015]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[4294667.296015]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[4294667.296015]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[4294667.296015]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[4294667.296016]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[4294667.296016]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[4294667.296016]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[4294667.296016]       hard-irq read-recursion/123:  ok  |
[4294667.296016]       soft-irq read-recursion/123:  ok  |
[4294667.296016]       hard-irq read-recursion/132:  ok  |
[4294667.296016]       soft-irq read-recursion/132:  ok  |
[4294667.296016]       hard-irq read-recursion/213:  ok  |
[4294667.296016]       soft-irq read-recursion/213:  ok  |
[4294667.296016]       hard-irq read-recursion/231:  ok  |
[4294667.296017]       soft-irq read-recursion/231:  ok  |
[4294667.296017]       hard-irq read-recursion/312:  ok  |
[4294667.296017]       soft-irq read-recursion/312:  ok  |
[4294667.296017]       hard-irq read-recursion/321:  ok  |
[4294667.296017]       soft-irq read-recursion/321:  ok  |
[4294667.296017] -----------------------------------------------------------------
[4294667.296017] BUG:   6 unexpected failures (out of 218) - debugging disabled! |
[4294667.296017] -----------------------------------------------------------------

Jeremy?

[4294667.511000] BUG: at arch/i386/kernel/sched-clock.c:175 init_sched_clock()
[4294667.511000]  [<c01052e0>] dump_trace+0x63/0x1eb
[4294667.511000]  [<c0105482>] show_trace_log_lvl+0x1a/0x30
[4294667.511000]  [<c01060c4>] show_trace+0x12/0x14
[4294667.511000]  [<c0106161>] dump_stack+0x16/0x18
[4294667.511000]  [<c04fd968>] init_sched_clock+0x6d/0xcc
[4294667.512000]  [<c04f8505>] kernel_init+0x14e/0x2bf
[4294667.512000]  [<c0104ec3>] kernel_thread_helper+0x7/0x10
[4294667.512000]  =======================

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-25-02-49/mm-config
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-25-02-49/mm-dmesg

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
