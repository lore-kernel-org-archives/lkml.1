Return-Path: <linux-kernel-owner+w=401wt.eu-S934493AbZKYMlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493AbZKYMlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758746AbZKYMlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:41:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758735AbZKYMlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:41:20 -0500
Message-ID: <4B0D267B.9060107@redhat.com>
Date: Wed, 25 Nov 2009 07:43:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] trace_kprobes: always show group name
References: <4B0CEBAF.6000104@cn.fujitsu.com>
In-Reply-To: <4B0CEBAF.6000104@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> 
> Sometimes the group name is not "kprobes",
> It'll be better if we can read it from tracing/kprobe_events.
> 
> # echo 'r:laijs/vfs_read vfs_read %ax' > kprobe_events
> # cat kprobe_events
> r:laijs/vfs_read vfs_read %ax=%ax


Yep, that looks very nice :-)

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 79ce6a2..9e42f2a 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -758,7 +758,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
>  	char buf[MAX_ARGSTR_LEN + 1];
>  
>  	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
> -	seq_printf(m, ":%s", tp->call.name);
> +	seq_printf(m, ":%s/%s", tp->call.system, tp->call.name);
>  
>  	if (tp->symbol)
>  		seq_printf(m, " %s+%u", probe_symbol(tp), tp->rp.kp.offset);
> 
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

