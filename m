Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbYDWXXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbYDWXXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbYDWXXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:23:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59274
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbYDWXXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:23:09 -0400
Date: Wed, 23 Apr 2008 16:23:11 -0700 (PDT)
Message-Id: <20080423.162311.118426680.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, a.p.zijlstra@chello.nl
Subject: Re: [patch] softlockup: fix false positives on nohz if CPU is 100%
 idle for more than 60 seconds
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080423133656.GA23782@elte.hu>
References: <20080423.035544.110883549.davem@davemloft.net>
	<20080423.052928.142823681.davem@davemloft.net>
	<20080423133656.GA23782@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 23 Apr 2008 15:36:56 +0200

> as a temporary workaround please try the patch below, until we can 
> reproduce and fix the bug.

Yeah, if you basically turn off the code paths, that particular set of
problems goes away :-/

So then we're at the next bug, cpus getting wedged in the group
aggregate code.

I'll try Peter's patches which were posted today.

[  760.218048] BUG: soft lockup - CPU#5 stuck for 61s! [swapper:0]
[  760.218292] TSTATE: 0000000080001603 TPC: 000000000054e0c0 TNPC: 000000000054e0c4 Y: 00000000    Not tainted
[  760.218325] TPC: <find_next_bit+0xe4/0x11c>
[  760.218336] g0: 0000000000009000 g1: 0000000000000000 g2: ffffffffffffffff g3: 0000000000000030
[  760.218352] g4: fffff803ff0d5880 g5: fffff80007c8a000 g6: fffff803ff0ec000 g7: 00000000007bb6d0
[  760.218368] o0: 000000000000fff0 o1: 0000000000000040 o2: 0000000000000034 o3: 0000000000000000
[  760.218383] o4: 0000000100009332 o5: 0000000000000000 sp: fffff803ff0eee21 ret_pc: 000000000054de08
[  760.218402] RPC: <__next_cpu+0x18/0x2c>
[  760.218413] l0: 00000000007f0000 l1: 0000009980001602 l2: 0000000000455d2c l3: 0000000000000400
[  760.218428] l4: 0000000000000000 l5: 0000000000000002 l6: 0000000000000000 l7: 0000000000000008
[  760.218443] i0: 0000000000000033 i1: 00000000007bb6c8 i2: 0000000000000038 i3: fffff803f73bf100
[  760.218459] i4: 0000000000845000 i5: 0000000000000401 i6: fffff803ff0eeee1 i7: 0000000000455d48
[  760.218487] I7: <aggregate_group_shares+0x10c/0x16c>
[  823.716459] INFO: task collect2:4106 blocked for more than 120 seconds.
[  823.716680] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  823.716815] collect2      D 00000000006b4a80     0  4106   4105
[  823.716831] Call Trace:
[  823.716839]  [00000000006b4c40] schedule_timeout+0x20/0xa4
[  823.716859]  [00000000006b4a80] wait_for_common+0xf4/0x184
[  823.716875]  [000000000045f2cc] do_fork+0x1dc/0x234
[  823.716894]  [0000000000406214] linux_sparc_syscall32+0x3c/0x40
[  823.716917]  [0000000000023f50] 0x23f58

