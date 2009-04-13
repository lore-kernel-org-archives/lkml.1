Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbZDMOZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbZDMOZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZDMOZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:25:39 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41351 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZDMOZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xkT9BBdlit9zMW3w9ctmdKWQdUO0MQ/kDpdFRfbomKWtrTPCia/CIYQN7z8RNCeSp1
         Ff2AhWKDfz76Mwcw7i0tfkD8I9UyF+WgZBDM8D24HFuEMoQ6DrQpKFbFKS8HjwygLftM
         mH1lrystsvgd4PqQrLVcZHAOu8ISgcY88ELGs=
Date: Mon, 13 Apr 2009 16:25:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing, boottrace: Move include/trace/boot.h to
	include/linux/boottrace.h
Message-ID: <20090413142531.GC5977@nowhere>
References: <49E2B763.8060706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E2B763.8060706@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 11:54:11AM +0800, Zhaolei wrote:
> Impact: refactor code, no functionality changed
> 
> Files in include/trace/ should be definition of tracepoints, and header
> file for boot trace should put to include/linux/.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---



Until now I had the opinion that it's good to let every tracing headers
to be placed in include/trace/* because they are not useful for anything
else than the tracer itself so that we don't encumber include/linux for
private things.

So that we have both tracepoints/trace_events plus the low-level tracers
headers in include/trace/*

I'm not opposite to this change, but seeing this patch and the recent divide
of kmemtrace headers, I would like to know the opinion of Ingo and Steven
about the strict role of include/trace/*
Is it only for tracepoints-like bits, or oslo intended for every private tracing
purposes?


Thanks.


>  include/{trace/boot.h => linux/boottrace.h} |    0 
>  init/main.c                                 |    2 +-
>  kernel/trace/trace.h                        |    2 +-
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename include/{trace/boot.h => linux/boottrace.h} (100%)
> 
> diff --git a/include/trace/boot.h b/include/linux/boottrace.h
> similarity index 100%
> rename from include/trace/boot.h
> rename to include/linux/boottrace.h
> diff --git a/init/main.c b/init/main.c
> index 694a563..d7d4741 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -66,7 +66,7 @@
>  #include <linux/ftrace.h>
>  #include <linux/async.h>
>  #include <linux/kmemtrace.h>
> -#include <trace/boot.h>
> +#include <linux/boottrace.h>
>  
>  #include <asm/io.h>
>  #include <asm/bugs.h>
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index ce6bdc4..5b654ce 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -8,7 +8,7 @@
>  #include <linux/ring_buffer.h>
>  #include <linux/mmiotrace.h>
>  #include <linux/ftrace.h>
> -#include <trace/boot.h>
> +#include <linux/boottrace.h>
>  #include <linux/kmemtrace.h>
>  #include <trace/power.h>
>  
> -- 
> 1.5.5.3
> 
> 

