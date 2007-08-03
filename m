Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbXHCGba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbXHCGba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 02:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbXHCGbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 02:31:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783AbXHCGbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 02:31:22 -0400
Date: Fri, 3 Aug 2007 08:31:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: SD still better than CFS for 3d   ?(was Re: 2.6.23-rc1)
Message-ID: <20070803063104.GA24598@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <1185839164.27166.7.camel@localhost> <1185863461.3092.4.camel@twins> <20070731085713.GA15136@elte.hu> <1186011827.2482.1.camel@localhost> <20070802121018.GA11900@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802121018.GA11900@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> do you have any filesystem that is not reiserfs? If yes, could you, as 
> a test, check whether file activities on _that_ file system still 
> cause these lags, or is the lag purely connected to the reiser3 
> filesystem?

i still have little debug info from you to start from: no 
cfs-debug-info.sh output of the problematic workload and no kernel 
.config.

i tried to reproduce your problems based on your existing description: i 
did a lot of reiser3 testing yesterday and i also wrote a 'BKL latency 
simulator' (which does a faux lock_kernel() + unlock_kernel() so that 
the testcode runs into the BKL all the time) - but still this had no 
visible effect on desktop latencies so either i have some subtle 
difference in my setup or this aspect of your workload is not the cause 
of the smoothness problem.

could please give us more debug info and try to simplify the "bad" case 
down to something that can be pinpointed and triggered more exactly? Do 
you see any particular 'ruckle' in the 3D game when you see a smoothness 
problem? Anything that we could clearly label as 'anomalous latency' in 
a tracer output? (in that case i'll send you tracing patches so that we 
can catch a trace of that 'hickup')

You said the imap stuff could be causing the smoothness problem: as a 
debugging thing could you try to renice all the imap activities (imap 
daemon / mailer) to nice +19, does that make the game magically smooth 
again? If yes then this is an indicator that the problem is interaction 
between the game and the imap activities.

	Ingo
