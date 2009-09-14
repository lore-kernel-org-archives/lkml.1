Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZINR2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZINR2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZINR2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:28:44 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35019 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbZINR2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:28:43 -0400
Date: Mon, 14 Sep 2009 22:58:35 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/5] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf counters
Message-ID: <20090914172835.GB29531@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252571367-25876-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 10:29:25AM +0200, Frederic Weisbecker wrote:
> This patch rebase the implementation of the breakpoints API on top of
> perf counters instances.
> 
> The core breakpoint API has changed a bit:
> 
> - register_kernel_hw_breakpoint() now takes a cpu as a parameter. For
>   now it doesn't support all cpu wide breakpoints but this may be
>   implemented soon.
> 
> - unregister_kernel_hw_breakpoint() and unregister_user_hw_breakpoint()
>   have been unified in a single unregister_hw_breakpoint()
> 
> Each breakpoints now match a perf counter which now handles the
> register scheduling, thread/cpu attachment, etc..
> 
[edited]
> 
> -/*
> - * Load the debug registers during startup of a CPU.
> - */
> -void load_debug_registers(void)

It does not appear that perf handles CPUs that come up new (if else,
blame my understanding of find_get_context():-)) and hence post breakpoint
integration, the new CPUs wouldn't contain any breakpoint values (meant
for all CPUs). As mentioned in my previous mail, this could be
non-trivial lapse in debugging scenarios and even for users like
ksym_tracer in ftrace. Your patch would want to retain the
functionality of load_debug_registers().

Thanks,
K.Prasad

