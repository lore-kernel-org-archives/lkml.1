Return-Path: <linux-kernel-owner+w=401wt.eu-S1030576AbXDQBIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030576AbXDQBIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 21:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031043AbXDQBIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 21:08:42 -0400
Received: from av1.karneval.cz ([81.27.192.123]:26317 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030576AbXDQBIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 21:08:41 -0400
X-Greylist: delayed 1828 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2007 21:08:40 EDT
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Tue, 17 Apr 2007 02:37:39 +0200
User-Agent: KMail/1.9.4
Cc: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <200704160109.31310.pisa@cmp.felk.cvut.cz> <Pine.LNX.4.64.0704152243110.8382@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0704152243110.8382@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704170237.41541.pisa@cmp.felk.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007 07:47, Davide Libenzi wrote:
> On Mon, 16 Apr 2007, Pavel Pisa wrote:
> > I cannot help myself to not report results with GAVL
> > tree algorithm there as an another race competitor.
> > I believe, that it is better solution for large priority
> > queues than RB-tree and even heap trees. It could be
> > disputable if the scheduler needs such scalability on
> > the other hand. The AVL heritage guarantees lower height
> > which results in shorter search times which could
> > be profitable for other uses in kernel.
> >
> > GAVL algorithm is AVL tree based, so it does not suffer from
> > "infinite" priorities granularity there as TR does. It allows
> > use for generalized case where tree is not fully balanced.
> > This allows to cut the first item withour rebalancing.
> > This leads to the degradation of the tree by one more level
> > (than non degraded AVL gives) in maximum, which is still
> > considerably better than RB-trees maximum.
> >
> > http://cmp.felk.cvut.cz/~pisa/linux/smart-queue-v-gavl.c
>
> Here are the results on my Opteron 252:
>
> Testing N=1
> gavl_cfs = 187.20 cycles/loop
> CFS = 194.16 cycles/loop
> TR  = 314.87 cycles/loop
> CFS = 194.15 cycles/loop
> gavl_cfs = 187.15 cycles/loop
>
> Testing N=2
> gavl_cfs = 268.94 cycles/loop
> CFS = 305.53 cycles/loop
> TR  = 313.78 cycles/loop
> CFS = 289.58 cycles/loop
> gavl_cfs = 266.02 cycles/loop
>
> Testing N=4
> gavl_cfs = 452.13 cycles/loop
> CFS = 518.81 cycles/loop
> TR  = 311.54 cycles/loop
> CFS = 516.23 cycles/loop
> gavl_cfs = 450.73 cycles/loop
>
> Testing N=8
> gavl_cfs = 609.29 cycles/loop
> CFS = 644.65 cycles/loop
> TR  = 308.11 cycles/loop
> CFS = 667.01 cycles/loop
> gavl_cfs = 592.89 cycles/loop
>
> Testing N=16
> gavl_cfs = 686.30 cycles/loop
> CFS = 807.41 cycles/loop
> TR  = 317.20 cycles/loop
> CFS = 810.24 cycles/loop
> gavl_cfs = 688.42 cycles/loop
>
> Testing N=32
> gavl_cfs = 756.57 cycles/loop
> CFS = 852.14 cycles/loop
> TR  = 301.22 cycles/loop
> CFS = 876.12 cycles/loop
> gavl_cfs = 758.46 cycles/loop
>
> Testing N=64
> gavl_cfs = 831.97 cycles/loop
> CFS = 997.16 cycles/loop
> TR  = 304.74 cycles/loop
> CFS = 1003.26 cycles/loop
> gavl_cfs = 832.83 cycles/loop
>
> Testing N=128
> gavl_cfs = 897.33 cycles/loop
> CFS = 1030.36 cycles/loop
> TR  = 295.65 cycles/loop
> CFS = 1035.29 cycles/loop
> gavl_cfs = 892.51 cycles/loop
>
> Testing N=256
> gavl_cfs = 963.17 cycles/loop
> CFS = 1146.04 cycles/loop
> TR  = 295.35 cycles/loop
> CFS = 1162.04 cycles/loop
> gavl_cfs = 966.31 cycles/loop
>
> Testing N=512
> gavl_cfs = 1029.82 cycles/loop
> CFS = 1218.34 cycles/loop
> TR  = 288.78 cycles/loop
> CFS = 1257.97 cycles/loop
> gavl_cfs = 1029.83 cycles/loop
>
> Testing N=1024
> gavl_cfs = 1091.76 cycles/loop
> CFS = 1318.47 cycles/loop
> TR  = 287.74 cycles/loop
> CFS = 1311.72 cycles/loop
> gavl_cfs = 1093.29 cycles/loop
>
> Testing N=2048
> gavl_cfs = 1153.03 cycles/loop
> CFS = 1398.84 cycles/loop
> TR  = 286.75 cycles/loop
> CFS = 1438.68 cycles/loop
> gavl_cfs = 1149.97 cycles/loop
>
>
> There seem to be some difference from your numbers. This is with:
>
> gcc version 4.1.2
>
> and -O2. But then and Opteron can behave quite differentyl than a Duron on
> a bench like this ;)

Thanks for testing, but yours numbers are more correct
than my first report. My numbers seemed to be over-optimistic even
to me, In the fact I have been surprised that difference is so high.
But I have tested bad version of code without GAVL_FAFTER option
set. The code pushed to the web page has been the correct one.
I have not get to look into case until now because I have busy day
to prepare some Linux based labs at university.

Without GAVL_FAFTER option, insert operation does fail
if item with same key is already inserted (intended feature of
the code) and as result of that, not all items have been inserted
in the test. The meaning of GAVL_FAFTER is find/insert after
all items with the same key value. Default behavior is
operate on unique keys in tree and reject duplicates.

My results are even worse for GAVL than yours.
It is possible to try tweak code and optimize it more
(likely/unlikely/do not keep last ptr etc) for this actual usage.
May it be, that I try this exercise, but I do not expect that
the result after tuning would be so much better, that it would
outweight some redesign work. I could see some advantages of AVL
still, but it has its own drawbacks with need of separate height
field and little worse delete in the middle timing.

So excuse me for disturbance. I have been only curious how
GAVL code would behave in the comparison of other algorithms
and I did not kept my premature enthusiasm under the lock.

Best wishes

             Pavel Pisa 


./smart-queue-v-gavl -n 4
gavl_cfs = 279.02 cycles/loop
CFS = 200.87 cycles/loop
TR  = 229.55 cycles/loop
CFS = 201.23 cycles/loop
gavl_cfs = 276.08 cycles/loop

./smart-queue-v-gavl -n 8
gavl_cfs = 310.92 cycles/loop
CFS = 288.45 cycles/loop
TR  = 192.46 cycles/loop
CFS = 284.94 cycles/loop
gavl_cfs = 357.02 cycles/loop

./smart-queue-v-gavl -n 16
gavl_cfs = 350.45 cycles/loop
CFS = 354.01 cycles/loop
TR  = 189.79 cycles/loop
CFS = 320.08 cycles/loop
gavl_cfs = 387.43 cycles/loop

./smart-queue-v-gavl -n 32
gavl_cfs = 419.23 cycles/loop
CFS = 406.88 cycles/loop
TR  = 198.10 cycles/loop
CFS = 398.15 cycles/loop
gavl_cfs = 412.57 cycles/loop

./smart-queue-v-gavl -n 64
gavl_cfs = 442.81 cycles/loop
CFS = 429.62 cycles/loop
TR  = 235.40 cycles/loop
CFS = 389.54 cycles/loop
gavl_cfs = 433.56 cycles/loop

./smart-queue-v-gavl -n 128
gavl_cfs = 358.20 cycles/loop
CFS = 605.49 cycles/loop
TR  = 236.01 cycles/loop
CFS = 458.50 cycles/loop
gavl_cfs = 455.05 cycles/loop

./smart-queue-v-gavl -n 256
gavl_cfs = 529.72 cycles/loop
CFS = 530.98 cycles/loop
TR  = 193.75 cycles/loop
CFS = 533.75 cycles/loop
gavl_cfs = 471.47 cycles/loop

./smart-queue-v-gavl -n 512
gavl_cfs = 525.80 cycles/loop
CFS = 550.63 cycles/loop
TR  = 188.71 cycles/loop
CFS = 549.81 cycles/loop
gavl_cfs = 494.73 cycles/loop

./smart-queue-v-gavl -n 1024
gavl_cfs = 544.91 cycles/loop
CFS = 561.68 cycles/loop
TR  = 230.97 cycles/loop
CFS = 522.68 cycles/loop
gavl_cfs = 542.40 cycles/loop

./smart-queue-v-gavl -n 2048
gavl_cfs = 567.46 cycles/loop
CFS = 581.85 cycles/loop
TR  = 229.69 cycles/loop
CFS = 585.41 cycles/loop
gavl_cfs = 563.22 cycles/loop
