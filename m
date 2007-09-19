Return-Path: <linux-kernel-owner+w=401wt.eu-S1762018AbXISSzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762018AbXISSzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXISSyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:54:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60199 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753421AbXISSyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:54:52 -0400
Date: Wed, 19 Sep 2007 11:54:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Badari Pulavarty <pbadari@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, balbir@in.ibm.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc6-mm1 panic (memory controller issue ?)
In-Reply-To: <46F16802.4010002@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0709191154230.2241@schroedinger.engr.sgi.com>
References: <1190154076.31220.19.camel@dyn9047017100.beaverton.ibm.com>
 <1190161903.31220.24.camel@dyn9047017100.beaverton.ibm.com>
 <46F08135.70401@linux.vnet.ibm.com> <Pine.LNX.4.64.0709191024440.11138@schroedinger.engr.sgi.com>
 <46F16802.4010002@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Balbir Singh wrote:

> Yes, the whole code is very interesting. From add_to_page_cache()
> we call radix_tree_preload with __GFP_HIGHMEM cleared, but
> from __add_to_swap_cache(), we don't make any changes to the
> gfp_mask. radix_tree_preload() calls kmem_cache_alloc() and in slub
> there is a check
> 
>         BUG_ON(flags & GFP_SLAB_BUG_MASK);
> 
> So, I guess all our allocations should check against __GFP_DMA and
> __GFP_HIGHMEM. I'll review the code, test it and send a fix.

You need to use the proper mask from include/linux/gfp.h. Masking 
individual bits will create problems when we create new bits.

