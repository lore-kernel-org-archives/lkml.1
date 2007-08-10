Return-Path: <linux-kernel-owner+w=401wt.eu-S937583AbXHJRhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937583AbXHJRhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbXHJRhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:37:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52357 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756463AbXHJRhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:37:05 -0400
Date: Fri, 10 Aug 2007 10:37:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <20070810104749.GA14300@skynet.ie>
Message-ID: <Pine.LNX.4.64.0708101035020.12758@schroedinger.engr.sgi.com>
References: <20070809210616.14702.73376.sendpatchset@skynet.skynet.ie>
 <20070809210716.14702.43074.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0708091431560.32324@schroedinger.engr.sgi.com>
 <20070809233300.GA31644@skynet.ie> <Pine.LNX.4.64.0708091843230.3185@schroedinger.engr.sgi.com>
 <20070810104749.GA14300@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007, Mel Gorman wrote:

> On (09/08/07 18:44), Christoph Lameter didst pronounce:
> > 
> > On Fri, 10 Aug 2007, Mel Gorman wrote:
> > 
> > > > > +#if defined(CONFIG_SMP) && INTERNODE_CACHE_SHIFT > ZONES_SHIFT
> > > > 
> > > > Is this necessary? ZONES_SHIFT is always <= 2 so it will work with 
> > > > any pointer. Why disable this for UP?
> > > > 
> > > 
> > > Caution in case the number of zones increases. There was no guarantee of
> > > zone alignment. It's the same reason I have a BUG_ON in the encode
> > > function so that if we don't catch problems at compile-time, it'll go
> > > BANG in a nice predictable fashion.
> > 
> > Caution would lead to a BUG_ON but why the #if? Why exclude UP?
> 
> On x86_64 would have ZONE_DMA, ZONE_DMA32, ZONE_NORMAL, ZONE_HIGHMEM and
> ZONE_MOVABLE. On SMP, that's more than two bits worth and would fail t
> runtime. Well, it should at least I didn't actually try it out.

x86_64 does not support ZONE_HIGHMEM. The number of zones is 
depending on SMP?
 
> However, I accept that the SMP check is less than than ideal. I considered
> comparing it against MAX_NR_ZONES but as it's an enum, it can't be checked
> at compile time. What else would make a better check?

You could do a BUILD_BUG_ON() instead?
