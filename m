Return-Path: <linux-kernel-owner+w=401wt.eu-S1030360AbXCNTtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030360AbXCNTtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030391AbXCNTtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:49:45 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:46728 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030360AbXCNTto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:49:44 -0400
Date: Wed, 14 Mar 2007 19:49:41 +0000
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, ak@suse.com,
       linux-ia64@vger.kernel.org, holt@sgi.com, mpm@selenic.com
Subject: Re: [QUICKLIST 4/6] x86_64: Single Quicklist
Message-ID: <20070314194941.GA21862@skynet.ie>
References: <20070311020923.19905.49260.sendpatchset@schroedinger.engr.sgi.com> <20070311020944.19905.87599.sendpatchset@schroedinger.engr.sgi.com> <200703110854.05799.ak@suse.de> <Pine.LNX.4.64.0703110939140.24216@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703110939140.24216@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/03/07 09:44), Christoph Lameter didst pronounce:
> On Sun, 11 Mar 2007, Andi Kleen wrote:
> 
> > This and i386 version are ok to me, although it might be better to just
> > finish __GFP_ZERO support to do this.
> 
> This would not work for pgds on i386 and x86_64
> 
> GFP_ZERO support the way I have done it in the past would mean another set 
> of buddy lists in the page allocator and another issue with fragmentation. 
> So I have stayed away from it although patches exist in my archives (See 
> my ftp.kernel.org archive).

I haven't checked this in a while but when we experimented with keeping
zero'd pages on separate lists before, the performance sucked. I haven't
looked at it in a *long* time though.

> 
> Maybe we could implemento limited GFP_ZERO support by just keeping an 
> additional per cpu list of pages?

I imagine that adding an additional per-cpu list will not be welcome.

> The issue with that one is that a page
> may grow cold on that list.

And that growing cold appeared to hurt before. It could be checked out
again though. The anti-fragmentation breaks out the buddy lists already
and has the ability to search the per-cpu lists for pages of an
appropriate type.

I'll try and find an hour or two to hack something together to see what
it looks like but I suspect it'll still be a performance loss. At least
then though, we can see if quicklists are a better plan or not.

> One usually want the page to be hot in the 
> cache when it is allocated. This is different for page table pages. Page 
> table pages are typically sparsely accessed.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
