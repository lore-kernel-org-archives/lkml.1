Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYAHWTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYAHWTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYAHWSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:18:42 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54559 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755995AbYAHWSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:18:41 -0500
Date: Tue, 8 Jan 2008 14:18:40 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [patch 03/19] define page_file_cache() function
In-Reply-To: <20080108205959.952424899@redhat.com>
Message-ID: <Pine.LNX.4.64.0801081414230.4281@schroedinger.engr.sgi.com>
References: <20080108205939.323955454@redhat.com> <20080108205959.952424899@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Rik van Riel wrote:

> Define page_file_cache() function to answer the question:
> 	is page backed by a file?

> +static inline int page_file_cache(struct page *page)
> +{
> +	if (PageSwapBacked(page))
> +		return 0;

Could we call this PageNotFileBacked or so? PageSwapBacked is true for 
pages that are RAM based. Its a bit confusing.

> Index: linux-2.6.24-rc6-mm1/mm/migrate.c
> ===================================================================
> --- linux-2.6.24-rc6-mm1.orig/mm/migrate.c	2008-01-02 12:37:14.000000000 -0500
> +++ linux-2.6.24-rc6-mm1/mm/migrate.c	2008-01-02 12:37:22.000000000 -0500
> @@ -546,6 +546,8 @@ static int move_to_new_page(struct page 
>  	/* Prepare mapping for the new page.*/
>  	newpage->index = page->index;
>  	newpage->mapping = page->mapping;
> +	if (PageSwapBacked(page))
> +		SetPageSwapBacked(newpage);
>  
>  	mapping = page_mapping(page);
>  	if (!mapping)

That hunk belongs into migrate_page_copy()? Or is there a reason that we 
need this flag that early?
