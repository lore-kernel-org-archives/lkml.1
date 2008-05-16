Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYEPFTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYEPFTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 01:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbYEPFTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 01:19:41 -0400
Received: from mga06.intel.com ([134.134.136.21]:32567 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751239AbYEPFTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 01:19:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,495,1204531200"; 
   d="scan'208";a="282047115"
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>
	 <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org>
	 <20080510221515.3540a6cc@bree.surriel.com>
	 <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
	 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
	 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
	 <482B2617.5010605@firstfloor.org>
	 <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
	 <1210822002.3177.121.camel@ymzhang>
	 <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 May 2008 13:16:35 +0800
Message-Id: <1210914995.3177.131.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-15 at 10:05 -0700, Christoph Lameter wrote:
> On Thu, 15 May 2008, Zhang, Yanmin wrote:
> 
> > > It can thrash cachelines if objects from the same slab page are freed 
> > > simultaneously on multiple processors. That occurred in the hackbench 
> > > regression that we addressed with the dynamic configuration of slab sizes.
> > hackbench regression is because of slow allocation instead of slow freeing.
> > With ÿÿdynamic configuration of slab sizes, fast allocation becomes 97% (the bad
> > one is 68%), but fast free is always 8~9% with/without the patch.
> 
> Thanks for using the slab statistics. I wish I had these numbers for the 
> TPC benchmark. That would allow us to understand what is going on while it 
> is running.
> 
> The frees in the hackbench were slow because partial list updates occurred 
> to frequently. The first fix was to let slab sit longer on the partial 
> list. 
I forgot that. 2.6.24 merged the patch.

> The other was the increase of the slab sizes which also increases 
> the per cpu slab size and therefore the objects allocatable without a 
> round trip to the page allocator.
That is what I am talking. 2.6.26-rc merged the patch.

>  Freeing to a per cpu slab never requires 
> partial list updates. So the frees also benefitted from the larger slab 
> sizes. But the effect shows up in the count of partial list updates not in 
> the fast/free collumn.
I agree. It might be better if SLUB could be optimized again to ﻿have more consideration
when the slow free percentage is high, because the page lock might ping-pong
among processors if multi-processors access the same slab at the same time.

