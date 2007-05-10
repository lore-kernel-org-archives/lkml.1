Return-Path: <linux-kernel-owner+w=401wt.eu-S1761164AbXEJMyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761164AbXEJMyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbXEJMyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:54:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:56514 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbXEJMya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Qr4xkMWLDpGobBgWHCC78l2BbBf66xvEjM4asuyXZVaHcSRNjjXxxCB0XxrLbOKDKqYbIOqI6k7KllpJjodKoGh87OiKO6Xd1/2b+6EJig6IGw8JGBTTWddBZybPu+jEYWf4hQSMrazVayCdSXqSQO4XqQMW/zeWGL0Zx3mhUfU=
Message-ID: <464315FF.3060203@googlemail.com>
Date: Thu, 10 May 2007 14:54:23 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [BUG] Re: mm snapshot broken-out-2007-05-10-03-06.tar.gz uploaded
References: <200705101009.l4AA9kY8017872@shell0.pdx.osdl.net>
In-Reply-To: <200705101009.l4AA9kY8017872@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-05-10-03-06.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-05-10-03-06.tar.gz
> 

Bug reported here http://lkml.org/lkml/2007/4/25/400 is back.

[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000001]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000001]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000002]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000003]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000004]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000006]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000006]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000006]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000007]   --------------------------------------------------------------------------
[    0.000007]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000007]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000007]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000007]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000007]   --------------------------------------------------------------------------
[    0.000007]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000007]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000007]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000007]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000007]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |irq event stamp: 472
[    0.000008] hardirqs last  enabled at (472): [<c020e4d6>] irqsafe2A_rlock_12+0xb6/0xc7
[    0.000008] hardirqs last disabled at (471): [<c010a900>] native_sched_clock+0x70/0x118
[    0.000008] softirqs last  enabled at (468): [<c020e4c1>] irqsafe2A_rlock_12+0xa1/0xc7
[    0.000008] softirqs last disabled at (464): [<c020e42c>] irqsafe2A_rlock_12+0xc/0xc7
[    0.000008] FAILED| [<c0105276>] dump_trace+0x63/0x1eb
[    0.000008]  [<c0105418>] show_trace_log_lvl+0x1a/0x30
[    0.000008]  [<c010605a>] show_trace+0x12/0x14
[    0.000008]  [<c01060f7>] dump_stack+0x16/0x18
[    0.000008]  [<c020c0eb>] dotest+0x8d/0x3f4
[    0.000008]  [<c0216879>] locking_selftest+0x915/0x1a58
[    0.000008]  [<c04fa8f3>] start_kernel+0x27d/0x34f
[    0.000008]  =======================
[    0.000008]
[    0.000008]        sirq-safe-A => hirqs-on/21:irq event stamp: 476
[    0.000008] hardirqs last  enabled at (476): [<c020e1e7>] irqsafe2A_spin_21+0x1c/0xc7
[    0.000008] hardirqs last disabled at (475): [<c010a900>] native_sched_clock+0x70/0x118
[    0.000008] softirqs last  enabled at (468): [<c020e4c1>] irqsafe2A_rlock_12+0xa1/0xc7
[    0.000008] softirqs last disabled at (464): [<c020e42c>] irqsafe2A_rlock_12+0xc/0xc7
[    0.000008]   ok  |irq event stamp: 480
[    0.000008] hardirqs last  enabled at (480): [<c020e375>] irqsafe2A_wlock_21+0x1c/0xc7
[    0.000008] hardirqs last disabled at (479): [<c010a900>] native_sched_clock+0x70/0x118
[    0.000008] softirqs last  enabled at (468): [<c020e4c1>] irqsafe2A_rlock_12+0xa1/0xc7
[    0.000008] softirqs last disabled at (464): [<c020e42c>] irqsafe2A_rlock_12+0xc/0xc7
[    0.000008]   ok  |irq event stamp: 484
[    0.000008] hardirqs last  enabled at (484): [<c020e503>] irqsafe2A_rlock_21+0x1c/0xc7
[    0.000008] hardirqs last disabled at (483): [<c010a900>] native_sched_clock+0x70/0x118
[    0.000008] softirqs last  enabled at (468): [<c020e4c1>] irqsafe2A_rlock_12+0xa1/0xc7
[    0.000008] softirqs last disabled at (464): [<c020e42c>] irqsafe2A_rlock_12+0xc/0xc7
[    0.000008] FAILED| [<c0105276>] dump_trace+0x63/0x1eb
[    0.000008]  [<c0105418>] show_trace_log_lvl+0x1a/0x30
[    0.000008]  [<c010605a>] show_trace+0x12/0x14
[    0.000008]  [<c01060f7>] dump_stack+0x16/0x18
[    0.000008]  [<c020c0eb>] dotest+0x8d/0x3f4
[    0.000008]  [<c02168cf>] locking_selftest+0x96b/0x1a58
[    0.000008]  [<c04fa8f3>] start_kernel+0x27d/0x34f
[    0.000008]  =======================
[    0.000008]
[    0.000008]          hard-safe-A + irqs-on/12:  ok  |  ok  |irq event stamp: 500
[    0.000008] hardirqs last  enabled at (500): [<c0212873>] irqsafe2B_hard_rlock_12+0xaf/0xc0
[    0.000008] hardirqs last disabled at (499): [<c010a900>] native_sched_clock+0x70/0x118
[    0.000008] softirqs last  enabled at (468): [<c020e4c1>] irqsafe2A_rlock_12+0xa1/0xc7
[    0.000008] softirqs last disabled at (464): [<c020e42c>] irqsafe2A_rlock_12+0xc/0xc7
[    0.000008] FAILED| [<c0105276>] dump_trace+0x63/0x1eb
[    0.000008]  [<c0105418>] show_trace_log_lvl+0x1a/0x30
[    0.000008]  [<c010605a>] show_trace+0x12/0x14
[    0.000008]  [<c01060f7>] dump_stack+0x16/0x18
[    0.000008]  [<c020c0eb>] dotest+0x8d/0x3f4
[    0.000008]  [<c0216925>] locking_selftest+0x9c1/0x1a58
[    0.000008]  [<c04fa8f3>] start_kernel+0x27d/0x34f
[    0.000008]  =======================
[    0.000008]
[    0.000008]          soft-safe-A + irqs-on/12:  ok  |  ok  |irq event stamp: 534
[    0.000008] hardirqs last  enabled at (534): [<c0129748>] local_bh_enable+0x1b9/0x1e5
[    0.000008] hardirqs last disabled at (533): [<c010a900>] native_sched_clock+0x70/0x118
[    0.000008] softirqs last  enabled at (532): [<c020e7ed>] irqsafe2B_soft_rlock_12+0xb5/0xc5
[    0.000008] softirqs last disabled at (530): [<c020e7de>] irqsafe2B_soft_rlock_12+0xa6/0xc5
[    0.000008] FAILED| [<c0105276>] dump_trace+0x63/0x1eb
[    0.000008]  [<c0105418>] show_trace_log_lvl+0x1a/0x30
[    0.000008]  [<c010605a>] show_trace+0x12/0x14
[    0.000008]  [<c01060f7>] dump_stack+0x16/0x18
[    0.000008]  [<c020c0eb>] dotest+0x8d/0x3f4
[    0.000008]  [<c021697b>] locking_selftest+0xa17/0x1a58
[    0.000008]  [<c04fa8f3>] start_kernel+0x27d/0x34f
[    0.000008]  =======================
[    0.000008]
[    0.000008]          hard-safe-A + irqs-on/21:irq event stamp: 538
[    0.000008] hardirqs last  enabled at (538): [<c0212720>] irqsafe2B_hard_spin_21+0x1c/0xc0
[    0.000008] hardirqs last disabled at (537): [<c010a900>] native_sched_clock+0x70/0x118
[    0.000008] softirqs last  enabled at (532): [<c020e7ed>] irqsafe2B_soft_rlock_12+0xb5/0xc5
[    0.000008] softirqs last disabled at (530): [<c020e7de>] irqsafe2B_soft_rlock_12+0xa6/0xc5
[    0.000008]   ok  |irq event stamp: 542
[    0.000008] hardirqs last  enabled at (542): [<c0212a20>] irqsafe2B_hard_wlock_21+0x1c/0xc0
[    0.000008] hardirqs last disabled at (541): [<c010a900>] native_sched_clock+0x70/0x118
[    0.000008] softirqs last  enabled at (532): [<c020e7ed>] irqsafe2B_soft_rlock_12+0xb5/0xc5
[    0.000008] softirqs last disabled at (530): [<c020e7de>] irqsafe2B_soft_rlock_12+0xa6/0xc5
[    0.000008]   ok  |irq event stamp: 546
[    0.000008] hardirqs last  enabled at (546): [<c02128a0>] irqsafe2B_hard_rlock_21+0x1c/0xc0
[    0.000008] hardirqs last disabled at (545): [<c010a900>] native_sched_clock+0x70/0x118
[    0.000008] softirqs last  enabled at (532): [<c020e7ed>] irqsafe2B_soft_rlock_12+0xb5/0xc5
[    0.000008] softirqs last disabled at (530): [<c020e7de>] irqsafe2B_soft_rlock_12+0xa6/0xc5
[    0.000008] FAILED| [<c0105276>] dump_trace+0x63/0x1eb
[    0.000008]  [<c0105418>] show_trace_log_lvl+0x1a/0x30
[    0.000008]  [<c010605a>] show_trace+0x12/0x14
[    0.000008]  [<c01060f7>] dump_stack+0x16/0x18
[    0.000008]  [<c020c0eb>] dotest+0x8d/0x3f4
[    0.000008]  [<c02169d1>] locking_selftest+0xa6d/0x1a58
[    0.000008]  [<c04fa8f3>] start_kernel+0x27d/0x34f
[    0.000008]  =======================
[    0.000008]
[    0.000008]          soft-safe-A + irqs-on/21:irq event stamp: 552
[    0.000008] hardirqs last  enabled at (552): [<c0129748>] local_bh_enable+0x1b9/0x1e5
[    0.000008] hardirqs last disabled at (551): [<c010a900>] native_sched_clock+0x70/0x118
[    0.000008] softirqs last  enabled at (550): [<c020e68e>] irqsafe2B_soft_spin_21+0x1b/0xc5
[    0.000008] softirqs last disabled at (548): [<c020e67f>] irqsafe2B_soft_spin_21+0xc/0xc5
[    0.000008]   ok  |irq event stamp: 558
[    0.000008] hardirqs last  enabled at (558): [<c0129748>] local_bh_enable+0x1b9/0x1e5
[    0.000008] hardirqs last disabled at (557): [<c010a900>] native_sched_clock+0x70/0x118
[    0.000008] softirqs last  enabled at (556): [<c020e9a2>] irqsafe2B_soft_wlock_21+0x1b/0xc5
[    0.000008] softirqs last disabled at (554): [<c020e993>] irqsafe2B_soft_wlock_21+0xc/0xc5
[    0.000008]   ok  |irq event stamp: 564
[    0.000008] hardirqs last  enabled at (564): [<c0129748>] local_bh_enable+0x1b9/0x1e5
[    0.000008] hardirqs last disabled at (563): [<c010a900>] native_sched_clock+0x70/0x118
[    0.000008] softirqs last  enabled at (562): [<c020e818>] irqsafe2B_soft_rlock_21+0x1b/0xc5
[    0.000008] softirqs last disabled at (560): [<c020e809>] irqsafe2B_soft_rlock_21+0xc/0xc5
[    0.000008] FAILED| [<c0105276>] dump_trace+0x63/0x1eb
[    0.000008]  [<c0105418>] show_trace_log_lvl+0x1a/0x30
[    0.000008]  [<c010605a>] show_trace+0x12/0x14
[    0.000008]  [<c01060f7>] dump_stack+0x16/0x18
[    0.000008]  [<c020c0eb>] dotest+0x8d/0x3f4
[    0.000008]  [<c0216a27>] locking_selftest+0xac3/0x1a58
[    0.000008]  [<c04fa8f3>] start_kernel+0x27d/0x34f
[    0.000008]  =======================
[    0.000008]
[    0.000008]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000008]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000009]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000009]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000009]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000010]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000010]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000010]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000010]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000010]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000011]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000011]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000011]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000011]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000011]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000012]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000012]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000012]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000012]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000013]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000013]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000013]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000013]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000013]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000014]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000014]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000014]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000014]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000014]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000015]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000015]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000015]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000015]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000015]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000016]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000016]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000016]       hard-irq read-recursion/123:  ok  |
[    0.000016]       soft-irq read-recursion/123:  ok  |
[    0.000016]       hard-irq read-recursion/132:  ok  |
[    0.000016]       soft-irq read-recursion/132:  ok  |
[    0.000016]       hard-irq read-recursion/213:  ok  |
[    0.000016]       soft-irq read-recursion/213:  ok  |
[    0.000016]       hard-irq read-recursion/231:  ok  |
[    0.000017]       soft-irq read-recursion/231:  ok  |
[    0.000017]       hard-irq read-recursion/312:  ok  |
[    0.000017]       soft-irq read-recursion/312:  ok  |
[    0.000017]       hard-irq read-recursion/321:  ok  |
[    0.000017]       soft-irq read-recursion/321:  ok  |
[    0.000017] -----------------------------------------------------------------
[    0.000017] BUG:   6 unexpected failures (out of 218) - debugging disabled! |
[    0.000017] -----------------------------------------------------------------

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-05-10-03-06/mm-config
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-05-10-03-06/mm-dmesg

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
