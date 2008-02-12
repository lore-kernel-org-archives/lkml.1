Return-Path: <linux-kernel-owner+w=401wt.eu-S1764091AbYBLSDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764091AbYBLSDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761509AbYBLSD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:03:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758641AbYBLSD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:03:26 -0500
Date: Tue, 12 Feb 2008 10:00:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <1202838082.3137.54.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>  <20080212044314.GA4888@kroah.com>  <20080211211751.3e265754@laptopd505.fenrus.org>  <20080211.221126.230471463.davem@davemloft.net>  <47B1CB08.4020101@garzik.org> 
 <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <1202838082.3137.54.camel@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, James Bottomley wrote:
>
> On Tue, 2008-02-12 at 09:09 -0800, Linus Torvalds wrote:
> >  (a) create a base tree with _just_ that fundamental infrastructure change,
> >      and make sure that base branch is so obviously good that there is no 
> >      question about merging it.
> 
> The problem is how do we use a?  Usually we need to track your -rc tree
> as our fixes go in ... some of which affect our development trees.

So?

> If we stick with (a) as the base, we don't get to pull in the fixes in
> your tree.  If we use your tree we have to pull in (a) creating n
> different merge points for the n different upstream trees..

I don't understand what you mean. This is true whether you pulled (a) or 
not. If you have any changes what-so-ever in your tree, if you pull in 
fixes from my tree, you'll get a merge.

But if you mean that you cannot rebase (a), then yes. That was what I 
said. Rebases *do*not*work* (and fundamentally cannot work) in a 
distributed environment.

But why would you merge with my tree in the first place? My tree won't 
normally have any conflicts or anything like that anyway.

With a "Linux-next" tree, you'll see the conflicts if they occur (since 
*that* tree would merge!), and in that case you would say  "now I need to 
merge Linus' tree just to resolve the conflicts!"

But before that, merging my tree (or rebasing on top of it) is simply 
*wrong*. It has nothing to do with your SCSI development.

> Yes, this is effectively what I did with the post merge SCSI tree.
> However, if you do this rebasing becomes a fact of life because you need
> to rebase out all the dependencies you have before you merge (in fact,
> it's a good way of checking whether your dependencies have been merged
> yet or not, seeing what survives a rebase).

I don't see the logic. You shouldn't need to rebase at all. I don't see 
why you claim that this makes rebasing more of a fact. It doesn't. It has 
no impact at all, except making rebasing _less_ possible!

		Linus
