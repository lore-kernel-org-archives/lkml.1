Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbXHJKsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbXHJKsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 06:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbXHJKrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 06:47:53 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36673 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbXHJKrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 06:47:52 -0400
Date: Fri, 10 Aug 2007 11:47:49 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones pointer
Message-ID: <20070810104749.GA14300@skynet.ie>
References: <20070809210616.14702.73376.sendpatchset@skynet.skynet.ie> <20070809210716.14702.43074.sendpatchset@skynet.skynet.ie> <Pine.LNX.4.64.0708091431560.32324@schroedinger.engr.sgi.com> <20070809233300.GA31644@skynet.ie> <Pine.LNX.4.64.0708091843230.3185@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708091843230.3185@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/08/07 18:44), Christoph Lameter didst pronounce:
> 
> On Fri, 10 Aug 2007, Mel Gorman wrote:
> 
> > > > +#if defined(CONFIG_SMP) && INTERNODE_CACHE_SHIFT > ZONES_SHIFT
> > > 
> > > Is this necessary? ZONES_SHIFT is always <= 2 so it will work with 
> > > any pointer. Why disable this for UP?
> > > 
> > 
> > Caution in case the number of zones increases. There was no guarantee of
> > zone alignment. It's the same reason I have a BUG_ON in the encode
> > function so that if we don't catch problems at compile-time, it'll go
> > BANG in a nice predictable fashion.
> 
> Caution would lead to a BUG_ON but why the #if? Why exclude UP?

On x86_64 would have ZONE_DMA, ZONE_DMA32, ZONE_NORMAL, ZONE_HIGHMEM and
ZONE_MOVABLE. On SMP, that's more than two bits worth and would fail t
runtime. Well, it should at least I didn't actually try it out.

However, I accept that the SMP check is less than than ideal. I considered
comparing it against MAX_NR_ZONES but as it's an enum, it can't be checked
at compile time. What else would make a better check?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
