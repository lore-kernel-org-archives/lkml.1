Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYIVDO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYIVDO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 23:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYIVDOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 23:14:21 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33398 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYIVDOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 23:14:21 -0400
Date: Mon, 22 Sep 2008 12:13:36 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: =?ISO-2022-JP?B?RnIbJEJxRXFTGyhCaWM=?= Weisbecker 
	<fweisbec@gmail.com>
Subject: Re: [Patch 1/3] Tracing/ftrace: Make nop tracer reset previous entries
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>
In-Reply-To: <48D68E06.50504@gmail.com>
References: <48D68E06.50504@gmail.com>
Message-Id: <20080922121237.13D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


your patch seems corrupted.
please check again your e-mail client settings.


> If nop tracer is selected, some old entries from the previous tracer could still be enqueued. Tracing have to be reset.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff -rup linux-2.6-tip (2)/kernel/trace/trace_nop.c linux-2.6-tip/kernel/trace/trace_nop.c
> --- linux-2.6-tip (2)/kernel/trace/trace_nop.c	2008-09-19 18:01:26.000000000 +0200
> +++ linux-2.6-tip/kernel/trace/trace_nop.c	2008-09-21 00:44:47.000000000 +0200
> @@ -25,8 +25,12 @@ static void stop_nop_trace(struct trace_
>  }
> 
>  
> 
>  static void nop_trace_init(struct trace_array *tr)
> 
> -{
> 
> -	ctx_trace = tr;
> 
> +{
> +	int cpu;
> 
> +	ctx_trace = tr;
> +
> +	for_each_online_cpu(cpu)
> 
> +		tracing_reset(tr->data[cpu]);
> 
>  
> 
>  	if (tr->ctrl)
> 
>  		start_nop_trace(tr);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



