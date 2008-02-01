Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbYBAKhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbYBAKhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYBAKhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:37:40 -0500
Received: from relay2.sgi.com ([192.48.171.30]:33097 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754192AbYBAKhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:37:39 -0500
Date: Fri, 1 Feb 2008 04:37:38 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Andrea Arcangeli <andrea@qumranet.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/3] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080201103737.GI26420@sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.785269387@sgi.com> <20080201042408.GG26420@sgi.com> <Pine.LNX.4.64.0801312042500.20675@schroedinger.engr.sgi.com> <20080201103221.GH26420@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201103221.GH26420@sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 04:32:21AM -0600, Robin Holt wrote:
> On Thu, Jan 31, 2008 at 08:43:58PM -0800, Christoph Lameter wrote:
> > On Thu, 31 Jan 2008, Robin Holt wrote:
> > 
> > > > Index: linux-2.6/mm/memory.c
> > > ...
> > > > @@ -1668,6 +1678,7 @@ gotten:
> > > >  		page_cache_release(old_page);
> > > >  unlock:
> > > >  	pte_unmap_unlock(page_table, ptl);
> > > > +	mmu_notifier(invalidate_range_end, mm, 0);
> > > 
> > > I think we can get an _end call without the _begin call before it.
> > 
> > If that would be true then also the pte would have been left locked.
> > 
> > We always hit unlock. Maybe I just do not see it?
> 
> Maybe I haven't looked closely enough, but let's start with some common
> assumptions.  Looking at do_wp_page from 2.6.24 (I believe that is what
> my work area is based upon).  On line 1559, the function begins being
> declared.
> 
> On lines 1614 and 1630, we do "goto unlock" where the _end callout is
> soon made.  The _begin callout does not come until after those branches
> have been taken (occurs on line 1648).
> 
> Thanks,
> Robin

Ignore this thread, I am going to throw a patch against the new version.

Thanks,
Robin
