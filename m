Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbYGANj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbYGANj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbYGANjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:39:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757963AbYGANjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:39:10 -0400
Date: Tue, 1 Jul 2008 09:38:40 -0400
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "MinChan Kim" <minchan.kim@gmail.com>, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [resend][PATCH -mm] split_lru: fix pagevec_move_tail() doesn't
 treat unevictable page
Message-ID: <20080701093840.07b48ced@bree.surriel.com>
In-Reply-To: <20080701172223.3801.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080701155749.37F8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080701172223.3801.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jul 2008 17:26:51 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

Good catch!
 
> @@ -116,7 +116,7 @@ static void pagevec_move_tail(struct pag
>  			zone = pagezone;
>  			spin_lock(&zone->lru_lock);
>  		}
> -		if (PageLRU(page) && !PageActive(page)) {
> +		if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
>  			int lru = page_is_file_cache(page);
>  			list_move_tail(&page->lru, &zone->lru[lru].list);
>  			pgmoved++;

-- 
All rights reversed.
