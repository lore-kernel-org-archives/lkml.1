Return-Path: <linux-kernel-owner+w=401wt.eu-S1422675AbXCGJjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422675AbXCGJjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422682AbXCGJjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:39:10 -0500
Received: from mx1.suse.de ([195.135.220.2]:38422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422675AbXCGJit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:38:49 -0500
Date: Wed, 7 Mar 2007 10:38:48 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, mingo@elte.hu, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307093848.GC8609@wotan.suse.de>
References: <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de> <20070307081948.GA9563@wotan.suse.de> <20070307082755.GA25733@elte.hu> <E1HOrfO-0008AW-00@dorka.pomaz.szeredi.hu> <20070307004709.432ddf97.akpm@linux-foundation.org> <E1HOrsL-0008Dv-00@dorka.pomaz.szeredi.hu> <20070307010756.b31c8190.akpm@linux-foundation.org> <20070307091823.GA8609@wotan.suse.de> <20070307012638.793d9a9f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307012638.793d9a9f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 01:26:38AM -0800, Andrew Morton wrote:
> On Wed, 7 Mar 2007 10:18:23 +0100 Nick Piggin <npiggin@suse.de> wrote:
> 
> > 
> > msync breakage is bad, but otherwise I don't know that we care about
> > dirty page writeout efficiency.
> 
> Well.  We made so many changes to support the synchronous
> dirty-the-page-when-we-dirty-the-pte thing that I'm rather doubtful that
> the old-style approach still works.  It might seem to, most of the time. 
> But if it _is_ subtly broken, boy it's going to take a long time for us to
> find out.

I can't think of anything that should have caused breakage (except for
the msync thing). We're still careful about not dropping pte dirty bits.

> > But I think we discovered that those msync changes are bogus anyway
> > becuase there is a small race window where pte could be dirtied without
> > page being set dirty?
> 
> Dunno, I don't recall that.  We dirty the page before the pte...

I don't think it isn't really that simple. There is a big comment in
clear_page_dirty_for_io.

