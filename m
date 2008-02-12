Return-Path: <linux-kernel-owner+w=401wt.eu-S1762228AbYBLStt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228AbYBLStt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763511AbYBLSti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:49:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762298AbYBLStg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:49:36 -0500
Date: Tue, 12 Feb 2008 10:48:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <1202840682.3137.83.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>  <20080212044314.GA4888@kroah.com>  <20080211211751.3e265754@laptopd505.fenrus.org>  <20080211.221126.230471463.davem@davemloft.net>  <47B1CB08.4020101@garzik.org> 
 <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>  <1202838082.3137.54.camel@localhost.localdomain>  <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org> <1202840682.3137.83.camel@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, James Bottomley wrote:
> 
> Hm ... I think net is a counter example to this.  Rebases certainly work
> for them.

They consider themselves to be "one tree" and are thus largely a totally 
different issue than the one discussed here.

Also, I actually flamed David a lot last round over his rebasing of 
netfilter etc. It was no acceptably done. That network tree was all 
screwed up, with the git committer information not matching the signed-off 
path etc.

If you do cross-tree rebasing, you need to consider it 100% equivalent to 
just passing patches around in emails. Because it really is.

> Yes ... I don't do that ... Like I said, I only rebase for an actual
> conflict.

And this is how things should work. 

> Well, it came at me because Jens was rebasing the block tree as he
> worked through issues in the two branches I was based on.

Yes, and I am in no way saying that the core driver model has been the 
only problem spot.

And also, I do not like "hard rules". Every rule always has an exception, 
and sometimes a rebase-based strategy can be the right thing even across 
trees. 

But you're all ignoring my fundamental objection: you're talking as if 
cross-tree fundamental API changes should be the "norm", and that we 
should try to solve the workflow issues that stem from that. And I'm 
saying that I think we should try to FIX the issue, and make sure that 
it simply *isn't* the norm.

In other words, I'm perfectly happy to be an a*hole and tell people that I 
simply won't merge things that cause undue API churn at all, and that were 
not thought out sufficiently.

We've had too many issues like that (SG chaining, iommu, driver core, not 
to mention the upheavals in x86) lately, but realistically, which 
subsystem remains a problem for the future? And maybe the correct thing to 
do is to just say "enough!".

I'm perfectly happy being hardnosed and saying "nope, that's crap, it 
doesn't matter if the code is slightly better if you cause those kinds of 
issues".

The thing is, sometimes the answer really *is* "Don't do that then!". If 
our model becomes bogged up by cross-subsystem serialization issues, that 
means that we (a) spend too much time handling the fall-out from that and 
(b) too little time just refining the details.

And quite frankly, while "good core architecture" matters a lot, in the 
end, "getting all the boring small things right" matters even more! Big 
architectural churn that cleans up and fixes the "big issues" is totally 
anti-productive if it means that we don't look at the boring small detail 
stuff.

			Linus
