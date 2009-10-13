Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbZJMHtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbZJMHtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759030AbZJMHtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:49:21 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:36762 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067AbZJMHtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G0FvWFPV6eiGI4VprVIkhXcrEnv8mZQJvy7hYOlrTV9SDuejeqijhcLH1dE2DP62/H
         1zR8qyiGsYBszEIREx0BE+UewnnfYmyN/4fxnecre/IDTUuVRiAogGzciy1CGulFS1NB
         HqZkingWuGIAqjvBPJxYmZoDVQhyrRSjzqs3I=
Date: Tue, 13 Oct 2009 09:48:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch . Eigler" <fche@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: Syntax updates, introduce perf
	probe
Message-ID: <20091013074838.GA5076@nowhere>
References: <1255386309-4992-1-git-send-email-fweisbec@gmail.com> <20091013061323.GE3215@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013061323.GE3215@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 08:13:23AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Ingo,
> > 
> > I've tested a little this set and it seems to work well. I can't test 
> > the C expression parser (need some libdwarf cross-version 
> > compatiblity), but I can create kprobes via low-level parameters, then 
> > launch perf record and perf trace successfully. I'll need to update 
> > perf trace to handle variables that start with '$' characters though.
> > 
> > Anyway, it's still unstable but I guess pulling it would help Masami 
> > to continue without the need to handle the whole batch.
> > 
> > Please pull the tracing/kprobes branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	tracing/kprobes
> 
> Pulled, thanks Frederic.
> 
> >  Documentation/trace/kprobetrace.txt |   27 +-
> >  kernel/trace/trace_kprobe.c         |  160 +++++---
> >  tools/perf/Makefile                 |   10 +
> >  tools/perf/builtin-probe.c          |  386 +++++++++++++++++++
> >  tools/perf/builtin.h                |    1 +
> >  tools/perf/perf.c                   |    1 +
> >  tools/perf/util/probe-finder.c      |  690 +++++++++++++++++++++++++++++++++++
> >  tools/perf/util/probe-finder.h      |   70 ++++
> >  8 files changed, 1271 insertions(+), 74 deletions(-)
> >  create mode 100644 tools/perf/builtin-probe.c
> >  create mode 100644 tools/perf/util/probe-finder.c
> >  create mode 100644 tools/perf/util/probe-finder.h
> 
> Hm, there's no x86 decoder change here - does this lot fixes the 
> instruction decoder bug i reported some time ago? That is which keeps 
> tracing/kprobes out of tip:master.
> 
> 	Ingo


Not yet, I hope it's part of the last family of instruction set we
are missing.

