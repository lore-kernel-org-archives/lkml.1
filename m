Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbXGJNZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbXGJNZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbXGJNZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:25:04 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:39465 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbXGJNZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:25:03 -0400
Date: Tue, 10 Jul 2007 14:24:59 +0100
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       kenchen@google.com, jschopp@austin.ibm.com, apw@shadowen.org,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans -- anti-fragmentation
Message-ID: <20070710132459.GB9426@skynet.ie>
References: <20070710102043.GA20303@skynet.ie> <1184065445.5281.16.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1184065445.5281.16.camel@lappy>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/07/07 13:04), Peter Zijlstra didst pronounce:
> On Tue, 2007-07-10 at 11:20 +0100, Mel Gorman wrote:
> 
> <snip>
> 
> > > lumpy-reclaim-v4.patch
> > 
> > This patch is really what lumpy reclaim is. I believe Peter has looked
> > at this and was happy enough at the time although he is cc'd here again
> > in case this has changed. This is mainly useful with either grouping
> > pages by mobility or the ZONE_MOVABLE stuff. However, at the time the
> > patch was proposed, there was a feeling that it might help jumbo frame
> > allocation on e1000's and maybe if fsblock optimistically uses
> > contiguous pages it would have an application. I would like to see it go
> > through to see does it help e1000 at least.
> 
> I'm not seeing how this will help e1000 (and other jumbo drivers). They
> typically allocate using GFP_ATOMIC, so in order to satisfy those you'd
> need to either have a higher order watermark or do atomic defrag of the
> free space.
> 

It does help somewhat indirectly and in an unsatisfactory manner. When the
higher watermarks are breached, the atomic allocation will still succeeed
but kswapd will be poked to reclaim at a given order. This is similar to
the problems SLUB hits when it uses high-orders frequently.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
