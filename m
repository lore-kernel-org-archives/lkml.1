Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZF3Pqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZF3Pqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZF3PqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:46:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:29627 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZF3PqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:46:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vi1dky4ibK3wTQBdWpMmB5lYb3KWlZZDYA7QmlAmH+ML43xNyaM/DSD6GZ/R9S5yFi
         T6rLIV++VGrRAQJKTwdF9XjqkEyYBPEqFuC+GSPPxVZheWSi2J8kJDcR/zI4hxzQfY5n
         XZJoeEHSvIhUBxTzrARfHXuEsWeYCwRwD4PyU=
MIME-Version: 1.0
In-Reply-To: <20090630152324.A73A.A69D9226@jp.fujitsu.com>
References: <20090630152324.A73A.A69D9226@jp.fujitsu.com>
Date: Wed, 1 Jul 2009 00:38:08 +0900
Message-ID: <28c262360906300838m778ed5e4s8fe54501b95ccc0c@mail.gmail.com>
Subject: Re: [PATCH] Makes slab pages field in show_free_areas() separate two 
	field
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 3:25 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> Subject: [PATCH] Makes slab pages field in show_free_areas() separate two field
>
> if OOM happed, We really want to know the number of rest reclaimable pages.
> Then, reclaimable slab and unreclaimable slab shouldn't be mixed displaing.

Yes. It makes sense to me.

>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

> ---
>  mm/page_alloc.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2119,7 +2119,8 @@ void show_free_areas(void)
>                " inactive_file:%lu"
>                " unevictable:%lu"
>                " dirty:%lu writeback:%lu unstable:%lu\n"
> -               " free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
> +               " free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
> +               " mapped:%lu pagetables:%lu bounce:%lu\n",
>                global_page_state(NR_ACTIVE_ANON),
>                global_page_state(NR_ACTIVE_FILE),
>                global_page_state(NR_INACTIVE_ANON),
> @@ -2129,8 +2130,8 @@ void show_free_areas(void)
>                global_page_state(NR_WRITEBACK),
>                global_page_state(NR_UNSTABLE_NFS),
>                global_page_state(NR_FREE_PAGES),
> -               global_page_state(NR_SLAB_RECLAIMABLE) +
> -                       global_page_state(NR_SLAB_UNRECLAIMABLE),
> +               global_page_state(NR_SLAB_RECLAIMABLE),
> +               global_page_state(NR_SLAB_UNRECLAIMABLE),
>                global_page_state(NR_FILE_MAPPED),
>                global_page_state(NR_PAGETABLE),
>                global_page_state(NR_BOUNCE));
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kinds regards,
Minchan Kim
