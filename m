Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab0BEOru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:47:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44812 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab0BEOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:47:48 -0500
X-Authority-Analysis: v=1.0 c=1 a=I-JJUczq-h8A:10 a=7U3hwN5JcxgA:10 a=5fxdJMtIGkPxkjkJ0-8A:9 a=Rd61lrKydlGsmJiolQEUZPxMDi8A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 02/11] tracing: Introduce TRACE_EVENT_INJECT
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <1265188475-23509-3-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
	 <1265188475-23509-3-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 05 Feb 2010 09:47:46 -0500
Message-ID: <1265381266.24386.32.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 10:14 +0100, Frederic Weisbecker wrote:
> TRACE_EVENT_INJECT macro is the same as TRACE_EVENT but takes one

>  #undef DEFINE_EVENT
>  #define DEFINE_EVENT(template, call, proto, args)		\
>  static void ftrace_profile_##call(proto)			\
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 189b09b..5c75cc7 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -142,6 +142,9 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
>  				break;
>  			}
>  			call->enabled = 1;
> +
> +			if (call->inject)
> +				call->inject();
>  		}
>  		break;
>  	}

With the proposal I'm suggesting:

register_event_command(event, NULL, NULL, inject_me, inject_me, data);

The above would do basically what this patch does. When ever the event
is enabled or disabled the inject_me function will be called.

Would this work?

-- Steve


