Return-Path: <linux-kernel-owner+w=401wt.eu-S932676AbZACUgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbZACUgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZACUgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:36:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbZACUge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:36:34 -0500
Date: Sat, 3 Jan 2009 21:36:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] cpus4096 tree, part 3
Message-ID: <20090103203621.GA2491@elte.hu>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain> <20090103193859.GB9805@elte.hu> <alpine.LFD.2.00.0901031225020.3179@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901031225020.3179@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 3 Jan 2009, Ingo Molnar wrote:
> > 
> > ok. The pending regressions are all fixed now, and i've just finished 
> > my standard tests on the latest tree and all the tests passed fine.
> 
> Ok, pulled and pushed out.

thanks!

> Has anybody looked at what the stack size is with MAXSMP set with an 
> allyesconfig? And what areas are still problematic, if any? Are we going 
> to have some code-paths that still essentially have 1kB+ of stack space 
> just because they haven't been converted and still have the cpu mask on 
> stack?

ok, indeed testing of that is in order now.

I'll check what the worst-case runtime stack footprint is for an 
allyesconfig 64-bit bootup - that should be the worst-case scenario on 
x86. We have a low number of leftover places, but the serious ones like 
the IPI paths, which triggered stack overflows in the past, got all fixed.

The test is underway with:

 CONFIG_64BIT=y
 CONFIG_NR_CPUS=4096
 CONFIG_MAXSMP=y

	Ingo
