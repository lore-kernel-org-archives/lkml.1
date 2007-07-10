Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbXGJTBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbXGJTBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbXGJTAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:00:55 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57130 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754942AbXGJTAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:00:54 -0400
Date: Tue, 10 Jul 2007 21:01:23 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] slub.c:early_kmem_cache_node_alloc() shouldn't be
	__init
Message-ID: <20070710190123.GB3492@stusta.de>
References: <20070710124445.GX3492@stusta.de> <Pine.LNX.4.64.0707101132110.11882@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707101132110.11882@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 11:33:15AM -0700, Christoph Lameter wrote:
> On Tue, 10 Jul 2007, Adrian Bunk wrote:
> 
> > This patch fixes the following section mismatch:
> 
> Nack.
> 
> Can you remove the warning? early_kmem_cache_node_alloc is only used 
> during bootstrap. But it is called from a function that is also used 
> later.

The alternative is "noinline __init_refok" - the noinline is required 
because modern gcc versions already make it non-__init by inlining it 
into init_kmem_cache_nodes() without.

But I'm not convinced it's really worth manually forcing noinline only 
for moving a few bytes to __init in the CONFIG_NUMA=y case - in the  
long term this will only bit rot.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

