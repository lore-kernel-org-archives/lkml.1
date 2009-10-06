Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZJFBWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZJFBWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbZJFBWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:22:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46544 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbZJFBWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:22:15 -0400
Subject: Re: [PATCH tracing/kprobes v2 4/5] perf: Add perf probe subcommand
 for kprobe-event setup helper
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <4ACA95F8.7020407@redhat.com>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20091002214904.30906.11622.stgit@dhcp-100-2-132.bos.redhat.com>
	 <1254788953.13160.209.camel@gandalf.stny.rr.com>
	 <4ACA95F8.7020407@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 05 Oct 2009 21:20:15 -0400
Message-Id: <1254792015.13160.212.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 20:57 -0400, Masami Hiramatsu wrote:
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


Nah, I think it is pretty obvious to what it is doing. But then again, I
like ugly hacks like the above.

-- Steve


