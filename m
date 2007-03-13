Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbXCMUeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbXCMUeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933266AbXCMUeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:34:31 -0400
Received: from waste.org ([66.93.16.53]:55245 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219AbXCMUea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:34:30 -0400
Date: Tue, 13 Mar 2007 15:21:25 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
Message-ID: <20070313202125.GO10394@waste.org>
References: <45F65ADA.9010501@yahoo.com.au> <20070313035250.f908a50e.akpm@linux-foundation.org> <45F685C6.8070806@yahoo.com.au> <20070313041551.565891b5.akpm@linux-foundation.org> <45F68B4B.9020200@yahoo.com.au> <20070313044756.b45649ac.akpm@linux-foundation.org> <45F69287.8040509@yahoo.com.au> <45F6DFA2.9060106@goop.org> <20070313200313.GG10459@waste.org> <45F706BC.7060407@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F706BC.7060407@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 01:17:00PM -0700, Jeremy Fitzhardinge wrote:
> Matt Mackall wrote:
> > On Tue, Mar 13, 2007 at 10:30:10AM -0700, Jeremy Fitzhardinge wrote:
> >   
> >> Nick Piggin wrote:
> >>     
> >>> However we still have to visit those to-be-unmapped parts of the page
> >>> table,
> >>> to find the pages and free them. So we still at least need to bring it
> >>> into
> >>> cache for the read... at which point, the store probably isn't a big
> >>> burden.
> >>>       
> >> Why not try to find a place to stash a linklist pointer and link them
> >> all together?  Saves the pulldown pagetable walk altogether.
> >>     
> >
> > Because we'd need one link per mm that a page is mapped in?
> >   
> 
> Can pagetable pages be shared between mms?  (Kernel pmds in PAE excepted.)

Ahh, I think the issue is that we have to walk the page tables to drop
the reference count of the _actual pages_ they point to. The page
tables themselves could all be put on a list or two lists (one for
PMDs, one for everything else), but that wouldn't really be a win over
just walking the tree, especially given the extra list maintenance.

Because the fan-out is large, the bulk of the work is bringing the last
layer of the tree into cache to find all the pages in the address
space. And there's really no way around that.

-- 
Mathematics is the supreme nostalgia of our time.
