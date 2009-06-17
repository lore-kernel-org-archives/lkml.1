Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZFQQ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZFQQ3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZFQQ3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:29:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbZFQQ3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:29:03 -0400
Date: Wed, 17 Jun 2009 09:28:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
cc: Andrew Patterson <andrew.patterson@hp.com>, linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in resources
 trees
In-Reply-To: <20090617144513.GA17720@jurassic.park.msu.ru>
Message-ID: <alpine.LFD.2.01.0906170924180.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio> <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain> <1245192703.8234.226.camel@bluto.andrew> <alpine.LFD.2.01.0906161556020.16802@localhost.localdomain> <alpine.LFD.2.01.0906161623240.16802@localhost.localdomain>
 <20090617144513.GA17720@jurassic.park.msu.ru>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Ivan Kokshaysky wrote:

> On Tue, Jun 16, 2009 at 04:32:18PM -0700, Linus Torvalds wrote:
> > > So your patch may fix a bug, but I'm pretty sure I've seen a patch from 
> > > Ivan that should _also_ fix it, and that I would expect to do it not by 
> > > just tweaking a fundamentally ambiguous case.
> > 
> > Hmm. For the life of me, I can't seem to find this patch. Maybe it wasn't 
> > Ivan who wrote it after all. Or maybe my google-fu is weak. Or maybe I'm 
> > just delusional, and the patch never existed.
> 
> No, it wasn't me.

Ingo pointed out that it was probably Yinghai. And now that I'm googling 
for the right author, I found it on the first try. It's this patch

	http://lkml.org/lkml/2009/4/22/433

I was thinking of.

But that was before I realized that pci_assign_resource() _already_ always 
chose the right parent bus (and it was just that it can't handle 
transparent buses at all). I then ended up not understanding how the 
incorrect nesting could possibly happen at all. So Yinghai's patch is 
irrelevant for this particular problem.

And:

> Anyway, pci_claim_resource() fix suggested by Matthew seems to be
> correct, if the problematic system was indeed ia64 and not x86.

I agree. That one explains why the nesting is wrong, and also why I 
couldn't figure out how it happened.

		Linus
