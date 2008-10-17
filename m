Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYJQK0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYJQK0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYJQKZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:25:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33216 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYJQKZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:25:57 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: miaox@cn.fujitsu.com
Subject: Re: [PATCH] sched: fix the wrong mask_len
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48F8664A.2000205@cn.fujitsu.com>
References: <48F8664A.2000205@cn.fujitsu.com>
Message-Id: <20081017192505.E242.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 17 Oct 2008 19:25:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the NR_CPUS isn't a multiple of 32, we get a truncated string of sched
> domains by catting /proc/schedstat. This is caused by the wrong mask_len.
> 
> This patch fix it.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> 
> ---
>  kernel/sched_stats.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
> index 8385d43..81365b3 100644
> --- a/kernel/sched_stats.h
> +++ b/kernel/sched_stats.h
> @@ -9,7 +9,7 @@
>  static int show_schedstat(struct seq_file *seq, void *v)
>  {
>  	int cpu;
> -	int mask_len = NR_CPUS/32 * 9;
> +	int mask_len = (NR_CPUS/32 + 1) * 9;
>  	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
>  

DIV_ROUND_UP() is better?



