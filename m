Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZB0G6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZB0G6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 01:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZB0G5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 01:57:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49179 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758241AbZB0G5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 01:57:47 -0500
Date: Fri, 27 Feb 2009 07:57:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com
Subject: Re: [patch] x86: optimize __pa() to be linear again on 64-bit x86
Message-ID: <20090227065717.GA5207@elte.hu>
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <20090223101741.GP9582@elte.hu> <20090223133804.GA20468@elte.hu> <200902240108.54892.nickpiggin@yahoo.com.au> <20090223145358.GB3377@elte.hu> <49A780E0.7020508@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A780E0.7020508@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> Ingo Molnar wrote:
> > Yeah, we can do this complete conversion.
> >
> > I'll clean it up some more. I think the best representation of 
> > this will be via a virt_to_sym() and sym_to_virt() space. That 
> > makes it really clear when we are moving from the symbol space 
> > to the linear space and back.
> 
> For arch code, maybe it's maintainable but with my driver developer
> hat on I gotta say virt_to_page() not working on .data/.bss is quite
> scary. [...]

Well, we have a debug mechanism in place.

As i suggested it in my first mail we can run with debug enabled 
for a cycle and then turn on the optimization by default (with 
the debug option still available too).

Drivers doing DMA on .data/.bss items is rather questionable 
anyway (and dangerous as well, on any platform where there's 
coherency problems if DMA is misaligned, etc.), and a quick look 
shows there's at most 2-3 dozen examples of that in all of 
drivers/*.

	Ingo
