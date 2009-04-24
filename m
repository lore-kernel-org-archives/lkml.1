Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbZDXLnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbZDXLnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 07:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZDXLnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:43:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57786 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZDXLnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:43:08 -0400
Message-ID: <49F1A59B.3080206@cn.fujitsu.com>
Date: Fri, 24 Apr 2009 19:42:19 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for worklet
 lifecycle tracing
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu>
In-Reply-To: <20090417134557.GA23493@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> ...
> Basically, i'd suggest the following complete set of events instead:
> 
>  TRACE_EVENT(workqueue_create
>  TRACE_EVENT(workqueue_flush              /* NEW */
>  TRACE_EVENT(workqueue_destroy
> 
>  TRACE_EVENT(worklet_enqueue              /* NEW */
>  TRACE_EVENT(worklet_enqueue_delayed      /* NEW */
> 
>  TRACE_EVENT(worklet_execute              /* instead of workqueue_execution */
>  TRACE_EVENT(worklet_complete             /* NEW */
> 
>  TRACE_EVENT(worklet_cancel               /* NEW */
> 
> This allows the understanding of the life cycle of a workqueue and 
> of worklets that enter that workqueue. Note the distinction between 
> workqueue and worklet (work) - that is essential.
> 
> The parameters of the events are obvious, with one detail: i'd 
> suggest a 'cpu' parameter to the enqueue events, to allow the 
> mapping of the _on(..cpu) variants too.
> 
> I would not bother with schedule_on_each_cpu() instrumentation - 
> it's rarely used.
> 
> 	Ingo
> 
Hello, Ingo

These patchs add tracepoints for per-worklet tracing.
Now we have enough tracepoints to start makeing trace_workqueue.c support
worklet time mesurement.

Thanks
Zhaolei

