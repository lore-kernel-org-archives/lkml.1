Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbXFRFuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbXFRFuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 01:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbXFRFuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 01:50:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36566 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbXFRFuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 01:50:03 -0400
Date: Mon, 18 Jun 2007 14:49:24 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: More __meminit annotations.
In-Reply-To: <20070618045229.GA31635@linux-sh.org>
References: <20070618045229.GA31635@linux-sh.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070618143943.B108.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your checking.

> -void zone_init_free_lists(struct pglist_data *pgdat, struct zone *zone,
> -				unsigned long size)
> +static void __meminit zone_init_free_lists(struct pglist_data *pgdat,
> +				struct zone *zone, unsigned long size)
>  {
>  	int order;
>  	for (order = 0; order < MAX_ORDER ; order++) {
> @@ -2431,7 +2431,7 @@ void __meminit get_pfn_range_for_nid(unsigned int nid,
>   * Return the number of pages a zone spans in a node, including holes
>   * present_pages = zone_spanned_pages_in_node() - zone_absent_pages_in_node()
>   */
> -unsigned long __meminit zone_spanned_pages_in_node(int nid,
> +static unsigned long __meminit zone_spanned_pages_in_node(int nid,
>  					unsigned long zone_type,
>  					unsigned long *ignored)
>  {
> @@ -2519,7 +2519,7 @@ unsigned long __init absent_pages_in_range(unsigned long start_pfn,
>  }
>  
>  /* Return the number of page frames in holes in a zone on a node */
> -unsigned long __meminit zone_absent_pages_in_node(int nid,
> +static unsigned long __meminit zone_absent_pages_in_node(int nid,
>  					unsigned long zone_type,
>  					unsigned long *ignored)
>  {

Ah, Yes. Thanks. It is better.

> @@ -2536,14 +2536,14 @@ unsigned long __meminit zone_absent_pages_in_node(int nid,
>  }
>  
>  #else
> -static inline unsigned long zone_spanned_pages_in_node(int nid,
> +static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
>  					unsigned long zone_type,
>  					unsigned long *zones_size)
>  {
>  	return zones_size[zone_type];
>  }
>  
> -static inline unsigned long zone_absent_pages_in_node(int nid,
> +static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
>  						unsigned long zone_type,
>  						unsigned long *zholes_size)
>  {

I thought __meminit is not effective for these static functions,
because they are inlined function. So, it depends on caller's 
defenition. Is it wrong? 

Bye.

-- 
Yasunori Goto 


