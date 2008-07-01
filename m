Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbYGAHeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbYGAHeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYGAHeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:34:36 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:49009 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYGAHeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:34:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LFkS0AsOBbPBVqziWzRwkHJdDN03DuKSRQdBCPm9+46UlvW/OJiJFn0Lkkc7p2Feze
         Ndp2wJK/k+VQ1pVUXi+2lf9doMNiBwn/VEcZoaRH/UUalgd1GHxhoYB424Jue027luwr
         a9mTm3oqwkTl9X6nGfTVjTYKUIqYflDNxzJ/4=
Message-ID: <28c262360807010034m7438f1e3yc28daae9978150b6@mail.gmail.com>
Date: Tue, 1 Jul 2008 16:34:35 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm] split_lru: fix pagevec_move_tail() doesn't treat unevictable page
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Rik van Riel" <riel@redhat.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
In-Reply-To: <20080701155749.37F8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701155749.37F8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 4:01 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> even under writebacking, page can move to unevictable list.
> so shouldn't pagevec_move_tail() check unevictable?
>
Hi, Kosaki-san.

I can't understand this race situation.
How the page can move to unevictable list while it is under writeback?

Could you explain for me ? :)

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> ---
>  mm/swap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: b/mm/swap.c
> ===================================================================
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -116,7 +116,7 @@ static void pagevec_move_tail(struct pag
>                        zone = pagezone;
>                        spin_lock(&zone->lru_lock);
>                }
> -               if (PageLRU(page) && !PageActive(page)) {
> +               if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
>                        int lru = page_is_file_cache(page);
>                        list_move_tail(&page->lru, &zone->lru[lru].list);
>                        pgmoved++;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kinds regards,
MinChan Kim
