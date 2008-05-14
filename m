Return-Path: <linux-kernel-owner+w=401wt.eu-S1762222AbYEOQJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762222AbYEOQJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759185AbYEOQJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:09:09 -0400
Received: from waste.org ([66.93.16.53]:60465 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758545AbYEOQJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:09:08 -0400
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <Pine.LNX.4.64.0805141405350.19073@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>
	 <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org>
	 <20080510221515.3540a6cc@bree.surriel.com>
	 <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
	 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
	 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
	 <482B2617.5010605@firstfloor.org>
	 <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
	 <1210789112.4093.14.camel@calx>
	 <Pine.LNX.4.64.0805141220440.16223@schroedinger.engr.sgi.com>
	 <1210794563.4093.57.camel@calx>
	 <Pine.LNX.4.64.0805141333060.18231@schroedinger.engr.sgi.com>
	 <1210798978.4093.82.camel@calx>
	 <Pine.LNX.4.64.0805141405350.19073@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 16:54:55 -0500
Message-Id: <1210802095.4093.109.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-14 at 14:26 -0700, Christoph Lameter wrote:
> > So far this is a bunch of hand-waving but I think this ends up
> basically
> > being an anti-magazine. A magazine puts a per-cpu queue on the alloc
> > side which costs on both the alloc and free side, regardless of whether
> > the workload demands it. This puts a per-cpu queue on the free side that
> > we can bypass in the cache-friendly case. I think that's a step in the
> > right direction.
> 
> I think if you want queues for an SMP only system, do not care too much 
> about memory use, dont do any frequent allocations on multicore systems 
> and can tolerate the hiccups because your application does not care (most 
> enterprise apps are constructed that way) or if you are running benchmarks 
> that only access a limited dataset that fits into SLABs queues amd 
> avoid touch the contenst of objects then the SLAB concept is the right way 
> to go.

> If we would strip the NUMA stuff out and make it an SMP only allocator for 
> enterprise apps then the code may become much smaller and simpler. I guess 
> Arjan suggested something similar in the past. But that would result in 
> SLAB no longer being a general allocator.

What does this have to do with anything? I'm not talking about going
back to SLAB. I'm talking about plugging the use cases where SLUB
currently loses to SLAB. That's what has to happen before SLAB can be
obsoleted.

I'll certainly grant you that queueing might not break even.

-- 
Mathematics is the supreme nostalgia of our time.

