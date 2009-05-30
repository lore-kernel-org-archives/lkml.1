Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbZE3Gky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbZE3Gky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 02:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbZE3Gkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 02:40:47 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45418 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZE3Gkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 02:40:46 -0400
Date: Sat, 30 May 2009 14:40:41 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] reuse unused swap entry if necessary
Message-ID: <20090530064041.GF24073@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090528135455.0c83bedc.kamezawa.hiroyu@jp.fujitsu.com> <20090528142047.3069543b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090528142047.3069543b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-05-28 14:20:47]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, we can know a swap entry is just used as SwapCache via swap_map,
> without looking up swap cache.
> 
> Then, we have a chance to reuse swap-cache-only swap entries in
> get_swap_pages().
> 
> This patch tries to free swap-cache-only swap entries if swap is
> not enough.
> Note: We hit following path when swap_cluster code cannot find
> a free cluster. Then, vm_swap_full() is not only condition to allow
> the kernel to reclaim unused swap.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Looks good, except the now changed behaviour where swap will get
distributed between clusters. Having the vm_swap_full() is a good
optimization for swap allocation performance though. I'd say lets wait
to see the results of testing


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Balbir
