Return-Path: <linux-kernel-owner+w=401wt.eu-S965069AbXCQH41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069AbXCQH41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 03:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965105AbXCQH41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 03:56:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47386 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965069AbXCQH40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 03:56:26 -0400
Date: Sat, 17 Mar 2007 08:56:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: RSDL v0.31
Message-ID: <20070317075615.GC13685@elte.hu>
References: <200703042335.26785.a1426z@gawab.com> <200703170040.48316.kernel@kolivas.org> <1174059299.7886.25.camel@Homer.simpson.net> <200703170813.32594.kernel@kolivas.org> <1174084207.7009.9.camel@Homer.simpson.net> <1174105443.3144.4.camel@entropy> <1174110965.7911.44.camel@Homer.simpson.net> <1174112768.3144.8.camel@entropy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174112768.3144.8.camel@entropy>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nicholas Miell <nmiell@comcast.net> wrote:

> > I'm saying that the current scheduler adjusts for interactive loads, 
> > this new one doesn't.  I'm seeing interactivity regressions, and 
> > they are not fixed with nice unless nice is used to maximum effect.  
> > I'm saying yes, I can lower my expectations, but no I don't want to.
> 
> Uh, no. Essentially, the current scheduler works around X's 
> brokenness, in an often unpredictable manner.

No. The two schedulers simply use different heuristics. RSDL uses _less_ 
heuristics, and thus gets some workloads right that the heuristics in 
the current scheduler got wrong. But it also gets some other workloads 
wrong.

so basically, the current scheduler has a built-in "auto-nice" feature, 
while RSDL relies more on manual assignment of nice values.

if you want no heuristics at all you can do it in the current scheduler: 
use SCHED_BATCH on your shell and start up X with that. I'd not mind 
tweaking SCHED_BATCH with an RSDL-alike timeslice quota system.

so it is not at all clear to me that RSDL is indeed an improvement, if 
it does not have comparable auto-nice properties.

	Ingo
