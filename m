Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbZC2Q45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbZC2Q45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZC2Q4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:56:46 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48814 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZC2Q4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:56:45 -0400
Date: Sun, 29 Mar 2009 22:26:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 4/8] memcg soft limit priority array queue.
Message-ID: <20090329165620.GB15608@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com> <20090327140653.a12c6b1e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090327140653.a12c6b1e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-27 14:06:53]:

> I'm now search a way to reduce lock contention without complex...
> -Kame
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> +static void __mem_cgroup_requeue(struct mem_cgroup *mem)
> +{
> +	/* enqueue to softlimit queue */
> +	int prio = mem->soft_limit_priority;
> +
> +	spin_lock(&softlimitq.lock);
> +	list_del_init(&mem->soft_limit_anon);
> +	list_add_tail(&mem->soft_limit_anon, &softlimitq.queue[prio][SL_ANON]);
> +	list_del_init(&mem->soft_limit_file,ist[SL_FILE]);

Patch fails to build here, what is ist?

> +	list_add_tail(&mem->soft_limit_file, &softlimitq.queue[prio][SL_FILE]);
> +	spin_unlock(&softlimitq.lock);
> +}
> 

-- 
	Balbir
