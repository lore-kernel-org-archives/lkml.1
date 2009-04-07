Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbZDGXWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbZDGXWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZDGXVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:21:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:4890 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbZDGXVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cdRH+iIdxfCshm931zPRexHSLjcNsTy0xgB0BLBDpdLLAkECKBWSHrmMocJ4WeBAwO
         UyXiXn1OJPOabHMSvYkz3P6sUh2XIGQ7uiQszni25UgVglZ1yr1jmo74KTn9K6Mq81/l
         kSJfeVqWbPJZ8GnYufw3f0cfOGb2Brzs+INZI=
MIME-Version: 1.0
In-Reply-To: <20090407150959.C099D1D046E@basil.firstfloor.org>
References: <20090407509.382219156@firstfloor.org>
	 <20090407150959.C099D1D046E@basil.firstfloor.org>
Date: Wed, 8 Apr 2009 08:21:51 +0900
Message-ID: <28c262360904071621j5bdd8e33u1fbd8534d177a941@mail.gmail.com>
Subject: Re: [PATCH] [3/16] POISON: Handle poisoned pages in page free
From: Minchan Kim <minchan.kim@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi.

On Wed, Apr 8, 2009 at 12:09 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Make sure no poisoned pages are put back into the free page
> lists.  This can happen with some races.
>
> This is allo slow path in the bad page bits path, so another
> check doesn't really matter.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> ---
>  mm/page_alloc.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> Index: linux/mm/page_alloc.c
> ===================================================================
> --- linux.orig/mm/page_alloc.c  2009-04-07 16:39:26.000000000 +0200
> +++ linux/mm/page_alloc.c       2009-04-07 16:39:39.000000000 +0200
> @@ -228,6 +228,15 @@
>        static unsigned long nr_unshown;
>
>        /*
> +        * Page may have been marked bad before process is freeing it.
> +        * Make sure it is not put back into the free page lists.
> +        */
> +       if (PagePoison(page)) {
> +               /* check more flags here... */

How about adding WARNING with some information(ex, pfn, flags..).


> +               return;
> +       }
> +
> +       /*
>         * Allow a burst of 60 reports, then keep quiet for that minute;
>         * or allow a steady drip of one report per second.
>         */
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kinds regards,
Minchan Kim
