Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZFWAsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZFWAsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZFWAr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:47:57 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51493 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZFWAr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:47:56 -0400
Date: Tue, 23 Jun 2009 06:17:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] fix bad page removal from LRU (Was Re:
	[RFC][PATCH] cgroup: fix permanent wait in rmdir
Message-ID: <20090623004716.GD8642@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090622183707.dd9e665b.kamezawa.hiroyu@jp.fujitsu.com> <20090622105231.GA17242@elte.hu> <20090623085755.9cf75da2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090623085755.9cf75da2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-06-23 08:57:55]:

> I think this is a fix for the problem. Sorry for regression.
> fix for "memcg: fix lru rotation in isolate_pages" patch in 2.6.30-git18.
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> A page isolated is "cursor_page" not "page".
> This causes list corruption finally.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/vmscan.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.30-git18/mm/vmscan.c
> ===================================================================
> --- linux-2.6.30-git18.orig/mm/vmscan.c
> +++ linux-2.6.30-git18/mm/vmscan.c
> @@ -932,7 +932,7 @@ static unsigned long isolate_lru_pages(u
>  				continue;
>  			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
>  				list_move(&cursor_page->lru, dst);
> -				mem_cgroup_del_lru(page);
> +				mem_cgroup_del_lru(cursor_page);
>  				nr_taken++;
>  				scan++;
>  			}

Good catch!

Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
