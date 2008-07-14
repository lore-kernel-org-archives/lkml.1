Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbYGNQ2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbYGNQ2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757399AbYGNQ2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:28:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46038 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbYGNQ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:28:30 -0400
Subject: Re: [PATCH] kmemtrace: SLAB hooks.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@linux-foundation.org
In-Reply-To: <1215889471-5734-1-git-send-email-eduard.munteanu@linux360.ro>
References: <84144f020807110149v4806404fjdb9c3e4af3cfdb70@mail.gmail.com>
	 <1215889471-5734-1-git-send-email-eduard.munteanu@linux360.ro>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 14 Jul 2008 19:28:13 +0300
Message-Id: <1216052893.6762.3.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard-Gabriel,

On Sat, 2008-07-12 at 22:04 +0300, Eduard - Gabriel Munteanu wrote:
> This adds hooks for the SLAB allocator, to allow tracing with kmemtrace.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> @@ -28,8 +29,20 @@ extern struct cache_sizes malloc_sizes[];
>  void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
>  void *__kmalloc(size_t size, gfp_t flags);
>  
> +#ifdef CONFIG_KMEMTRACE
> +extern void *__kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags);
> +#else
> +static inline void *__kmem_cache_alloc(struct kmem_cache *cachep,
> +				       gfp_t flags)
> +{
> +	return __kmem_cache_alloc(cachep, flags);

Looks as if the function calls itself ﻿recursively?

