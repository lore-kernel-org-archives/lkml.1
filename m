Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbXJ3SjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbXJ3SjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbXJ3SjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:39:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835AbXJ3SjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:39:04 -0400
Date: Tue, 30 Oct 2007 11:38:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       penberg@cs.helsinki.fi
Subject: Re: [patch 07/10] SLUB: Avoid referencing kmem_cache structure in
 __slab_alloc
Message-Id: <20071030113848.930471e6.akpm@linux-foundation.org>
In-Reply-To: <20071028033259.992768446@sgi.com>
References: <20071028033156.022983073@sgi.com>
	<20071028033259.992768446@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007 20:32:03 -0700
Christoph Lameter <clameter@sgi.com> wrote:

> There is the need to use the objects per slab in the first part of
> __slab_alloc() which is still pretty hot. Copy the number of objects
> per slab into the kmem_cache_cpu structure. That way we can get the
> value from a cache line that we already need to touch. This brings
> the kmem_cache_cpu structure up to 4 even words.
> 
> There is no increase in the size of kmem_cache_cpu since the size of object
> is rounded to the next word.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  include/linux/slub_def.h |    1 +
>  mm/slub.c                |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/include/linux/slub_def.h
> ===================================================================
> --- linux-2.6.orig/include/linux/slub_def.h	2007-10-26 19:09:16.000000000 -0700
> +++ linux-2.6/include/linux/slub_def.h	2007-10-27 07:55:12.000000000 -0700
> @@ -17,6 +17,7 @@ struct kmem_cache_cpu {
>  	int node;
>  	unsigned int offset;
>  	unsigned int objsize;
> +	unsigned int objects;
>  };

mutter.  nr_objects would be a better name, but then one should rename
kmem_cache.objects too.

Better would be to comment the field.  Please devote extra care to commenting
data structures.
