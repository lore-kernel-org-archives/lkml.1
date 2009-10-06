Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZJFBpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZJFBpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZJFBpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:45:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbZJFBpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:45:10 -0400
Date: Mon, 5 Oct 2009 22:43:32 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v2 4/5] perf: Add perf probe subcommand
	for kprobe-event setup helper
Message-ID: <20091006014332.GE16562@ghostprotocols.net>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214904.30906.11622.stgit@dhcp-100-2-132.bos.redhat.com> <1254788953.13160.209.camel@gandalf.stny.rr.com> <4ACA95F8.7020407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACA95F8.7020407@redhat.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 05, 2009 at 08:57:28PM -0400, Masami Hiramatsu escreveu:
> Steven Rostedt wrote:
> > On Fri, 2009-10-02 at 17:49 -0400, Masami Hiramatsu wrote:
> >> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> >> index b5f1953..6dabcf1 100644
> >> --- a/tools/perf/Makefile
> >> +++ b/tools/perf/Makefile
> >> @@ -419,6 +419,16 @@ ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf *
> >>  	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
> >>  endif
> >>  
> >> +ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
> >> +	msg := $(warning No libdwarf.h found, disables probe subcommand. Please install libdwarf-dev/libdwarf-devel);
> > 
> > Wow! And I thought my macros were ugly ;-)
> 
> :-)
> Maybe, would I better make a separate c file to check this?
> Like "autoconf-checkdwarf.c".

I saw that coming, I'd say leave it as is... :)
 
> >> +
> >> +	/* Copy arguments */
> >> +	pp->nr_args = argc - 2;
> >> +	if (pp->nr_args > 0) {
> >> +		pp->args = (char **)malloc(sizeof(char *) * pp->nr_args);
> > 
> > Hmm, you don't check for failed malloc here?
> 
> Oops...

Also no need for cast
 

- Arnaldo
