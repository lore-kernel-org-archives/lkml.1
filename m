Return-Path: <linux-kernel-owner+w=401wt.eu-S933713AbZJHVSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713AbZJHVSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933666AbZJHVSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:18:37 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:40231 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652AbZJHVSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DPwi6W/6lfrX6HB6BjluOaVT+LUGDVidrge41zI6F+1+ph2xjhwjWmP7ZrYQmBVNgD
         Dqh69ftNHbMdRy0deWbPLANBD/bUZwzSLxURfcDTOPpnQgPVIewrj19KGBuYDpVKENpk
         ywvUC0Y7uXU7qV7r6PgtoTeTfR0viYLUaEQDY=
Date: Thu, 8 Oct 2009 23:17:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
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
	for kprobe-event setup helper
Message-ID: <20091008211755.GG5073@nowhere>
References: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com> <20091007222822.1684.3251.stgit@dhcp-100-2-132.bos.redhat.com> <4ACE56EE.8060000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACE56EE.8060000@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 05:17:34PM -0400, Masami Hiramatsu wrote:
> Masami Hiramatsu wrote:
>> Add perf probe subcommand for kprobe-event setup helper to perf command.
>> This allows user to define kprobe events by C expressions (C line numbers,
>> C function names, and C local variables).
>>
>> Usage
>> -----
>>   perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]
>>
>>      -k, --vmlinux<file>   vmlinux/module pathname
>>      -P, --probe<p|r:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]>
>>                            probe point definition, where
>> 		p:	kprobe probe
>> 		r:	kretprobe probe
>> 		GRP:	Group name (optional)
>> 		NAME:	Event name
>> 		FUNC:	Function name
>> 		OFFS:	Offset from function entry (in byte)
>> 		SRC:	Source code path
>> 		LINE:	Line number
>> 		ARG:	Probe argument (local variable name or
>> 			kprobe-tracer argument format is supported.)
>
> Oops, I found it caused compilation error on gcc < 4.4 as below:
>
>     CC builtin-trace.o
>     CC builtin-probe.o
> cc1: warnings being treated as errors
> builtin-probe.c: In function 'parse_probepoint':
> builtin-probe.c:109: error: implicit declaration of function 'strndup'
> builtin-probe.c:109: error: incompatible implicit declaration of built-in function 'strndup'
>
> Since I forgot to add _GNU_SOURCE...
>


No problem, I can add it, or rather include util/util.h as it includes
everything necessary for the string functions + _GNU_SOURCE :)

