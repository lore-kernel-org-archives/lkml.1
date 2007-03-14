Return-Path: <linux-kernel-owner+w=401wt.eu-S1161335AbXCNPL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161335AbXCNPL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422636AbXCNPL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:11:26 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:58895 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161335AbXCNPLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:11:25 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Mel Gorman <mel@skynet.ie>
Subject: Re: 2.6.21-rc3-mm2 (oops in move_freepages)
Date: Wed, 14 Mar 2007 09:11:16 -0600
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070307201915.4d579113.akpm@linux-foundation.org> <200703132152.10136.bjorn.helgaas@hp.com> <20070314094454.GA1652@skynet.ie>
In-Reply-To: <20070314094454.GA1652@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703140911.16537.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007 03:44, Mel Gorman wrote:
> Please try the following patch from Yasunori Goto.
> ...
> --- current_test.orig/mm/page_alloc.c	2007-03-08 15:44:10.000000000 +0900
> +++ current_test/mm/page_alloc.c	2007-03-08 16:17:29.000000000 +0900
> @@ -707,7 +707,7 @@ int move_freepages(struct zone *zone,
>  	unsigned long order;
>  	int blocks_moved = 0;
>  
> -	BUG_ON(page_zone(start_page) != page_zone(end_page));
> +	BUG_ON(page_zone(start_page) != page_zone(end_page - 1));
>  

I should have mentioned that I already tried this patch.  The
oops still occurs, although now it's when loading the value
pointed to by "end_page - 1" instead of "end_page".
