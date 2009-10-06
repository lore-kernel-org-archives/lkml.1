Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbZJFJEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbZJFJEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZJFJEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:04:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38692 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZJFJEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:04:42 -0400
Subject: Re: [PATCH tracing/kprobes v2 4/5] perf: Add perf probe subcommand
 for kprobe-event setup helper
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
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
Date: Tue, 06 Oct 2009 11:03:42 +0200
Message-Id: <1254819822.21044.125.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 20:57 -0400, Masami Hiramatsu wrote:
> >> +ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
> >> +    msg := $(warning No libdwarf.h found, disables probe subcommand. Please install libdwarf-dev/libdwarf-devel);
> > 
> > Wow! And I thought my macros were ugly ;-)
> 
> :-)
> Maybe, would I better make a separate c file to check this?
> Like "autoconf-checkdwarf.c".

I'm the one who started this trend.. Maybe putting all those tests in a
static .c file makes sense now, put them in a tests/ or checks/
directory though, so it doesn't litter the regular files.

Then again,.. the actual .c file is only half that line, so it doesn't
really clean up that much.

