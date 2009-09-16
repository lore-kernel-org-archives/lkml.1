Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZIPDRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZIPDRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZIPDRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:17:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36805 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZIPDRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:17:30 -0400
Subject: Re: [PATCH tracing/kprobes 3/6] ftrace: Fix
 trace_remove_event_call() to lock trace_event_mutex
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <20090914204912.18779.68734.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20090914204912.18779.68734.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 15 Sep 2009 23:17:30 -0400
Message-Id: <1253071051.20020.177.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 16:49 -0400, Masami Hiramatsu wrote:

> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 38e82a5..a3d6bad 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1055,6 +1055,9 @@ static void remove_subsystem_dir(const char *name)
>  	}
>  }
>  
> +/*
> + * Must be called under locking both of event_mutex and trace_event_mutex.
> + */
>  static void __trace_remove_event_call(struct ftrace_event_call *call)
>  {
>  	ftrace_event_enable_disable(call, 0);
> @@ -1071,7 +1074,9 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
>  void trace_remove_event_call(struct ftrace_event_call *call)

Is this from a previous patch set, because I can't find this in either
my tree or tip/master.

-- Steve

>  {
>  	mutex_lock(&event_mutex);
> +	down_write(&trace_event_mutex);
>  	__trace_remove_event_call(call);
> +	up_write(&trace_event_mutex);
>  	mutex_unlock(&event_mutex);
>  }
>  
> 
> 

