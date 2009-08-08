Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbZHHAje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbZHHAje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 20:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbZHHAje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 20:39:34 -0400
Received: from mail-yw0-f177.google.com ([209.85.211.177]:55269 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbZHHAjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 20:39:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bLancrpMv0vUtWrtl1RppDhGHnrzqZs0nLC1Vo6ZhZ+dg7Wz8yrQfotdD6edyIUW1a
         mzwCnnMK57iIGyFunoPuGhItvViFX0to9c7B5RstOkEFzDYgB+Lq7tSAwXp0RyPih8/b
         QlI7PCdaMgtIBiBmI6jKTauSFJfR4cNYoGCPQ=
Date: Sat, 8 Aug 2009 02:39:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ftrace: Unify effect of writing to
	trace_options and option/*
Message-ID: <20090808003928.GM4999@nowhere>
References: <4A7A4D7B.7010706@cn.fujitsu.com> <4A7A4DBC.6020403@cn.fujitsu.com> <4A7A6470.60305@cn.fujitsu.com> <4A7C0834.20303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7C0834.20303@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 06:55:48PM +0800, Zhaolei wrote:
> "echo noglobal-clock > trace_options" can be used to change trace
> clock but "echo 0 > options/global-clock" can't.
> 
> We can fix it by using set_tracer_flags() in trace_options_core_write().
> 
> Changelog:
> v1->v2: Simplied switch() by Li Zefan <lizf@cn.fujitsu.com>'s suggest.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>


Queued for .31, thanks!

> ---
>  kernel/trace/trace.c |   12 ++----------
>  1 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 6c5f67f..06a2dfa 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3718,17 +3718,9 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  	if (ret < 0)
>  		return ret;
>  
> -	switch (val) {
> -	case 0:
> -		trace_flags &= ~(1 << index);
> -		break;
> -	case 1:
> -		trace_flags |= 1 << index;
> -		break;
> -
> -	default:
> +	if (val != 0 && val != 1)
>  		return -EINVAL;
> -	}
> +	set_tracer_flags(1 << index, val);
>  
>  	*ppos += cnt;
>  
> -- 
> 1.5.5.3
> 
> 

