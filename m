Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbXJWHwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbXJWHwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXJWHwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:52:30 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:49631 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbXJWHw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:52:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=c7ZDYXgrkO8ODiHwCm+8nzYdGjnO2z6OpJcBPbortfN3inwec9yatmGoap8i+f2RBtl8DvTbstvwRTzCgSqyV/L1h1a0YMfduYCm6jRtKh+mue/G4Q02CGqG3torPHjdaNETCpYXvvGE6eWEcP8eWcaDnnpOv2WnZnkz0y8kcc0=
Message-ID: <84144f020710230052t3dc7e402ka2d8ede6db81618a@mail.gmail.com>
Date: Tue, 23 Oct 2007 10:52:28 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Yasunori Goto" <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] Fix warning in mm/slub.c
Cc: "Olof Johansson" <olof@lixom.net>, "Andrew Morton" <akpm@osdl.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel ML" <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20071023143212.8D2E.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071018122345.514F.Y-GOTO@jp.fujitsu.com>
	 <20071023042153.GA20693@lixom.net>
	 <20071023143212.8D2E.Y-GOTO@jp.fujitsu.com>
X-Google-Sender-Auth: f1f6e72589a74457
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/23/07, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> > "Make kmem_cache_node for SLUB on memory online to avoid panic" introduced
> > the following:
> >
> > mm/slub.c:2737: warning: passing argument 1 of 'atomic_read' from
> > incompatible pointer type
> >
> >
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> >
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index aac1dd3..bcdb2c8 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2734,7 +2734,7 @@ static void slab_mem_offline_callback(void *arg)
> >                        * and offline_pages() function shoudn't call this
> >                        * callback. So, we must fail.
> >                        */
> > -                     BUG_ON(atomic_read(&n->nr_slabs));
> > +                     BUG_ON(atomic_long_read(&n->nr_slabs));
> >
> >                       s->node[offline_node] = NULL;
> >                       kmem_cache_free(kmalloc_caches, n);
>
>
> Oops, yes. Thanks.
>
> Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
