Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbXLBSXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbXLBSXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbXLBSXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:23:36 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:28986 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbXLBSXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:23:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YhQJwgSz6jekFri9GjscaavDmheXcOIgXLN9PXTlw0V17FAdqOifCHiTh/sZTe1k9tauDWWVwuKW7TyUlSOSy4IJuIgFHYjSQTP0cLcq2TKS9I74pcQgBIitCGTtCzTdq270a3KtN8viBZId7cUtHo/e0kSbIJAFhxz8BqzzToQ=
Message-ID: <84144f020712021023w7137bafbw9e9d114e68ce524d@mail.gmail.com>
Date: Sun, 2 Dec 2007 20:23:35 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [BUG 2.6.24-rc3-git6] SLUB's ksize() fails for size > 2048.
Cc: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <19f34abd0712020843m1dccfa3bu38388e1a53b05fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712021939.HHH18792.FLQSOOtFOFJVHM@I-love.SAKURA.ne.jp>
	 <19f34abd0712020830y4825691atdfc9dac07ce4cb35@mail.gmail.com>
	 <19f34abd0712020843m1dccfa3bu38388e1a53b05fc@mail.gmail.com>
X-Google-Sender-Auth: 23fceae30bf4d6bb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On 12/2/07, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> diff --git a/mm/slub.c b/mm/slub.c
> index 9acb413..b9f37cb 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2558,8 +2558,12 @@ size_t ksize(const void *object)
>         if (unlikely(object == ZERO_SIZE_PTR))
>                 return 0;
>
> -       page = get_object_page(object);
> +       page = virt_to_head_page(object);
>         BUG_ON(!page);
> +
> +       if (unlikely(!PageSlab(page)))
> +               return PAGE_SIZE << compound_order(page);
> +
>         s = page->slab;
>         BUG_ON(!s);

Looks good to me.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
