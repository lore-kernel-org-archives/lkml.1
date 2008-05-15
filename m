Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYEOD3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYEOD3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYEOD3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:29:33 -0400
Received: from mga06.intel.com ([134.134.136.21]:10434 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751215AbYEOD3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:29:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,489,1204531200"; 
   d="scan'208";a="383884515"
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>
	 <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org>
	 <20080510221515.3540a6cc@bree.surriel.com>
	 <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
	 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
	 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
	 <482B2617.5010605@firstfloor.org>
	 <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 May 2008 11:26:42 +0800
Message-Id: <1210822002.3177.121.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-14 at 11:03 -0700, Christoph Lameter wrote:
> On Wed, 14 May 2008, Andi Kleen wrote:
> 
> > iirc profiling analysis showed that the problem was the page lock
> > serialization (in particular the slab_lock() in __slab_free). That
> > was on 2.6.24.2
> 
> Do you have an URL?
> 
> > I think the problem is that this atomic operation thrashes cache lines
> > around. Really counting cycles on instructions is not that interesting,
> > but minimizing the cache thrashing is. And for that it looks like slub
> > is worse.
> 
> It can thrash cachelines if objects from the same slab page are freed 
> simultaneously on multiple processors. That occurred in the hackbench 
> regression that we addressed with the dynamic configuration of slab sizes.
hackbench regression is because of slow allocation instead of slow freeing.
With ﻿dynamic configuration of slab sizes, fast allocation becomes 97% (the bad
one is 68%), but fast free is always 8~9% with/without the patch.


