Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbXGMRC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbXGMRC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbXGMRCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:02:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:54290 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXGMRCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:02:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c8ZSNv4RoDR4S7Lz8DpFOomTNN3wnBqQyRScyLBtJq+zNeZUKybksyJ8QyW1m0mAYnTkNZi/1xlot4a46hT5GMQdGSeE2v0IgIm0rs9SEHONaKq/vePguXSaQhNBmZOHMB75Hwio8AzurCnrYepx7S/WX2aW3l6ihmIQdHwJeck=
Message-ID: <29495f1d0707131002l6549b253o96a85efcb22aa56e@mail.gmail.com>
Date: Fri, 13 Jul 2007 10:02:46 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: -mm merge plans -- anti-fragmentation
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Mel Gorman" <mel@skynet.ie>,
       npiggin@suse.de, kenchen@google.com, jschopp@austin.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       y-goto@jp.fujitsu.com, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <469751E9.7060904@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710102043.GA20303@skynet.ie>
	 <20070712122925.192a6601.akpm@linux-foundation.org>
	 <469751E9.7060904@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/13/07, Andy Whitcroft <apw@shadowen.org> wrote:
> Andrew Morton wrote:
> > On Tue, 10 Jul 2007 11:20:43 +0100
> > mel@skynet.ie (Mel Gorman) wrote:
> >
> >>> create-the-zone_movable-zone.patch
> >>> allow-huge-page-allocations-to-use-gfp_high_movable.patch
> >>> handle-kernelcore=-generic.patch
> >>>
> >>>  Mel's moveable-zone work.  In a similar situation.  We need to stop whatever
> >>>  we're doing and get down and work out what we're going to do with all this
> >>>  stuff.
> >>>
> >> Whatever about grouping pages by mobility, I would like to see these go
> >> through. They have a real application for hugetlb pool resizing where the
> >> administrator knows the range of hugepages that will be required but doesn't
> >> want to waste memory when the required number of hugepages is small. I've
> >> cc'd Kenneth Chen as I believe he has run into this problem recently where
> >> I believe partitioning memory would have helped. He'll either confirm or deny.
> >
> > Still no decision here, really.
> >
> > Should we at least go for
> >
> > add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
> > create-the-zone_movable-zone.patch
> > allow-huge-page-allocations-to-use-gfp_high_movable.patch
> > handle-kernelcore=-generic.patch
> >
> > in 2.6.23?
>
> These patches are pretty simple and self-contained utilising the
> existing zone infrastructure.  They provide a significant degree of
> placement control when configured, which gives a lot of the benefits of
> grouping-pages-by-mobility.  Merging these would seem like a low-risk
> option.
>
> Having a degree of placement control as delivered by ZONE_MOVABLE
> greatly increases the effectiveness of lumpy reclaim at higher orders.
> These patches plus lumpy would (IMO) provide a good base for further
> development.  In particular I would envisage better usability for
> hugepage users in terms of simpler configuration.

This is also where I (as a libhugetlbfs maintainer/developer) see
these patches being very helpful (for example, see Adam Litke's recent
posting on resizing the hugepage pool dynamically). Making hugepages
"easier" to use -- and in this case that means more likely to
successfully resize the hugepage pool at run-time -- is a good thing.

> I would like to see ZONE_MOVABLE and lumpy considered for 2.6.23.

Ack.

Thanks,
Nish
