Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbZH0Mql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbZH0Mql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZH0Mql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:46:41 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36814 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZH0Mqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:46:40 -0400
Date: Thu, 27 Aug 2009 08:46:28 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Miller <davem@davemloft.net>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] drop_monitor: fix trace_napi_poll_hit()
Message-ID: <20090827124628.GA4762@hmsreliant.think-freely.org>
References: <4A966288.8020402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A966288.8020402@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.9 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 06:40:08PM +0800, Xiao Guangrong wrote:
> The net_dev of backlog napi is NULL, like below:
> 
> __get_cpu_var(softnet_data).backlog.dev == NULL
> 
> So, we should check it in napi tracepoint's probe function
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  net/core/drop_monitor.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index 9d66fa9..d311202 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -182,7 +182,8 @@ static void trace_napi_poll_hit(struct napi_struct *napi)
>  	/*
>  	 * Ratelimit our check time to dm_hw_check_delta jiffies
>  	 */
> -	if (!time_after(jiffies, napi->dev->last_rx + dm_hw_check_delta))
> +	if (!napi->dev ||
> +	    !time_after(jiffies, napi->dev->last_rx + dm_hw_check_delta))
>  		return;
>  
>  	rcu_read_lock();
> -- 
> 1.6.1.2
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

Thanks!
Neil

