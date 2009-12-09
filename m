Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbZLIPE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbZLIPE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZLIPE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:04:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbZLIPE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:04:56 -0500
Message-ID: <4B1FBC9E.5040903@redhat.com>
Date: Wed, 09 Dec 2009 10:05:02 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] trace_kprobe: shows signs of fields in format files
References: <4B1F4E80.4050507@cn.fujitsu.com>
In-Reply-To: <4B1F4E80.4050507@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
>
> format files of trace_kprobe don't shows signs, it is
> different from all other format files, incorrect API to user.
>
> Signed-off-by: Lai Jiangshan<laijs@cn.fujitsu.com>

Thanks Lai!
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index e3c80e9..3ef66d4 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1163,10 +1163,11 @@ static int __probe_event_show_format(struct trace_seq *s,
>   #undef SHOW_FIELD
>   #define SHOW_FIELD(type, item, name)					\
>   	do {								\
> -		ret = trace_seq_printf(s, "\tfield: " #type " %s;\t"	\
> -				"offset:%u;\tsize:%u;\n", name,		\
> +		ret = trace_seq_printf(s, "\tfield:" #type " %s;\t"	\
> +				"offset:%u;\tsize:%u;\tsigned:%d;\n", name,\
>   				(unsigned int)offsetof(typeof(field), item),\
> -				(unsigned int)sizeof(type));		\
> +				(unsigned int)sizeof(type),		\
> +				is_signed_type(type));			\
>   		if (!ret)						\
>   			return 0;					\
>   	} while (0)
>
>
>

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

