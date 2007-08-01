Return-Path: <linux-kernel-owner+w=401wt.eu-S1761058AbXHAHa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761058AbXHAHa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbXHAHau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:30:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317AbXHAHat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:30:49 -0400
Date: Wed, 1 Aug 2007 09:30:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070801073042.GB21551@elte.hu>
References: <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801071230.GA16375@elte.hu> <1185953195.6388.21.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185953195.6388.21.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > Thanks for the testing and the feedback, it's much appreciated! :-) 
> > On what platform did you do your tests, and what .config did you use 
> > (and could you please send me your .config)?
> > 
> > Please also send me the output of this script:
> > 
> >   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> > 
> > (if the output is too large send it to me privately, or bzip2 -9 
> > it.)
> > 
> > Could you also please send the source code for the "l.c" and "lt.c" 
> > apps you used for your testing so i can have a look. Thanks!
> 
> I haven't been able to reproduce this with any combination of 
> features, and massive_intr tweaked to his work/sleep cycle.  I notice 
> he's collecting stats though, and they look funky.  Recompiling.

yeah, the posted numbers look most weird, but there's a complete lack of 
any identification of test environment - so we'll need some more word 
from Roman. Perhaps this was run on some really old box that does not 
have a high-accuracy sched_clock()? The patch below should simulate that 
scenario on 32-bit x86.

	Ingo

Index: linux/arch/i386/kernel/tsc.c
===================================================================
--- linux.orig/arch/i386/kernel/tsc.c
+++ linux/arch/i386/kernel/tsc.c
@@ -110,7 +110,7 @@ unsigned long long native_sched_clock(vo
 	 *   very important for it to be as fast as the platform
 	 *   can achive it. )
 	 */
-	if (unlikely(!tsc_enabled && !tsc_unstable))
+//	if (unlikely(!tsc_enabled && !tsc_unstable))
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
