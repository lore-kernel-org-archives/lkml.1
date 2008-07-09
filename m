Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbYGILwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbYGILwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYGILvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:51:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753649AbYGILvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:51:53 -0400
Date: Wed, 9 Jul 2008 04:46:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/17] Series to introduce WARN()... a WARN_ON() variant
 that takes printk arguments
Message-Id: <20080709044613.2546034d.akpm@linux-foundation.org>
In-Reply-To: <20080709113703.GA11191@elte.hu>
References: <20080708093800.274504ba@infradead.org>
	<20080709101348.GA30005@elte.hu>
	<20080709041956.0c52b2d9.akpm@linux-foundation.org>
	<20080709113703.GA11191@elte.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 13:37:03 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > The first few patches have been in -mm for a long time; the later 
> > > > ones are newer and introduce more users of WARN().
> > > 
> > > i've created a new -git based topic branch in tip/core/warn-API and 
> > > picked up your patches:
> > 
> > um, why?
> > 
> > If you merge this into linux-next then it will trash already-merged 
> > patches in -mm and, more particularly, it will trash other trees which 
> > you aren't looking at, causing Stephen problems.
> 
> no, i didnt plan to push this towards linux-next - given the broad 
> consensus and given the wide spread of the changes.

Well, there was no way for me (or, I believe, Arjan or anyone else) to have
worked this out from your reply.

> I wanted to wait with this until the end of the merge window and keep it 
> tested and merged up nicely. I.e. zero maintenance overhead to 
> subsystems.

That's an option.  That's why I will cc the relevant subsystem maintainers
on the commits, and will collect and maintain the acked-by's.

> > The way to merge this code is to get the base patches into mainline 
> > and then trickle the dependent patches into subsystem trees, or direct 
> > into mainline after the subsystem trees have merged, and with suitable 
> > acks.
> > 
> > You aren't set up to do that?
> 
> i think it's better to just go through the merge window i believe, and 
> then do this atomically in one correct and tested step, when all 
> subsystem trees are at their minimum size and there's virtually no 
> collisions.

Probably.

> Note that this situation is special: this is a patchset that has 
> virtually no functionality side-effects, and hence can be done 100% 
> correctly, i thought the atomic step was the right approach.
> 
> For anything semantically meaningful i too would do the spread-out 
> gradual approach (and i'm presently doing that for a number of topics).
> 
> But if you'd like to do this the spread-out way then sure, and i will 
> drop this tree. ( if you do that then please import the commits from 
> tip/core/warn-API, i fixed a couple of of typos in the commit messages 
> and did some merging and extensions as well. The tree also passed a fair 
> amount of testing meanwhile as well. )
> 
> Anyway, your call.

Well I haven't got onto processing these patches in detail yet.  An open
questions is why the damn thing was resubmitted from scratch when I've
already merged it and fixed various rejects and had to fix several bugs in
it.  Do those rejects need to be re-fixed?  Were my bugfixes folded back? 
I haven't looked yet.  I'll need to generate the incremental diff and see
what was done.

But if what you've merged was against mainline then it isn't terribly
useful.

Hopefully this sort of thing won't happen as much once I get -mm into
linx-next.  Soon...

