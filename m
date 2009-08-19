Return-Path: <linux-kernel-owner+w=401wt.eu-S1751090AbZHSBds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbZHSBds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbZHSBds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:33:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51801 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZHSBdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:33:47 -0400
Message-ID: <4A8B5624.9040607@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 09:32:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Josh Stone <jistone@redhat.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] tracing: Create generic syscall TRACE_EVENTs
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250634359-31642-1-git-send-email-jistone@redhat.com>
In-Reply-To: <1250634359-31642-1-git-send-email-jistone@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Stone wrote:
> This converts the syscall_enter/exit tracepoints into TRACE_EVENTs, so
> you can have generic ftrace events that capture all system calls with
> arguments and return values.
> 
> The existing event_syscall_enter/exit trace_event structs are renamed to
> event_sys_enter/exit, so they don't conflict with the names generated
> automatically by ftrace.
> 

It would be much better to see a sample output of these TRACE_EVENTs,

...

> +TRACE_EVENT_WITH_CALLBACK(syscall_enter,
> +
> +	TP_PROTO(struct pt_regs *regs, long id),
> +
> +	TP_ARGS(regs, id),
> +
> +	TP_STRUCT__entry(
> +		__field(	long,	id		)
> +		__array(	long,	args,	6	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->id	= id;
> +		syscall_get_arguments(current, regs, 0, 6, __entry->args);
> +	),
> +
> +	TP_printk("NR %ld (%ld, %ld, %ld, %ld, %ld, %ld)",
> +		  __entry->id,
> +		  __entry->args[0], __entry->args[1], __entry->args[2],
> +		  __entry->args[3], __entry->args[4], __entry->args[5]),
> +

so we'll see the what's the output if a syscall has less than 6 args.

And I guess it should be "(%lx, %lx, ..., %lx)"? Otherwise I think we'll
see some negative values.

> +	syscall_regfunc, syscall_unregfunc
> +);


