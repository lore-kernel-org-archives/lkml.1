Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbXGZDKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbXGZDKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 23:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbXGZDKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 23:10:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45323 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756073AbXGZDKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 23:10:33 -0400
Date: Wed, 25 Jul 2007 20:10:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>
Subject: Re: [PATCH] config_zone_movable [1/2] clean up zone config by
 renumbering
Message-Id: <20070725201016.7a8b6ec9.akpm@linux-foundation.org>
In-Reply-To: <20070726115020.1ff4513b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070726115020.1ff4513b.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 11:50:20 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> I refreshed config_zone_movable patch set against 2.6.23-rc1.
> Reflected comments on previous version.
> Tested on ia64/NUMA system and my small i386 desktop.
> 
> Andrew, I like this patch but know that there are many types of memory layout. 
> Could you test this set in -mm ?
> I'll refresh this against rc1-mm1 if necessary.

Right now I want to concentrate on getting the present -mm queue vaguely
stabilised, so I'd prefer to not be adding features or nontrivial cleanups
for a few days at the minimum.

This process would be greatly aided by developers testing it out and
sending fixes (or at least, reports) for anything they encounter.


> -Kame
> 
> ==
> zone_ifdef_cleanup_by_renumbering.patch
> 
> Now, this patch defines zone_idx for not-configured-zones.
> like 
> 	enum_zone_type {
> 		(ZONE_DMA configured)
> 		(ZONE_DMA32 configured)
> 		ZONE_NORMAL
> 		(ZONE_HIGHMEM configured)
> 		ZONE_MOVABLE
> 		MAX_NR_ZONES,
> 		(ZONE_DMA not-configured)
> 		(ZONE_DMA32 not-configured)
> 		(ZONE_HIGHMEM not-configured)
> 	};
> 
> By this, we can determine zone is configured or not by
> 
> 	zone_idx < MAX_NR_ZONES.
> 
> We can avoid #ifdef for CONFIG_ZONE_xxx to some extent.
> 
> This patch also replaces CONFIG_ZONE_DMA_FLAG by is_configured_zone(ZONE_DMA).
> 
> Changelog: v1 -> v2
> 	- rebased to 2.6.23-rc1
> 	- Removed MAX_POSSIBLE_ZONES
> 	- Added comments

Is this patch a bugfix?

box:/home/akpm> grep ifdef ~/x
zone_ifdef_cleanup_by_renumbering.patch
We can avoid #ifdef for CONFIG_ZONE_xxx to some extent.
+ * You can use this functio for avoiding #ifdef.
+ * #ifdef OCNFIG_ZONE_DMA
-#ifdef CONFIG_HIGHMEM
-#ifdef CONFIG_HIGHMEM
-#ifdef CONFIG_ZONE_DMA32
-#ifdef CONFIG_ZONE_DMA
-#ifdef CONFIG_ZONE_DMA
-#ifdef CONFIG_ZONE_DMA32
-#ifdef CONFIG_HIGHMEM
-#ifdef CONFIG_ZONE_DMA
-#ifdef CONFIG_ZONE_DMA32
-#ifdef CONFIG_HIGHMEM
-#ifdef CONFIG_ZONE_DMA
-#ifdef CONFIG_ZONE_DMA32
-#ifdef CONFIG_HIGHMEM
-#ifdef CONFIG_HIGHMEM
-#ifdef CONFIG_HIGHMEM

ooh, me like.

>  /*
> + * Test zone type is configured or not.
> + * You can use this functio for avoiding #ifdef.
> + *
> + * #ifdef OCNFIG_ZONE_DMA

typo there.


