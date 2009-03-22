Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZC0M7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZC0M7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZC0M7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:59:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33941 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbZC0M7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:59:12 -0400
Date: Sun, 22 Mar 2009 10:35:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces - v2
Message-ID: <20090322093543.GA1320@ucw.cz>
References: <20090324152028.754123712@K.Prasad> <20090324152811.GL17918@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324152811.GL17918@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch adds an ftrace plugin to detect and profile memory access over
> kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> addresses.


> +static void ksym_trace_print_header(struct seq_file *m)
> +{
> +
> +	seq_puts(m,
> +		 "#       TASK-PID      CPU#      Symbol         Type    "
> +		 "Function         \n");
> +	seq_puts(m,
> +		 "#          |           |          |              |         "
> +		 "|            \n");
> +}
...
> +	trace_assign_type(field, entry);
> +
> +	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->p_name,
> +				entry->pid, iter->cpu, field->ksym_name);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	switch (field->ksym_hbp->info.type) {
> +	case HW_BREAKPOINT_WRITE:
> +		ret = trace_seq_printf(s, " W  ");
> +		break;
> +	case HW_BREAKPOINT_RW:
> +		ret = trace_seq_printf(s, " RW ");
> +		break;
> +	default:
> +		return TRACE_TYPE_PARTIAL_LINE;
> +	}
> +#ifdef CONFIG_PROFILE_KSYM_TRACER
> +static int ksym_tracer_stat_headers(struct seq_file *m)
> +{
> +	seq_printf(m, "   Access type    ");
> +	seq_printf(m, "            Symbol                     Counter     \n");
> +	return 0;
> +}
...

> +	switch (access_type) {
> +	case HW_BREAKPOINT_WRITE:
> +		seq_printf(m, "     W     ");
> +		break;
> +	case HW_BREAKPOINT_RW:
> +		seq_printf(m, "     RW    ");
> +		break;
> +	default:
> +		seq_printf(m, "     NA    ");
> +	}
> +
> +	if (lookup_symbol_name(entry->ksym_addr, fn_name) >= 0)
> +		seq_printf(m, "               %s                 ", fn_name);
> +	else
> +		seq_printf(m, "               <NA>                ");
> +
> +	seq_printf(m, "%15lu\n", entry->counter);
> +	return 0;
> +}

Quite as lot of ascii-art here. Is userland expected to parse it? If
so, how? (docs would be nice) What if you'll want to make fields  wider one day?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
