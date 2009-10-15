Return-Path: <linux-kernel-owner+w=401wt.eu-S1762127AbZJOCDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762127AbZJOCDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 22:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760893AbZJOCDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 22:03:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63150 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760702AbZJOCDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 22:03:01 -0400
Message-ID: <4AD68269.50701@cn.fujitsu.com>
Date: Thu, 15 Oct 2009 10:01:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] tracing: Fix misuse of strncpy to copy boot params
References: <1255552732-5096-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1255552732-5096-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 4506826..621d81e 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -131,7 +131,7 @@ static char *default_bootup_tracer;
>  
>  static int __init set_ftrace(char *str)
>  {
> -	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
> +	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);

Actually using strncpy() here is fine.

See how the str buf is used:

int register_tracer(struct tracer *type)
{
	...
	if (strncmp(default_bootup_tracer, type->name, MAX_TRACER_SIZE))
	...
}

>  	default_bootup_tracer = bootup_tracer_buf;
>  	/* We are using ftrace early, expand it */
>  	ring_buffer_expanded = 1;
