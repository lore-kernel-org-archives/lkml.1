Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbYJQLCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbYJQLCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYJQLCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:02:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34291 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbYJQLCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:02:01 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: fix the wrong mask_len
Cc: kosaki.motohiro@jp.fujitsu.com, miaox@cn.fujitsu.com,
       Ingo Molnar <mingo@elte.hu>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1224241099.28131.88.camel@twins>
References: <1224239584.28131.85.camel@twins> <1224241099.28131.88.camel@twins>
Message-Id: <20081017200120.7D56.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 17 Oct 2008 20:01:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---
> Subject: sched: fix the wrong mask_len
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Oct 17 12:55:57 CEST 2008
> 
> If the NR_CPUS isn't a multiple of 32, we get a truncated string of sched
> domains by catting /proc/schedstat. This is caused by the wrong mask_len.
> 
> Reported-by: Miao Xie <miaox@cn.fujitsu.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched_stats.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/sched_stats.h
> ===================================================================
> --- linux-2.6.orig/kernel/sched_stats.h
> +++ linux-2.6/kernel/sched_stats.h
> @@ -9,7 +9,7 @@
>  static int show_schedstat(struct seq_file *seq, void *v)
>  {
>  	int cpu;
> -	int mask_len = NR_CPUS/32 * 9;
> +	int mask_len = DIV_ROUND_UP(NR_CPUS, 32) * 9;
>  	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
>  
>  	if (mask_str == NULL)

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



