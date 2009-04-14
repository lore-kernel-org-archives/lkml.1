Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbZDNEh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbZDNEh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 00:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZDNEhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 00:37:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38773 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZDNEhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 00:37:13 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH] proc: export more page flags in /proc/kpageflags
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <20090414042231.GA4341@localhost>
References: <20090414042231.GA4341@localhost>
Message-Id: <20090414133448.C645.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 14 Apr 2009 13:37:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Export the following page flags in /proc/kpageflags,
> just in case they will be useful to someone:
> 
> - PG_swapcache
> - PG_swapbacked
> - PG_mappedtodisk
> - PG_reserved
> - PG_private
> - PG_private_2
> - PG_owner_priv_1
> 
> - PG_head
> - PG_tail
> - PG_compound
> 
> - PG_unevictable
> - PG_mlocked
> 
> - PG_poison

Sorry, NAK this.
We shouldn't expose internal flags. please choice useful flags only.

> 
> Also add the following two pseudo page flags:
> 
> - PG_MMAP:   whether the page is memory mapped
> - PG_NOPAGE: whether the page is present
> 
> This increases the total number of exported page flags to 25.
> 
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/proc/page.c |  112 +++++++++++++++++++++++++++++++++--------------
>  1 file changed, 81 insertions(+), 31 deletions(-)
> 
> --- mm.orig/fs/proc/page.c
> +++ mm/fs/proc/page.c
> @@ -68,20 +68,86 @@ static const struct file_operations proc
>  
>  /* These macros are used to decouple internal flags from exported ones */
>  
> -#define KPF_LOCKED     0
> -#define KPF_ERROR      1
> -#define KPF_REFERENCED 2
> -#define KPF_UPTODATE   3
> -#define KPF_DIRTY      4
> -#define KPF_LRU        5
> -#define KPF_ACTIVE     6
> -#define KPF_SLAB       7
> -#define KPF_WRITEBACK  8
> -#define KPF_RECLAIM    9
> -#define KPF_BUDDY     10
> +enum {
> +	KPF_LOCKED,		/*  0 */
> +	KPF_ERROR,		/*  1 */
> +	KPF_REFERENCED,		/*  2 */
> +	KPF_UPTODATE,		/*  3 */
> +	KPF_DIRTY,		/*  4 */
> +	KPF_LRU,		/*  5 */
> +	KPF_ACTIVE,		/*  6 */
> +	KPF_SLAB,		/*  7 */
> +	KPF_WRITEBACK,		/*  8 */
> +	KPF_RECLAIM,		/*  9 */
> +	KPF_BUDDY,		/* 10 */
> +	KPF_MMAP,		/* 11 */
> +	KPF_SWAPCACHE,		/* 12 */
> +	KPF_SWAPBACKED,		/* 13 */
> +	KPF_MAPPEDTODISK,	/* 14 */
> +	KPF_RESERVED,		/* 15 */
> +	KPF_PRIVATE,		/* 16 */
> +	KPF_PRIVATE2,		/* 17 */
> +	KPF_OWNER_PRIVATE,	/* 18 */
> +	KPF_COMPOUND_HEAD,	/* 19 */
> +	KPF_COMPOUND_TAIL,	/* 20 */
> +	KPF_UNEVICTABLE,	/* 21 */
> +	KPF_MLOCKED,		/* 22 */
> +	KPF_POISON,		/* 23 */
> +	KPF_NOPAGE,		/* 24 */
> +	KPF_NUM
> +};

this is userland export value. then enum is wrong idea.
explicit name-number relationship is better. it prevent unintetional
ABI break.



