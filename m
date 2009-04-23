Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbZDWUZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbZDWUZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZDWUZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:25:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbZDWUZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:25:36 -0400
Date: Thu, 23 Apr 2009 13:23:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H Hartley Sweeten" <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc.c: fix sparse warning
Message-Id: <20090423132358.2adf4611.akpm@linux-foundation.org>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909015F9239@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F9239@mi8nycmail19.Mi8.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 20:55:06 -0400
"H Hartley Sweeten" <hartleys@visionengravers.com> wrote:

> Fix sparse warning in mm/vmalloc.c.
> 
>   warning: symbol 'tmp' shadows an earlier one
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> ---
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index fab1987..4959a30 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -292,13 +292,13 @@ static void __insert_vmap_area(struct vmap_area
> *va)
>  	struct rb_node *tmp;
>  
>  	while (*p) {
> -		struct vmap_area *tmp;
> +		struct vmap_area *tmp_va;
>  
>  		parent = *p;
> -		tmp = rb_entry(parent, struct vmap_area, rb_node);
> -		if (va->va_start < tmp->va_end)
> +		tmp_va = rb_entry(parent, struct vmap_area, rb_node);
> +		if (va->va_start < tmp_va->va_end)
>  			p = &(*p)->rb_left;
> -		else if (va->va_end > tmp->va_start)
> +		else if (va->va_end > tmp_va->va_start)
>  			p = &(*p)->rb_right;
>  		else
>  			BUG(); 

It would be sufficient to simply delete the inner definition of `tmp'.

Use of a variable called "tmp" is often bad - it's almost always a
result of plain old laziness and the code can be improved by using a
more meaningful identifier.

But in this case the code is sufficiently short and simple that I guess
we can live with "tmp".

