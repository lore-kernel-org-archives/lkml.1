Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbZLBQpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbZLBQpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 11:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZLBQpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 11:45:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbZLBQpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 11:45:52 -0500
Message-ID: <4B1699B9.6010106@redhat.com>
Date: Wed, 02 Dec 2009 11:45:45 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Liming Wang <liming.wang@windriver.com>
CC: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: replace %m with %a in sscanf
References: <20091202083120.GA20120@elte.hu> <1259743374-9950-1-git-send-email-liming.wang@windriver.com>
In-Reply-To: <1259743374-9950-1-git-send-email-liming.wang@windriver.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liming Wang wrote:
> Not all glibc support %m and it results in a compile error if
> %m not supported. Replace it with %a and (float *) casts.
> 
> Signed-off-by: Liming Wang<liming.wang@windriver.com>
> Acked-by: Frederic Weisbecker<fweisbec@gmail.com>
> ---
>   tools/perf/util/probe-event.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index e42f3ac..cd7fbda 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -199,8 +199,8 @@ void parse_trace_kprobe_event(const char *str, char **group, char **event,
>   		semantic_error("Too less arguments.");
> 
>   	/* Scan event and group name. */
> -	ret = sscanf(argv[0], "%c:%m[^/ \t]/%m[^ \t]",
> -		&pr, group, event);
> +	ret = sscanf(argv[0], "%c:%a[^/ \t]/%a[^ \t]",
> +		&pr, (float *)(void *)group, (float *)(void *)event);

Hmm, the code itself is OK for me, but I think we need a comment
why we cast (void *) to (float *)...

Thank you,

>   	if (ret != 3)
>   		semantic_error("Failed to parse event name: %s", argv[0]);
>   	pr_debug("Group:%s Event:%s probe:%c\n", *group, *event, pr);
> @@ -211,7 +211,7 @@ void parse_trace_kprobe_event(const char *str, char **group, char **event,
>   	pp->retprobe = (pr == 'r');
> 
>   	/* Scan function name and offset */
> -	ret = sscanf(argv[1], "%m[^+]+%d",&pp->function,&pp->offset);
> +	ret = sscanf(argv[1], "%a[^+]+%d", (float *)(void *)&pp->function,&pp->offset);
>   	if (ret == 1)
>   		pp->offset = 0;
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

