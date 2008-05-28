Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbYE1JIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbYE1JIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 05:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYE1JIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 05:08:38 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51123 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYE1JIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 05:08:37 -0400
Message-Id: <483D20F2.1010307@mxp.nes.nec.co.jp>
Date: Wed, 28 May 2008 18:08:02 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       MinChan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm 04/16] free swap space on swap-in/activation
References: <20080523195506.084894989@redhat.com> <20080523195535.063198671@redhat.com>
In-Reply-To: <20080523195535.063198671@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1203,6 +1206,8 @@ static void shrink_active_list(unsigned 
>  			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
>  			pgmoved = 0;
>  			spin_unlock_irq(&zone->lru_lock);
> +			if (vm_swap_full())
> +				pagevec_swap_free(&pvec);
>  			__pagevec_release(&pvec);
>  			spin_lock_irq(&zone->lru_lock);
>  		}
> @@ -1212,6 +1217,8 @@ static void shrink_active_list(unsigned 
>  	__count_zone_vm_events(PGREFILL, zone, pgscanned);
>  	__count_vm_events(PGDEACTIVATE, pgdeactivate);
>  	spin_unlock_irq(&zone->lru_lock);
> +	if (vm_swap_full())
> +		pagevec_swap_free(&pvec);
>  
>  	pagevec_release(&pvec);
>  }

I'm sorry if I misunderstand your patches, but is this part needed
after
  [PATCH -mm 07/16] second chance replacement for anonymous pages
is applied?
After the patch, if shrink_active_list() is called about
anon pages(that is, with file=0), those pages should go to inactive list,
so they should not be removed from swap cache, should they?


Thanks,
Daisuke Nishimura.

