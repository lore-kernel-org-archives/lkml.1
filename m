Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZGEOQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZGEOQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 10:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZGEOQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 10:16:24 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:43573 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZGEOQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 10:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DZh0wmrg7xmDo1DeFsEWSPo1iLfagO6jvDeIx+2cP/H1i5VhyR1JE4W4KmVpAJlmEj
         PWbXCzvOh0m8jt0zlW8Mo4H7IMRiHFbDBY95S28XyyX3TumWk1t76oWUjqIzVkW/sMU+
         y69mDhXMjr32BvKHwxl0HbxijcZbDOXDQ0MGU=
MIME-Version: 1.0
In-Reply-To: <20090705182337.08F9.A69D9226@jp.fujitsu.com>
References: <20090705181400.08F1.A69D9226@jp.fujitsu.com>
	 <20090705182337.08F9.A69D9226@jp.fujitsu.com>
Date: Sun, 5 Jul 2009 23:16:27 +0900
Message-ID: <28c262360907050716x28671070of7ab21556213b337@mail.gmail.com>
Subject: Re: [PATCH 2/5] add buffer cache information to show_free_areas()
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 5, 2009 at 6:24 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> Subject: [PATCH] add buffer cache information to show_free_areas()
>
> When administrator analysis memory shortage reason from OOM log, They
> often need to know rest number of cache like pages.
>
> Then, show_free_areas() shouldn't only display page cache, but also it
> should display buffer cache.
>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/page_alloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2118,7 +2118,7 @@ void show_free_areas(void)
>        printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
>                " inactive_file:%lu"
>                " unevictable:%lu"
> -               " dirty:%lu writeback:%lu unstable:%lu\n"
> +               " dirty:%lu writeback:%lu buffer:%lu unstable:%lu\n"
>                " free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
>                " mapped:%lu pagetables:%lu bounce:%lu\n",
>                global_page_state(NR_ACTIVE_ANON),
> @@ -2128,6 +2128,7 @@ void show_free_areas(void)
>                global_page_state(NR_UNEVICTABLE),
>                global_page_state(NR_FILE_DIRTY),
>                global_page_state(NR_WRITEBACK),
> +               K(nr_blockdev_pages()),

Why do you show the number with kilobyte unit ?
Others are already number of pages.

Do you have any reason ?


-- 
Kind regards,
Minchan Kim
