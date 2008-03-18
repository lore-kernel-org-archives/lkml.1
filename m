Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYCRLby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYCRLby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYCRLbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:31:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34790 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYCRLbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:31:44 -0400
Subject: Re: [patch 3/8] mm: rotate_reclaimable_page() cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080317191944.208962764@szeredi.hu>
References: <20080317191908.123631326@szeredi.hu>
	 <20080317191944.208962764@szeredi.hu>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 12:31:36 +0100
Message-Id: <1205839896.8514.344.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-17 at 20:19 +0100, Miklos Szeredi wrote:
> plain text document attachment (rotate_reclaimable_page_cleanup.patch)
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Clean up messy conditional calling of test_clear_page_writeback() from
> both rotate_reclaimable_page() and end_page_writeback().

> -int rotate_reclaimable_page(struct page *page)
> +void  rotate_reclaimable_page(struct page *page)
>  {
> -	struct pagevec *pvec;
> -	unsigned long flags;
> -
> -	if (PageLocked(page))
> -		return 1;
> -	if (PageDirty(page))
> -		return 1;
> -	if (PageActive(page))
> -		return 1;
> -	if (!PageLRU(page))
> -		return 1;

Might be me, but I find the above easier to read than

> +	if (!PageLocked(page) && !PageDirty(page) && !PageActive(page) &&
> +	    PageLRU(page)) {
>  



