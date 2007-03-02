Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbXCBH2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbXCBH2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 02:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932702AbXCBH2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 02:28:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59023 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbXCBH2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 02:28:52 -0500
Date: Fri, 2 Mar 2007 08:21:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070302072100.GB30634@elte.hu>
References: <20070227100202.GV3822@kernel.dk> <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu> <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> But most likely, 9f4bd5dd is actually already bad, and what you are 
> seeing is two *different* bugs that just have the same symptoms 
> ("suspend doesn't work").

the situation is simpler than that: there is a /known/ bug, and i marked 
the bugfix commit as 'good'. I never met such a multiple-bugs scenario 
before and forgot that git-bisect could easily pick a tree without this 
essential bugfix and would not be able to make a distinction between the 
two types of badness.

I'll try what i've described in the previous mail: mark all bisection 
points that do not include f3ccb06f as 'good' - thus 'merging' the 
known-bad area with the first known-good commit, and thus eliminating it 
from the bisection space.

(but it might also be useful to have a "git-bisect must-include" kind of 
command that would allow this to be automated: mark a particular tree as 
an essential component of the search space.)

	Ingo
