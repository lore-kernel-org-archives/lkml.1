Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYBLTR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYBLTR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbYBLTRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:17:18 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35113 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819AbYBLTRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:17:16 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	 <20080212044314.GA4888@kroah.com>
	 <20080211211751.3e265754@laptopd505.fenrus.org>
	 <20080211.221126.230471463.davem@davemloft.net>
	 <47B1CB08.4020101@garzik.org>
	 <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
	 <1202838082.3137.54.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
	 <1202840682.3137.83.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 13:17:09 -0600
Message-Id: <1202843829.3137.111.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 10:48 -0800, Linus Torvalds wrote:
> But you're all ignoring my fundamental objection: you're talking as if 
> cross-tree fundamental API changes should be the "norm", and that we 
> should try to solve the workflow issues that stem from that. And I'm 
> saying that I think we should try to FIX the issue, and make sure that 
> it simply *isn't* the norm.

OK, I'll address it then (or try to).  Just don't eat me please ... I'm
only a small and timid storage maintainer ...

> In other words, I'm perfectly happy to be an a*hole and tell people that I 
> simply won't merge things that cause undue API churn at all, and that were 
> not thought out sufficiently.
> 
> We've had too many issues like that (SG chaining, iommu, driver core, not 
> to mention the upheavals in x86) lately, but realistically, which 
> subsystem remains a problem for the future? And maybe the correct thing to 
> do is to just say "enough!".

I can sort of agree, but I don't think you can say enough == no more API
changes.  There's the request_irq argument removal patch floating around
somewhere for instance ...but as someone said "Every rule always has an
exception".

I think what's really needed is a balance where it's painful (on the
originator) to make an API change.  Part of what -mc or -next trees can
do is to make that pain visible early (and often).

> I'm perfectly happy being hardnosed and saying "nope, that's crap, it 
> doesn't matter if the code is slightly better if you cause those kinds of 
> issues".

OK, so you can supply the pain as well.

> The thing is, sometimes the answer really *is* "Don't do that then!". If 
> our model becomes bogged up by cross-subsystem serialization issues, that 
> means that we (a) spend too much time handling the fall-out from that and 
> (b) too little time just refining the details.

I think this is exaggerated.  By the end of the -rc cycle for 2.6.24 I
had six merge fixup patches because of trivial cross subsystem API
changes and two dropped trees because of intractable problems (and they
were notified and later fixed themselves up).  Given that I was
including about 50 git trees and 4 quilt ones, that's not too bad,
Especially as we had all the API churn you mentioned.

> And quite frankly, while "good core architecture" matters a lot, in the 
> end, "getting all the boring small things right" matters even more! Big 
> architectural churn that cleans up and fixes the "big issues" is totally 
> anti-productive if it means that we don't look at the boring small detail 
> stuff.

I agree with this too.  When I introduce an API, I usually try to make
sure it will last the test of time ... the trouble is, I'm not always
omniscient.

So the point, I think we've reached is that:

     1. we want to try to enforce good design for APIs to try to ensure
        they're as future proof as foreseeable.
     2. We have to recognise that 1. is impossible in practice and
        provide a mechanism for correcting APIs

So, I think our current system is good in that it enforces pain on
people who change APIs.  However, perhaps we are missing the bit where
we reflect longer before introducing APIs in the first place. (hey,
better reviewing ... I've heard that one before ...)

James


