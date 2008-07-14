Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYGNQdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYGNQdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYGNQdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:33:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481AbYGNQdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:33:01 -0400
Message-ID: <487B7F99.4060004@linux-foundation.org>
Date: Mon, 14 Jul 2008 11:32:25 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kmemtrace: SLAB hooks.
References: <84144f020807110149v4806404fjdb9c3e4af3cfdb70@mail.gmail.com>	 <1215889471-5734-1-git-send-email-eduard.munteanu@linux360.ro> <1216052893.6762.3.camel@penberg-laptop>
In-Reply-To: <1216052893.6762.3.camel@penberg-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Eduard-Gabriel,
> 
> On Sat, 2008-07-12 at 22:04 +0300, Eduard - Gabriel Munteanu wrote:
>> This adds hooks for the SLAB allocator, to allow tracing with kmemtrace.
>>
>> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
>> @@ -28,8 +29,20 @@ extern struct cache_sizes malloc_sizes[];
>>  void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
>>  void *__kmalloc(size_t size, gfp_t flags);
>>  
>> +#ifdef CONFIG_KMEMTRACE
>> +extern void *__kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags);
>> +#else
>> +static inline void *__kmem_cache_alloc(struct kmem_cache *cachep,
>> +				       gfp_t flags)
>> +{
>> +	return __kmem_cache_alloc(cachep, flags);
> 
> Looks as if the function calls itself ﻿recursively?
> 

Code not tested? Are you sure you configured for slab?

