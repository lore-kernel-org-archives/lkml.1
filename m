Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZEROZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZEROZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbZEROZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:25:15 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:53522 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbZEROZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OBhugQcVwXQBgSoMBKF7lNZPp2z0qppK9mDWjKUqEZzCpbYYU//xiRhdOB117z8ao9
         65qroy/jf93Qsp+fcM3CEPNnMcYXuQcVg8JQpRzo2TDmVWkKNphGR40/efv4UHFjY25B
         GLRksJoyvDctu7oOjsE7uRtrZHZ9cYXYoRsZc=
Date: Mon, 18 May 2009 16:25:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] ftrace:fix check for return value of
	register_module_notifier
Message-ID: <20090518142507.GE4704@nowhere>
References: <1242545498-7285-1-git-send-email-tom.leiming@gmail.com> <4A10B1B4.5080309@cn.fujitsu.com> <20090518203957.0bc1eff8@linux-lm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518203957.0bc1eff8@linux-lm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 08:39:57PM +0800, Ming Lei wrote:
> From d0d91950165f1d0a05ce8f68b333c6f0724b0007 Mon Sep 17 00:00:00 2001
> From: Ming Lei <tom.leiming@gmail.com>
> Date: Sun, 17 May 2009 15:26:28 +0800
> Subject: [PATCH] ftrace:fix check for return value of register_module_notifier(v2)
> 
> return zero should be correct, so fix it.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Hi,


You are making a confusion between Signed-off-by: and
Reported-by:

Indeed Li Zefan suggested you to expand your patch to fix
another place. And that's what you did in this patch, that's fine.

But Signed-off-by: has a special meaning, please read the
Developer's Certificate of Origin 1.1 in Documentation/SubmittingPatches.

You shoudn't add someone else Signed-off-by if he/she didn't gave it to
you.

Instead, if you implement in a v2 patch a suggestion someone made while
reviewing your v1 patch, you can credit him in the changelog:

v2: change foo, as suggested by li Zefan

And if it's a new patch that addresses a new review, you can
just put a Reported-by: tag.


Your first patch have been applied in tip:/tracing/core topic.
So could you please send a new patch which addresses only
the event_trace_init() callsite?

You can add the

Reported-by: Li Zefan <lizf@cn.fujitsu.com>

and also my

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

in advance.

Thanks Ming!

Frederic.

> Acked-by: Frederic Weisbecker <fweisbec@gmail.com> 
> ---
>  kernel/trace/ftrace.c       |    2 +-
>  kernel/trace/trace_events.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
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
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 0eec0c5..9e91c4a 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1174,7 +1174,7 @@ static __init int event_trace_init(void)
>  	}
>  
>  	ret = register_module_notifier(&trace_module_nb);
> -	if (!ret)
> +	if (ret)
>  		pr_warning("Failed to register trace events module notifier\n");
>  
>  	return 0;
> -- 
> 1.6.0.GIT
> 
> 
> 
> -- 
> Lei Ming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

