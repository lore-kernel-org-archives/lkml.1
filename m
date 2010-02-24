Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0BXIEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:04:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61202 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab0BXIEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:04:08 -0500
Message-ID: <4B84DD84.60302@cn.fujitsu.com>
Date: Wed, 24 Feb 2010 16:04:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Wenji Huang <wenji.huang@oracle.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org
Subject: Re: [PATCH -tip 5/5] tracing: simplify memory recycle of trace_define_field
References: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com> <1266997226-6833-2-git-send-email-wenji.huang@oracle.com> <1266997226-6833-3-git-send-email-wenji.huang@oracle.com> <1266997226-6833-4-git-send-email-wenji.huang@oracle.com> <1266997226-6833-5-git-send-email-wenji.huang@oracle.com>
In-Reply-To: <1266997226-6833-5-git-send-email-wenji.huang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wenji Huang wrote:
> Discard freeing field->type since it's not necessary and may be hazard.
> 

It's redundant, but it's safe, because if we run into this failure path,
field->type is always NULL.

> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
>  kernel/trace/trace_events.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index c2a3077..3f972ad 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -60,10 +60,8 @@ int trace_define_field(struct ftrace_event_call *call, const char *type,
>  	return 0;
>  
>  err:
> -	if (field) {
> +	if (field)
>  		kfree(field->name);
> -		kfree(field->type);
> -	}
>  	kfree(field);
>  
>  	return -ENOMEM;
