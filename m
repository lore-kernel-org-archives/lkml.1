Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbYCNL7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbYCNL7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 07:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYCNL6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 07:58:50 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:37484 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbYCNL6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 07:58:48 -0400
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com>
	<86802c440803121811i262b21bdrfb07df52fd27aaae@mail.gmail.com>
	<20080312182240.db32c858.akpm@linux-foundation.org>
	<200803132259.47063.ak@suse.de>
	<86802c440803131522t3d038d39gbe8eb0d38ddcb634@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 14 Mar 2008 12:58:44 +0100
In-Reply-To: <86802c440803131522t3d038d39gbe8eb0d38ddcb634@mail.gmail.com>
Message-ID: <87iqzp5xfv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Mar 2008 11:52:12.0049 (UTC) FILETIME=[D6E7B810:01C885C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> 
> then i tried to reserve 64M or 128M RAM before that, and free that
> before gart/switotble try to allloc_bootmem under 4g.

Sounds like an incredible hack. There are far better ways to do that
for bootmem allocations. e.g. you can just specify a high enough "goal"
That is how swiotlb solves a similar problem (at least before my 
mask allocator rewrite) 

> >  with your improved free_bootmem()
> 
> using phys_to_nid()? it seems we only have that on x86_64.

pfn/page_to_nid() is generic afaik.
 
> also there is assumpation that reserve_bootmem_node, reserver_bootmem
> can not cross the nodes.
> I want to remove that constrient too.

Makes sense, but that will be much more work and should be all separated.

-Andi
