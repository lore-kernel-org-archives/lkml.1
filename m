Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbYCNQvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbYCNQvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbYCNQv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:51:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41863 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYCNQv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:51:26 -0400
Date: Fri, 14 Mar 2008 17:53:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
Message-ID: <20080314165336.GS2522@one.firstfloor.org>
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com> <86802c440803121811i262b21bdrfb07df52fd27aaae@mail.gmail.com> <20080312182240.db32c858.akpm@linux-foundation.org> <200803132259.47063.ak@suse.de> <86802c440803131522t3d038d39gbe8eb0d38ddcb634@mail.gmail.com> <87iqzp5xfv.fsf@basil.nowhere.org> <86802c440803140944p302b300fy7515fb758221932b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803140944p302b300fy7515fb758221932b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 09:44:50AM -0700, Yinghai Lu wrote:
> On 14 Mar 2008 12:58:44 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> > "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> >  >
> >  > then i tried to reserve 64M or 128M RAM before that, and free that
> >  > before gart/switotble try to allloc_bootmem under 4g.
> >
> >  Sounds like an incredible hack. There are far better ways to do that
> >  for bootmem allocations. e.g. you can just specify a high enough "goal"
> >  That is how swiotlb solves a similar problem (at least before my
> >  mask allocator rewrite)
> 
> I don't think so.
> 
> anyway, otherway to workaround it is
> change
>                 return __earlyonly_bootmem_alloc(node, size, size,
>                                 __pa(MAX_DMA_ADDRESS));
> in vmemmap_alloc_block to
>                 return __earlyonly_bootmem_alloc(node, size, size,
>                                 __pa(MAX_DMA_ADDRESS + (1<<27)));
> to make room for gart. but that is global change. and may affect other
> platform. 

You can just make it an optional architecture defined macro

> and don't make sure gart will get it.

Has nothing to do with the gart?


> 
> also i assume swiotlb need that range is less than 4g.

The normal rule is that anybody who needs big bootmem allocations
need to make sure they're high enough to not fill up first 4GB.
For small allocations like most of bootmem it doesn't matter because 
they're, um, small.

If vmemmap doesn't do that vmemmap needs to be fixed.

-Andi


