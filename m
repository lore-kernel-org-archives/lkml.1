Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbXCGKix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbXCGKix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXCGKix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:38:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890AbXCGKiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:38:52 -0500
Date: Wed, 7 Mar 2007 11:38:42 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307103842.GD5555@wotan.suse.de>
References: <20070307004709.432ddf97.akpm@linux-foundation.org> <E1HOrsL-0008Dv-00@dorka.pomaz.szeredi.hu> <20070307010756.b31c8190.akpm@linux-foundation.org> <1173259942.6374.125.camel@twins> <20070307094503.GD8609@wotan.suse.de> <20070307100430.GA5080@wotan.suse.de> <1173262002.6374.128.camel@twins> <E1HOt96-0008V6-00@dorka.pomaz.szeredi.hu> <20070307102106.GB5555@wotan.suse.de> <1173263085.6374.132.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173263085.6374.132.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:24:45AM +0100, Peter Zijlstra wrote:
> On Wed, 2007-03-07 at 11:21 +0100, Nick Piggin wrote:
> > On Wed, Mar 07, 2007 at 11:13:20AM +0100, Miklos Szeredi wrote:
> > > > *sigh* yes was looking at all that code, thats gonna be darn slow
> > > > though, but I'll whip up a patch.
> > > 
> > > Well, if it's going to be darn slow, maybe it's better to go with
> > > mingo's plan on emulating nonlinear vmas with linear ones.  That'll be
> > 
> > There are real users who want these fast, though.
> 
> Yeah, why don't we have a tree per nonlinear vma to find these pages?
> 
> wli mentions shadow page tables..

We could do something more efficient, but I thought that half the point
was that they didn't carry any of this extra memory, and they could be
really fast to set up at the expense of efficiency elsewhere.

> > > darn slow as well, but at least it will be much less complicated.
> > 
> > IMO, the best thing to do is just restore msync behaviour, and comment
> > the fact that we ignore nonlinears. We need to restore msync behaviour
> > to fix races in regular mappings anyway, at least for now.
> 
> Seems to be the best quick solution indeed.

If we fix the race in the linear mappings, then we can just do the full
msync for nonlinear vmas, and the fast noop version for everyone else.

I don't see it being a big deal. I doubt anybody is writing out huge
amounts of data via nonlinear mappings.
