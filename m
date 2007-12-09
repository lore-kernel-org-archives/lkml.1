Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbXLIIdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbXLIIdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 03:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXLIIdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 03:33:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:61056 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbXLIIdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 03:33:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eyRIomslmybE5X1OjMPvqc9JWqI+1KtYNAJs+lYfXJQUjcS7fPii1RT6MOgOU+hwTdSiGkETziovIbTTWaLnRtSrolprL+P6mp5vuaEsjO8nualfTwH3+qV9UY4xMauttONKb9ox6frmcBmVebqbFFIQSldNvblnwYW4J+MVMUw=
Message-ID: <84144f020712090033q635b282at2942e3a9eb52eba6@mail.gmail.com>
Date: Sun, 9 Dec 2007 10:33:11 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52, [2.6.24-rc4-git5: Reported regressions from 2.6.23]
Cc: "Matt Mackall" <mpm@selenic.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu>
	 <20071208163749.GI19691@waste.org>
	 <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org>
	 <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
X-Google-Sender-Auth: 3d5d8a12fcd1dcff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Dec 8, 2007 7:54 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> diff --git a/mm/slob.c b/mm/slob.c
> index ee2ef8a..773a7aa 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -330,7 +330,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
>
>         /* Not enough space: must allocate a new page */
>         if (!b) {
> -               b = slob_new_page(gfp, 0, node);
> +               b = slob_new_page(gfp & ~__GFP_ZERO, 0, node);
>                 if (!b)
>                         return 0;
>                 sp = (struct slob_page *)virt_to_page(b);
>
> diff --git a/mm/slub.c b/mm/slub.c
> index b9f37cb..9c1d9f3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1468,6 +1468,9 @@ static void *__slab_alloc(struct kmem_cache *s,
>         void **object;
>         struct page *new;
>
> +       /* We handle __GFP_ZERO in the caller */
> +       gfpflags &= ~__GFP_ZERO;
> +
>         if (!c->page)
>                 goto new_slab;

In case you didn't already merge this:

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
