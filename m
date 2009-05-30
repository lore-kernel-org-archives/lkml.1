Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZE3HUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZE3HUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 03:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbZE3HUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 03:20:34 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49802 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZE3HUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 03:20:33 -0400
Date: Sat, 30 May 2009 15:20:30 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] memcg: fix swap accounting
Message-ID: <20090530072030.GG24073@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090528135455.0c83bedc.kamezawa.hiroyu@jp.fujitsu.com> <20090528142156.efa97a37.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090528142156.efa97a37.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-05-28 14:21:56]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> This patch fixes mis-accounting of swap usage in memcg.
> 
> In current implementation, memcg's swap account is uncharged only when
> swap is completely freed. But there are several cases where swap
> cannot be freed cleanly. For handling that, this patch changes that
> memcg uncharges swap account when swap has no references other than cache.
> 
> By this, memcg's swap entry accounting can be fully synchronous with
> the application's behavior.
> This patch also changes memcg's hooks for swap-out.
>

Looks good, so for count == 0, we directly free the and uncharge, for
the others we use retry_to_use_swap(). cool!


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
 
-- 
	Balbir
