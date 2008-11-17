Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbYKQIYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbYKQIYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYKQIYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:24:12 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:33353 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYKQIYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:24:12 -0500
Message-ID: <49212A23.3000209@linux.vnet.ibm.com>
Date: Mon, 17 Nov 2008 13:54:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com,
       arjan@infradead.org, airlied@gmail.com, menage@google.com,
       jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com, adobriyan@gmail.com
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
References: <20081117142539.9b2c6bfc.kamezawa.hiroyu@jp.fujitsu.com> <2f11576a0811162243r7527d271ya8ab2fc3a9be9f7d@mail.gmail.com> <20081116231301.c6b0da95.akpm@linux-foundation.org> <20081116.231555.190117597.davem@davemloft.net>
In-Reply-To: <20081116.231555.190117597.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Sun, 16 Nov 2008 23:13:01 -0800
> 
>> In fact it's not immediately clear why __vmalloc() takes a gfp_t
>> argument either?
> 
> Probably for things like GFP_DMA32, GFP_HIGHMEM, et al.
> 

vmalloc() hides away GFP_DMA32 and hard codes gfp_mask to GFP_KERNEL |
__GFP_HIGHMEM. __vmalloc() lies like Andrew mentioned. For the use cases
mentioned in this thread, we don't really care about GFP_DMA32 (or do we?).

I would prefer to avoid passing the gfp_mask and call the API something like
blocking_vkmalloc() and blocking_vkzalloc() or something better.

-- 
	Balbir
