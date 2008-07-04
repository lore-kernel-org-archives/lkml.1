Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYGDKxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYGDKxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 06:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYGDKxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 06:53:32 -0400
Received: from sacred.ru ([62.205.161.221]:41662 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbYGDKxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 06:53:31 -0400
Message-ID: <486DFCCF.3070500@openvz.org>
Date: Fri, 04 Jul 2008 14:34:55 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [PATCH 1/2] res_counter : check limit change
References: <20080704181204.44070413.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080704181204.44070413.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 04 Jul 2008 14:37:19 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Add an interface to set limit. This is necessary to memory resource controller
> because it shrinks usage at set limit.
> 
> (*) Other controller may not need this interface to shrink usage because
>     shrinking is not necessary or impossible in it.
> 
> Changelog:
>   - fixed white space bug.
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Acked-by: Pavel Emelyanov <xemul@openvz.org>

> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> 
>  include/linux/res_counter.h |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> Index: test-2.6.26-rc8-mm1/include/linux/res_counter.h
> ===================================================================
> --- test-2.6.26-rc8-mm1.orig/include/linux/res_counter.h
> +++ test-2.6.26-rc8-mm1/include/linux/res_counter.h
> @@ -176,4 +176,19 @@ static inline bool res_counter_can_add(s
>  	return ret;
>  }
>  
> +static inline int res_counter_set_limit(struct res_counter *cnt,
> +	unsigned long long limit)
> +{
> +	unsigned long flags;
> +	int ret = -EBUSY;
> +
> +	spin_lock_irqsave(&cnt->lock, flags);
> +	if (cnt->usage < limit) {
> +		cnt->limit = limit;
> +		ret = 0;
> +	}
> +	spin_unlock_irqrestore(&cnt->lock, flags);
> +	return ret;
> +}
> +
>  #endif
> 
> 

