Return-Path: <linux-kernel-owner+w=401wt.eu-S932609Ab0AFSkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab0AFSkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932271Ab0AFSkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:40:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46874 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab0AFSkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:40:14 -0500
X-Authority-Analysis: v=1.0 c=1 a=mahBh0N2zCAA:10 a=7U3hwN5JcxgA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=ARn-LFdWU5p5GJSKDg0A:9 a=g65HEgVbpi3XwqBkGOnP9APKujcA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH -tip 1/8] tracing/kprobe: Update example output in
 documentation
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
In-Reply-To: <20100105224641.19431.34967.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20100105224641.19431.34967.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 06 Jan 2010 13:40:11 -0500
Message-ID: <1262803211.28171.3075.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 17:46 -0500, Masami Hiramatsu wrote:
> Update example output in documentation accroding to current
> implementation.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> 
>  Documentation/trace/kprobetrace.txt |   33 +++++++++++++++++----------------
>  1 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
> index 47aabee..c3eff6f 100644
> --- a/Documentation/trace/kprobetrace.txt
> +++ b/Documentation/trace/kprobetrace.txt
> @@ -97,23 +97,24 @@ recording return value as "myretprobe" event.
>  
>    cat /sys/kernel/debug/tracing/events/kprobes/myprobe/format
>  name: myprobe
> -ID: 75
> +ID: 780
>  format:
> -	field:unsigned short common_type;	offset:0;	size:2;
> -	field:unsigned char common_flags;	offset:2;	size:1;
> -	field:unsigned char common_preempt_count;	offset:3;	size:1;
> -	field:int common_pid;	offset:4;	size:4;
> -	field:int common_tgid;	offset:8;	size:4;
> -
> -	field: unsigned long ip;	offset:16;tsize:8;
> -	field: int nargs;	offset:24;tsize:4;
> -	field: unsigned long dfd;	offset:32;tsize:8;
> -	field: unsigned long filename;	offset:40;tsize:8;
> -	field: unsigned long flags;	offset:48;tsize:8;
> -	field: unsigned long mode;	offset:56;tsize:8;
> -
> -print fmt: "(%lx) dfd=%lx filename=%lx flags=%lx mode=%lx", REC->ip, REC->dfd, REC->filename, REC->flags, REC->mode
> -
> +        field:unsigned short common_type;       offset:0;       size:2; signed:0;
> +        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
> +        field:unsigned char common_preempt_count;       offset:3; size:1;signed:0;
> +        field:int common_pid;   offset:4;       size:4; signed:1;
> +        field:int common_lock_depth;    offset:8;       size:4; signed:1;
> +
> +        field:unsigned long __probe_ip; offset:12;      size:4; signed:0;
> +        field:int __probe_nargs;        offset:16;      size:4; signed:1;
> +        field:unsigned long dfd;        offset:20;      size:4; signed:0;
> +        field:unsigned long filename;   offset:24;      size:4; signed:0;
> +        field:unsigned long flags;      offset:28;      size:4; signed:0;
> +        field:unsigned long mode;       offset:32;      size:4; signed:0;
> +
> +
> +print fmt: "(%lx) dfd=%lx filename=%lx flags=%lx mode=%lx", REC->__probe_ip,
> +REC->dfd, REC->filename, REC->flags, REC->mode
>  
>   You can see that the event has 4 arguments as in the expressions you specified.
>  
> 
> 


