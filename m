Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbZDSGOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbZDSGOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 02:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbZDSGOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 02:14:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54389 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbZDSGOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 02:14:46 -0400
Message-ID: <49EAC188.1040409@cn.fujitsu.com>
Date: Sun, 19 Apr 2009 14:15:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2 v3] tracing/events: provide string with undefined
 size support
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <1240117295-6873-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1240117295-6873-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -417,18 +495,22 @@ static struct ftrace_event_call event_##call;				\
>  									\
>  static void ftrace_raw_event_##call(proto)				\
>  {									\
> +	struct ftrace_str_offsets_##call __maybe_unused __str_offsets;  \
>  	struct ftrace_event_call *call = &event_##call;			\
>  	struct ring_buffer_event *event;				\
>  	struct ftrace_raw_##call *entry;				\
>  	unsigned long irq_flags;					\
> +	int __str_size = 0;						\
>  	int pc;								\
>  									\
>  	local_save_flags(irq_flags);					\
>  	pc = preempt_count();						\
>  									\
> +	tstruct;							\
> +									\
>  	event = trace_current_buffer_lock_reserve(event_##call.id,	\
> -				  sizeof(struct ftrace_raw_##call),	\
> -				  irq_flags, pc);			\
> +				 sizeof(struct ftrace_raw_##call) + __str_size,\

sizeof(*entry) will make it much shorter. ;)

> +				 irq_flags, pc);			\
>  	if (!event)							\
>  		return;							\
>  	entry	= ring_buffer_event_data(event);			\

