Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbZHFExq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbZHFExq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 00:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZHFExp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 00:53:45 -0400
Received: from mail-yw0-f183.google.com ([209.85.211.183]:34589 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbZHFExp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 00:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sjc+zo2L8fWsaA06ASJRkB/GMu0i6ZwCi9PkMx/fhQQFfG65F8R+LcZ2jbyN+edYz2
         B/6c/tGb9UJCrZs0p3tMo0+Spj+BmodIhnRZQqgYoWwm8VufkAtGwDGoxqQ6NreJIPF+
         DkgqzJAxKQyL3FS/jSR6DKw9y0/R1bqZQdAxo=
Date: Thu, 6 Aug 2009 06:53:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ftrace: Unify effect of writing to trace_options
	and option/*
Message-ID: <20090806045339.GD24609@nowhere>
References: <4A7A4D7B.7010706@cn.fujitsu.com> <4A7A4DBC.6020403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7A4DBC.6020403@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 11:27:56AM +0800, Zhaolei wrote:
> "echo noglobal-clock > trace_options" can be used to change trace
> clock but "echo 0 > options/global-clock" can't.
> 
> We can fix it by using set_tracer_flags() in trace_options_core_write().
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  kernel/trace/trace.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 464b7bb..2fa2bac 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3893,12 +3893,11 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  
>  	switch (val) {
>  	case 0:
> -		trace_flags &= ~(1 << index);
> +		set_tracer_flags(1 << index, 0);
>  		break;
>  	case 1:
> -		trace_flags |= 1 << index;
> +		set_tracer_flags(1 << index, 1);
>  		break;
> -
>  	default:
>  		return -EINVAL;
>  	}


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

It applies on .31 BTW.

That makes me think: shouldn't it be better to keep
tracing/options for global options and options/* for
local tracer options? That breaks the ABI but...

