Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbXISSTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbXISSTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXISSTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:19:13 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:47742 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXISSTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:19:12 -0400
Message-ID: <46F16802.4010002@linux.vnet.ibm.com>
Date: Wed, 19 Sep 2007 23:48:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Badari Pulavarty <pbadari@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, balbir@in.ibm.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc6-mm1 panic (memory controller issue ?)
References: <1190154076.31220.19.camel@dyn9047017100.beaverton.ibm.com> <1190161903.31220.24.camel@dyn9047017100.beaverton.ibm.com> <46F08135.70401@linux.vnet.ibm.com> <Pine.LNX.4.64.0709191024440.11138@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709191024440.11138@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 19 Sep 2007, Balbir Singh wrote:
> 
>> The fix looks correct, radix_tree_preload() does the same thing in
>> add_to_page_cache(). Thanks for identifying the fix
> 
> Hmmm.... Radix tree preload can only take a limited set of flags?
> 

Yes, the whole code is very interesting. From add_to_page_cache()
we call radix_tree_preload with __GFP_HIGHMEM cleared, but
from __add_to_swap_cache(), we don't make any changes to the
gfp_mask. radix_tree_preload() calls kmem_cache_alloc() and in slub
there is a check

        BUG_ON(flags & GFP_SLAB_BUG_MASK);

So, I guess all our allocations should check against __GFP_DMA and
__GFP_HIGHMEM. I'll review the code, test it and send a fix.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
