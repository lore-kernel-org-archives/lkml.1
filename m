Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZJCByq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZJCByq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 21:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZJCByp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 21:54:45 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:43672 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZJCByo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 21:54:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oDMPJQLePdcoWG7u3Q/c4HvukvbJdv346jFHA/+kuHaxedjN+BWNRzh4QlE2xenP65
         2BRqwHugmM/8CXfoBHSlj+evu4Z2I2EkDUluf4cI5BspCT6iQ2YDEO7l+IGH6AL+d7zV
         6tE7hyoytgiT74h5B4CpDT6FYb7EE9IpYDYr8=
Date: Sat, 3 Oct 2009 03:54:45 +0200
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
Subject: Re: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
	variables syntax
Message-ID: <20091003015444.GE4828@nowhere>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 05:48:42PM -0400, Masami Hiramatsu wrote:
> Add $ prefix to the special variables(e.g. sa, rv) of kprobe-tracer.
> This resolves consistency issue between kprobe_events and perf-kprobe.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Frank Ch. Eigler <fche@redhat.com>
> ---
> 
>  Documentation/trace/kprobetrace.txt |   10 +++---
>  kernel/trace/trace_kprobe.c         |   60 ++++++++++++++++++++++-------------
>  2 files changed, 42 insertions(+), 28 deletions(-)
> 
> diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
> index 9b8f7c6..40caef0 100644
> --- a/Documentation/trace/kprobetrace.txt
> +++ b/Documentation/trace/kprobetrace.txt
> @@ -36,13 +36,13 @@ Synopsis of kprobe_events
>  
>   FETCHARGS	: Arguments. Each probe can have up to 128 args.
>    %REG	: Fetch register REG
> -  sN	: Fetch Nth entry of stack (N >= 0)
> -  sa	: Fetch stack address.
>    @ADDR	: Fetch memory at ADDR (ADDR should be in kernel)
>    @SYM[+|-offs]	: Fetch memory at SYM +|- offs (SYM should be a data symbol)
> -  aN	: Fetch function argument. (N >= 0)(*)
> -  rv	: Fetch return value.(**)
> -  ra	: Fetch return address.(**)
> +  $sN	: Fetch Nth entry of stack (N >= 0)
> +  $sa	: Fetch stack address.
> +  $aN	: Fetch function argument. (N >= 0)(*)
> +  $rv	: Fetch return value.(**)
> +  $ra	: Fetch return address.(**)



I feel uncomfortable with that, because of bash scripts that
may use it and always need to escape it with antislashes or
use single quotes for it to not be replaced by a random variable
value. If one uses double quotes without antislashes to protect
the command line, the result is unpredictable, depending of
the current set of variables...

May be we can use # instead of $ ? That's a kind of pity because
$ suggested a variable whereas # suggests a constant, we are then
losing this self-explainable characteristic for kprobes
"specific variable fetchs". But that will work without ambiguity.

I hope someone else has a better idea...

