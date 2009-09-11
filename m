Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbZIKOH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbZIKOH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZIKOH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:07:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54813 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZIKOH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:07:58 -0400
Subject: Re: [PATCH tracing/kprobes 5/7] tracing/kprobes: Add argument name
 support
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
In-Reply-To: <20090910235337.22412.77383.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20090910235337.22412.77383.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 11 Sep 2009 10:07:59 -0400
Message-Id: <1252678079.18996.665.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 19:53 -0400, Masami Hiramatsu wrote:

> @@ -870,9 +892,13 @@ print_kprobe_event(struct trace_iterator *iter, int flags)
>  {
>  	struct kprobe_trace_entry *field;
>  	struct trace_seq *s = &iter->seq;
> +	struct trace_event *event;
> +	struct trace_probe *tp;
>  	int i;
>  
>  	field = (struct kprobe_trace_entry *)iter->ent;
> +	event = ftrace_find_event(field->ent.type);
> +	tp = container_of(event, struct trace_probe, event);

Can this function be called the data is in the ring buffer, but the
probe has been unregistered? If so, the result of ftrace_find_event be
NULL?

-- Steve

>  
>  	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
>  		goto partial;
> @@ -881,7 +907,8 @@ print_kprobe_event(struct trace_iterator *iter, int flags)
>  		goto partial;
>  
>  	for (i = 0; i < field->nargs; i++)
> -		if (!trace_seq_printf(s, " 0x%lx", field->args[i]))
> +		if (!trace_seq_printf(s, " %s=%lx",
> +				      tp->args[i].name, field->args[i]))
>  			goto partial;
>  
>  	if (!trace_seq_puts(s, "\n"))


