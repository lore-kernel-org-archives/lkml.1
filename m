Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbZISH3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbZISH3L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbZISH3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:29:10 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:50340 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbZISH3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AKN+yIU1XQtmUOZ489gB0gnPXpso9rJN6EhhfziZ195V2yvZIHb8N7ax9R81VnSaIF
         8+el/TZMs4D5xJtxiaqhgRp2v3s6t+1FwDD3stPejKpZzvBtOhho/Vg3NciLz3tnUZZX
         R5N0rf7VdGI1BJydV71DldqwSPYfLSbA61cMQ=
Date: Sat, 19 Sep 2009 09:29:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 2/2] tracing: Document HAVE_FTRACE_SYSCALLS needs
Message-ID: <20090919072908.GB5226@nowhere>
References: <1253338757-5918-1-git-send-email-fweisbec@gmail.com> <1253338757-5918-3-git-send-email-fweisbec@gmail.com> <20090919071712.GB15292@elte.hu> <20090919072249.GA5226@nowhere> <20090919072827.GD15292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919072827.GD15292@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 09:28:27AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Sat, Sep 19, 2009 at 09:17:12AM +0200, Ingo Molnar wrote:
> > > 
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > Document the arch needed requirements to get the support for syscalls
> > > > tracing.
> > > > 
> > > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > > Cc: Ingo Molnar <mingo@elte.hu>
> > > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > > > Cc: Masami Hiramatsu <mhiramat@redhat.com>
> > > > Cc: Jason Baron <jbaron@redhat.com>
> > > > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > > > Cc: Paul Mundt <lethal@linux-sh.org>
> > > > ---
> > > >  Documentation/trace/ftrace-design.txt |   11 ++++++++++-
> > > >  1 files changed, 10 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
> > > > index 7003e10..04ab61c 100644
> > > > --- a/Documentation/trace/ftrace-design.txt
> > > > +++ b/Documentation/trace/ftrace-design.txt
> > > > @@ -216,7 +216,16 @@ If you can't trace NMI functions, then skip this option.
> > > >  HAVE_FTRACE_SYSCALLS
> > > >  ---------------------
> > > >  
> > > > -<details to be filled>
> > > > +You need very few things to get the syscalls tracing in an arch.
> > > > +
> > > > +- Have a NR_syscalls variable in <asm/unistd.h> that provides the number
> > > > +  of syscalls supported by the arch.
> > > > +- Implement arch_syscall_addr() that resolves a syscall address from a
> > > > +  syscall number.
> > > > +- Support the TIF_SYSCALL_TRACEPOINT thread flags
> > > > +- Put the trace_sys_enter() and trace_sys_exit() tracepoints calls from ptrace
> > > > +  in the ptrace syscalls tracing path.
> > > > +- Tag this arch as HAVE_FTRACE_SYSCALLS.
> > > 
> > > HAVE_FTRACE_SYSCALLS is not actually used anywhere.
> > > 
> > > 	Ingo
> > 
> > Ah, that has been renamed HAVE_SYSCALL_TRACEPOINTS recently. What do 
> > you prefer? A delta patch or a rebase?
> 
> We need the acks from Martin/Heiko so lets wait for that and do a new 
> tree then?
> 
> 	Ingo


Ok.

