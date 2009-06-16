Return-Path: <linux-kernel-owner+w=401wt.eu-S1763016AbZFPXfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763016AbZFPXfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 19:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbZFPXfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 19:35:47 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34596 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbZFPXfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 19:35:46 -0400
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in
 resources trees
From: Andrew Patterson <andrew.patterson@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
In-Reply-To: <alpine.LFD.2.01.0906161556020.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>
	 <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain>
	 <1245192703.8234.226.camel@bluto.andrew>
	 <alpine.LFD.2.01.0906161556020.16802@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 17:38:18 -0600
Message-Id: <1245195498.8234.236.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 16:05 -0700, Linus Torvalds wrote:
> 
> On Tue, 16 Jun 2009, Andrew Patterson wrote:
> > 
> > That is at least one problem. I initially tried reparenting this stuff.
> > That is what got backed out in
> > http://thread.gmane.org/gmane.linux.kernel/768526/
> 
> Well, aren't we in the exact same situation still? Ie the problem (as 
> Matthew claims) is:
> 
>   'Basically it was that we came across a machine with the opposite 
>    problem -- that we found a parent after we found a child (and claimed 
>    the child's resources), and had no way to insert the parent's region 
>    above the child's region.  Alex's machine finds the child after the 
>    parent and needs to insert the child's resource inside the parent's 
>    resource.'
> 
> and the problem is that anything that isn't explicitly aware of the 
> topology is always going to be potentially confused about things like 
> this, since it's not clear at which level you want to find or add a 
> resource.
> 
> > > But you fix it by making find_resource always go as deep as it can (if I 
> > > read the code correctly).
> > 
> > Well, just deep enough.
> 
> Ok, color me confused now. When is "as deep as it can" different from your 
> "just deep enough"?

Maybe confusion on what is meant by 'as deep as'.  My patch continues
until it doesn't find a conflict including checking sub-children and
stops as soon as an appropriate resource is found that does not
conflict.  Perhaps we mean the same thing.

> 
> > Is there a reason that find_resources should stop at the roots immediate
> > child/sibling.  It seems like a bug to me. Hence this patch.
> 
> Well, find_resource() found room for a resource. So it returns it. The 
> point is, your patch returns another - equally valid one.

I am confused.  The existing code will return a conflict and bomb out.

> 
> Now, I'm not saying that your patch is wrong, but I _am_ worried that it 
> (once more) changes some random heuristic when we have two choices, and it 
> just makes it choose the other choice.

Agreed.

> 
> We've had those kinds of situations before. The thread you point to is an 
> exact case of this. My point is that I'd rather try to _avoid_ any 
> ambiguous cases, and try to solve it properly at a higher PCI level, where 
> the ambiguity doesn't exist any more (because we'd explicitly take the 
> actual bus topology into account).
> So your patch may fix a bug, but I'm pretty sure I've seen a patch from 
> Ivan that should _also_ fix it, and that I would expect to do it not by 
> just tweaking a fundamentally ambiguous case.
> 

OK. I would be happy to test Ivan's patch.

> 		Linus
> 
-- 
Andrew Patterson
Hewlett-Packard

