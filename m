Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbXHBMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbXHBMES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXHBMEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:04:08 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:37567 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbXHBMEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:04:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eM48sCtZSdBFbmNPp21VHHVpzaCNbPCYKaZklyGs3nWwnsLflJ+v+74gss5zbfnNrC1zrRldPCBT0oG1opwBCSa5G4bDoUWKaaWQMCJcx3MpJkYJ5webkk3FaMcJK8pK0ziuIyxeh4TGzCp3XGGfBaVYmQzDYy3qLWCduOwljxU=
Message-ID: <b6fcc0a0708020504j7588061fq7e70a50499dcbdfe@mail.gmail.com>
Date: Thu, 2 Aug 2007 16:04:06 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH] type safe allocator
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org
In-Reply-To: <E1IGYuK-0001Jj-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
	 <E1IGYuK-0001Jj-00@dorka.pomaz.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/2/07, Miklos Szeredi <miklos@szeredi.hu> wrote:
> The linux kernel doesn't have a type safe object allocator a-la new()
> in C++ or g_new() in glib.
>
> Introduce two helpers for this purpose:
>
>    alloc_struct(type, gfp_flags);
>
>    zalloc_struct(type, gfp_flags);

ick.

> These macros take a type name (usually a 'struct foo') as first
> argument

So one has to type struct twice.

> and the usual gfp-flags as second argument.  They return a
> pointer cast to 'type *'.
>
> The traditional forms of allocating a structure are:
>
>   fooptr = kmalloc(sizeof(*fooptr), ...);
>
>   fooptr = kmalloc(sizeof(struct foo), ...);

Key word is "traditional". Good traditional form which even half-competent
C programmers immediately parse in retina.

> The new form is preferred over these, because of it's type safety and
> more descriptive nature.

> +/**
> + * alloc_struct - allocate given type object
> + * @type: the type of the object to allocate
> + * @flags: the type of memory to allocate.
> + */
> +#define alloc_struct(type, flags) ((type *) kmalloc(sizeof(type), flags))

someone will write alloc_struct(int, GFP_KERNEL), I promise.

Can you play instead with something Lisp based which has infinetely more
potential for idioms.
