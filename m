Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbYAGJUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbYAGJUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 04:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbYAGJT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 04:19:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33141 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbYAGJTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 04:19:55 -0500
Date: Mon, 7 Jan 2008 18:23:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, lee.schermerhorn@hp.com,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 06/19] split LRU lists into anon & file sets
Message-Id: <20080107182302.a6f268fc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080102224154.205031565@redhat.com>
References: <20080102224144.885671949@redhat.com>
	<20080102224154.205031565@redhat.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jan 2008 17:41:50 -0500
linux-kernel@vger.kernel.org wrote:


>  static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
> -				struct scan_control *sc, int priority)
> +				struct scan_control *sc, int priority, int file)
>  {
>  	unsigned long pgmoved;
>  	int pgdeactivate = 0;
> @@ -1128,64 +1026,65 @@ static void shrink_active_list(unsigned 
>  	struct list_head list[NR_LRU_LISTS];
>  	struct page *page;
>  	struct pagevec pvec;
> -	int reclaim_mapped = 0;
> -	enum lru_list l;
> +	enum lru_list lru;
<snip>

> +	/*
> +	 * For sorting active vs inactive pages, we'll use the 'anon'
> +	 * elements of the local list[] array and sort out the file vs
> +	 * anon pages below.
> +	 */

This is not easy to read.... (this definition affects later patches...)

How about adding some new enum (only) for this function ?
like
 LRU_STAY_ACTIVE = 0,
 LRU_MOVE_INACTIVE = 1,

Thanks,
-Kame

