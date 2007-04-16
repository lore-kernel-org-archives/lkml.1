Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbXDPFs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbXDPFs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 01:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbXDPFs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 01:48:29 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1120 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbXDPFs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 01:48:28 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 15 Apr 2007 22:47:18 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
cc: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <200704160109.31310.pisa@cmp.felk.cvut.cz>
Message-ID: <Pine.LNX.4.64.0704152243110.8382@alien.or.mcafeemobile.com>
References: <20070413202100.GA9957@elte.hu> <20070413222151.GD8915@holomorphy.com>
 <Pine.LNX.4.64.0704140008001.10930@alien.or.mcafeemobile.com>
 <200704160109.31310.pisa@cmp.felk.cvut.cz>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Pavel Pisa wrote:

> I cannot help myself to not report results with GAVL
> tree algorithm there as an another race competitor.
> I believe, that it is better solution for large priority
> queues than RB-tree and even heap trees. It could be
> disputable if the scheduler needs such scalability on
> the other hand. The AVL heritage guarantees lower height
> which results in shorter search times which could
> be profitable for other uses in kernel.
> 
> GAVL algorithm is AVL tree based, so it does not suffer from
> "infinite" priorities granularity there as TR does. It allows
> use for generalized case where tree is not fully balanced.
> This allows to cut the first item withour rebalancing.
> This leads to the degradation of the tree by one more level
> (than non degraded AVL gives) in maximum, which is still
> considerably better than RB-trees maximum.
> 
> http://cmp.felk.cvut.cz/~pisa/linux/smart-queue-v-gavl.c

Here are the results on my Opteron 252:

Testing N=1
gavl_cfs = 187.20 cycles/loop
CFS = 194.16 cycles/loop
TR  = 314.87 cycles/loop
CFS = 194.15 cycles/loop
gavl_cfs = 187.15 cycles/loop

Testing N=2
gavl_cfs = 268.94 cycles/loop
CFS = 305.53 cycles/loop
TR  = 313.78 cycles/loop
CFS = 289.58 cycles/loop
gavl_cfs = 266.02 cycles/loop

Testing N=4
gavl_cfs = 452.13 cycles/loop
CFS = 518.81 cycles/loop
TR  = 311.54 cycles/loop
CFS = 516.23 cycles/loop
gavl_cfs = 450.73 cycles/loop

Testing N=8
gavl_cfs = 609.29 cycles/loop
CFS = 644.65 cycles/loop
TR  = 308.11 cycles/loop
CFS = 667.01 cycles/loop
gavl_cfs = 592.89 cycles/loop

Testing N=16
gavl_cfs = 686.30 cycles/loop
CFS = 807.41 cycles/loop
TR  = 317.20 cycles/loop
CFS = 810.24 cycles/loop
gavl_cfs = 688.42 cycles/loop

Testing N=32
gavl_cfs = 756.57 cycles/loop
CFS = 852.14 cycles/loop
TR  = 301.22 cycles/loop
CFS = 876.12 cycles/loop
gavl_cfs = 758.46 cycles/loop

Testing N=64
gavl_cfs = 831.97 cycles/loop
CFS = 997.16 cycles/loop
TR  = 304.74 cycles/loop
CFS = 1003.26 cycles/loop
gavl_cfs = 832.83 cycles/loop

Testing N=128
gavl_cfs = 897.33 cycles/loop
CFS = 1030.36 cycles/loop
TR  = 295.65 cycles/loop
CFS = 1035.29 cycles/loop
gavl_cfs = 892.51 cycles/loop

Testing N=256
gavl_cfs = 963.17 cycles/loop
CFS = 1146.04 cycles/loop
TR  = 295.35 cycles/loop
CFS = 1162.04 cycles/loop
gavl_cfs = 966.31 cycles/loop

Testing N=512
gavl_cfs = 1029.82 cycles/loop
CFS = 1218.34 cycles/loop
TR  = 288.78 cycles/loop
CFS = 1257.97 cycles/loop
gavl_cfs = 1029.83 cycles/loop

Testing N=1024
gavl_cfs = 1091.76 cycles/loop
CFS = 1318.47 cycles/loop
TR  = 287.74 cycles/loop
CFS = 1311.72 cycles/loop
gavl_cfs = 1093.29 cycles/loop

Testing N=2048
gavl_cfs = 1153.03 cycles/loop
CFS = 1398.84 cycles/loop
TR  = 286.75 cycles/loop
CFS = 1438.68 cycles/loop
gavl_cfs = 1149.97 cycles/loop


There seem to be some difference from your numbers. This is with:

gcc version 4.1.2

and -O2. But then and Opteron can behave quite differentyl than a Duron on 
a bench like this ;)



- Davide


