Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXCRLfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXCRLfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 07:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411AbXCRLfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 07:35:41 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:60419 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbXCRLfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 07:35:40 -0400
Date: Sun, 18 Mar 2007 11:35:36 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andy Whitcroft <apw@shadowen.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Bias the location of pages freed for min_free_kbytes in
 the same MAX_ORDER_NR_PAGES blocks
In-Reply-To: <20070318002244.606cfe08.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703181104140.29429@skynet.skynet.ie>
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
 <200703142006.04547.m.kozlowski@tuxland.pl> <20070314170738.d5d35c06.akpm@linux-foundation.org>
 <20070317182641.GA19447@skynet.ie> <20070318002244.606cfe08.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007, Andrew Morton wrote:

> On Sat, 17 Mar 2007 18:26:41 +0000 mel@skynet.ie (Mel Gorman) wrote:
>>
>
> I still haven't got onto reviewing all your mm patches :(

There are a lot them admittadly.

> Nor has anyone else, afaik.
>

They have been reviewed at various points in their development and most of 
the feedback was fed back in. Marcelo Tosatti commented on version 19 for 
example. Joel Schopp commented heavily on earlier versions around the 
v15-v19 mark as well as Dave Hansen around the same time. Christoph 
Lameter has commented on recent versions but I'm not sure how detailed his 
review was of if the comments were based on the patch description. There 
have been comments from various other people as well, mainly around the 
v19-v20 mark. Andy Whitcroft has reviewed most versions of the patches 
including the most recent ones.

I suspect there may not have been detailed review recently because so many 
versions have been released.

> But let me leap ahead of myself.
>
>> CONFIG_PAGE_GROUP_BY_MOBILITY
>
> Why does this config item exist?  It's not good to have some mysterious
> knob which affects mm behaviour at compile time.  We need to make up our
> minds and stick with it.
>

The configuration item exists because there were concerns over the memory 
footprint and cache line footprint. It was introduced to address that 
concern and also so that it would be possible to compare the performance 
behavior of anti-fragmentation. Your comment rang a bell though so I 
searched the archives to see this comment from Andi Kleen;

===
If anything this should be a boot time option or perhaps sysctl, not a 
config. In general CONFIGs that change runtime behaviour are evil - just 
makes changing the option more painful, causes problems for distribution 
users, doesn't make much sense, etc.etc.

Also #ifdef as a documentation device is a really really scary concept.
Yuck.
===

A sysctl would avoid any cache line footprint but not the memory overhead 
because the freelists in struct zone as those freelists would still exist. 
I could make the option depend on CONFIG_EMBEDDED for the zone overhead. 
Would that make sense or would it be preferable to ditch the option 
altogether?

I'll start looking at doing a sysctl so it can be disabled at runtime if 
necessary. I strongly suspect that it cannot be enabled again once 
disabled but I don't see that as a problem as such.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
