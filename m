Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbXISTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbXISTF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXISTFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:05:18 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:45839 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbXISTFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:05:16 -0400
Message-ID: <46F172C8.4030207@linux.vnet.ibm.com>
Date: Thu, 20 Sep 2007 00:34:40 +0530
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
References: <1190154076.31220.19.camel@dyn9047017100.beaverton.ibm.com> <1190161903.31220.24.camel@dyn9047017100.beaverton.ibm.com> <46F08135.70401@linux.vnet.ibm.com> <Pine.LNX.4.64.0709191024440.11138@schroedinger.engr.sgi.com> <46F16802.4010002@linux.vnet.ibm.com> <Pine.LNX.4.64.0709191154230.2241@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709191154230.2241@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 19 Sep 2007, Balbir Singh wrote:
> 
>> Yes, the whole code is very interesting. From add_to_page_cache()
>> we call radix_tree_preload with __GFP_HIGHMEM cleared, but
>> from __add_to_swap_cache(), we don't make any changes to the
>> gfp_mask. radix_tree_preload() calls kmem_cache_alloc() and in slub
>> there is a check
>>
>>         BUG_ON(flags & GFP_SLAB_BUG_MASK);
>>
>> So, I guess all our allocations should check against __GFP_DMA and
>> __GFP_HIGHMEM. I'll review the code, test it and send a fix.
> 
> You need to use the proper mask from include/linux/gfp.h. Masking 
> individual bits will create problems when we create new bits.
> 

I agree 100%, that's why I want to review the code. I want to use
a mask that clears the GFP_SLAB_BUG_MASK bits and review it. I want
to check against other call sites that use gfp_mask as well.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
