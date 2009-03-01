Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbZCAVOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbZCAVOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 16:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbZCAVOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 16:14:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58025 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZCAVOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 16:14:33 -0500
Date: Sun, 1 Mar 2009 16:14:29 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Roel Kluin <roel.kluin@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ftrace: '< 0' test on unsigned
In-Reply-To: <49AAF64E.9070205@gmail.com>
Message-ID: <alpine.DEB.2.00.0903011613000.4771@gandalf.stny.rr.com>
References: <49AAF64E.9070205@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 1 Mar 2009, Roel Kluin wrote:

> or should this be fixed, with
> 
>         if (!cnt || cnt > DEFINE)
> 
> if so, what should DEFINE be?

Hi Roel,

Thanks, but I already put in the fix for this. Since Andrew pointed out
that cnt was unsigned in my "cut and paste" from this function. I went 
back and fixed it. There should be no DEFINE. cnt can never be less than 
zero, so simply checking for (!cnt) is sufficient.

-- Steve


> 
> This patch wasn't tested in any way.
> ------------------------------>8-------------8<---------------------------------
> cnt is unsigned, so the '< 0' test won't work.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index fdf913d..6dab415 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1129,7 +1129,7 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
>  	size_t read = 0;
>  	ssize_t ret;
>  
> -	if (!cnt || cnt < 0)
> +	if (!cnt || (ssize_t)cnt < 0)
>  		return 0;
>  
>  	mutex_lock(&ftrace_regex_lock);
> 
> 
