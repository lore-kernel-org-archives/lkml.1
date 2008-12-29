Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbYL2NoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbYL2NoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYL2Nn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:43:59 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57816 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbYL2Nn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:43:59 -0500
Subject: Re: [PATCH 3/3] kmemtrace: Use tracepoints instead of markers.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <0d1bc24fa2c8d9df136cf833a36be2b72340bc8f.1230499486.git.eduard.munteanu@linux360.ro>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro>
	 <01504e3763e57759f34045051e86cb35c17b43b5.1230499486.git.eduard.munteanu@linux360.ro>
	 <4dcbaab558466e1cd0be66f3b66c7c5d2a0c532b.1230499486.git.eduard.munteanu@linux360.ro>
	 <0d1bc24fa2c8d9df136cf833a36be2b72340bc8f.1230499486.git.eduard.munteanu@linux360.ro>
Date: Mon, 29 Dec 2008 15:43:56 +0200
Message-Id: <1230558236.6078.13.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard,

On Mon, 2008-12-29 at 03:40 +0200, Eduard - Gabriel Munteanu wrote:
> diff --git a/mm/slab.c b/mm/slab.c
> index 1fcb32b..74d405d 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3624,8 +3624,9 @@ void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
>  {
>  	void *ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
>  
> -	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
> -			     obj_size(cachep), cachep->buffer_size, flags);
> +	trace_kmemtrace_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
> +			      obj_size(cachep), cachep->buffer_size,
> +			      flags, -1);

One minor nit: I'd prefer we call these trace_kmem_cache_alloc(),
trace_kmalloc(), and so on. The trace_kmemtrace prefix doesn't really
make much sense to me.

