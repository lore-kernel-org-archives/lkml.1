Return-Path: <linux-kernel-owner+w=401wt.eu-S933577AbZJHVOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577AbZJHVOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbZJHVOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:14:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759537AbZJHVOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:14:53 -0400
Message-ID: <4ACE56EE.8060000@redhat.com>
Date: Thu, 08 Oct 2009 17:17:34 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v3 6/7] perf: Add perf probe subcommand
 for	kprobe-event setup helper
References: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com> <20091007222822.1684.3251.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091007222822.1684.3251.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Add perf probe subcommand for kprobe-event setup helper to perf command.
> This allows user to define kprobe events by C expressions (C line numbers,
> C function names, and C local variables).
>
> Usage
> -----
>   perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]
>
>      -k, --vmlinux<file>   vmlinux/module pathname
>      -P, --probe<p|r:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]>
>                            probe point definition, where
> 		p:	kprobe probe
> 		r:	kretprobe probe
> 		GRP:	Group name (optional)
> 		NAME:	Event name
> 		FUNC:	Function name
> 		OFFS:	Offset from function entry (in byte)
> 		SRC:	Source code path
> 		LINE:	Line number
> 		ARG:	Probe argument (local variable name or
> 			kprobe-tracer argument format is supported.)

Oops, I found it caused compilation error on gcc < 4.4 as below:

     CC builtin-trace.o
     CC builtin-probe.o
cc1: warnings being treated as errors
builtin-probe.c: In function 'parse_probepoint':
builtin-probe.c:109: error: implicit declaration of function 'strndup'
builtin-probe.c:109: error: incompatible implicit declaration of built-in function 'strndup'

Since I forgot to add _GNU_SOURCE...


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

