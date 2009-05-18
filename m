Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZERAxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZERAxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 20:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbZERAxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 20:53:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55506 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbZERAxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 20:53:08 -0400
Message-ID: <4A10B1B4.5080309@cn.fujitsu.com>
Date: Mon, 18 May 2009 08:54:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: tom.leiming@gmail.com
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] ftrace:fix check for return value of register_module_notifier
References: <1242545498-7285-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1242545498-7285-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> return zero should be correct, so fix it.
> 

Nice catch.

We have those bogus warnings:

 $ dmesg | grep Failed
 Failed to register trace ftrace module notifier
 Failed to register trace events module notifier

Could you fix the same bug in event_trace_init()?

> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  kernel/trace/ftrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5b606f4..140699a 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2826,7 +2826,7 @@ void __init ftrace_init(void)
>  				  __stop_mcount_loc);
>  
>  	ret = register_module_notifier(&ftrace_module_nb);
> -	if (!ret)
> +	if (ret)
>  		pr_warning("Failed to register trace ftrace module notifier\n");
>  
>  	return;
