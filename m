Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbXK1LVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbXK1LVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 06:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758696AbXK1LU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 06:20:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54660 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855AbXK1LU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:20:58 -0500
Date: Wed, 28 Nov 2007 12:20:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bdupree@techfinesse.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Dynticks Causing High Context Switch Rate in ksoftirqd
Message-ID: <20071128112038.GG22039@elte.hu>
References: <41877.67.173.156.207.1196130992.squirrel@www.techfinesse.net> <20071127212217.a7ac0407.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127212217.a7ac0407.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 26 Nov 2007 20:36:32 -0600 (CST) bdupree@techfinesse.com wrote:
> 
> > Question: Why is ksoftirqd eating about 5 to 10 percent of my CPU on an idle
> > system? The problem occurs if I config the kernel with tickless
> > support (i.e. CONFIG_TICK_ONESHOT=y).  (Thanks to "oprofile" for putting me
> > onto this.)
> 
> beware that oprofile can provide misleading results on a paritally-idle
> system.  You may have discovered that ksoftirqd is consuming 5-10% of the
> non-idle time on that idle system, which is less surprising.
> 
> > I have noted this same problem on kernel versions: 2.6.23.1, 2.6.23.8 and
> > 2.6.23.9
> > 
> > **************************************************************************
> > *** Output from "vmstat -n 1 10" -- Note very high context switch rate ***
> > *** This is on a idle machine!                                         ***
> > **************************************************************************
> > 
> > procs -----------memory---------- ---swap-- -----io---- --system--
> > ----cpu----
> >  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
> > id wa
> >  0  0      0 1925556   4768 116104    0    0   124     2    6  7538  1  2
> > 96  1
> >  0  0      0 1925556   4768 116104    0    0     0     0    2 147329  0  1
> > 99  0
> >  0  0      0 1925548   4768 116104    0    0     0     0    0 154515  0  1
> > 99  0
> >  0  0      0 1925548   4768 116104    0    0     0     0    1 153898  0  2
> > 98  0
> >  0  0      0 1925548   4780 116104    0    0     0    16    3 155216  0  1
> > 99  0
> >  0  0      0 1925548   4780 116104    0    0     0     0    1 161718  0  1
> > 99  0
> >  0  0      0 1925548   4780 116104    0    0     0     0    0 147587  0  2
> > 98  0
> >  0  0      0 1925548   4780 116104    0    0     0     0    1 153524  0  2
> > 98  0
> >  0  0      0 1925448   4780 116104    0    0     0     0    0 153434  0  1
> > 99  0
> >  0  0      0 1925448   4792 116092    0    0     0    16    4 153527  0  2
> > 98  0
> 
> So what piece of code is scheduling so much?  What does `top' say?  
> What does the (sorted) output of oprofile look like?
> 
> Did you try shutting down as much userspace code as possible to find 
> out if some userspace task is misbehaving?

such 'what the heck is happening' problems can also be debugged via the 
tracer. Here's a quickstart:

  http://redhat.com/~mingo/latency-tracing-patches/tracing-QuickStart.txt

	Ingo
