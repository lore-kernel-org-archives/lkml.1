Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbZJGDVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbZJGDVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZJGDVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:21:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbZJGDVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:21:42 -0400
Message-ID: <4ACC0963.5080403@redhat.com>
Date: Tue, 06 Oct 2009 23:22:11 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
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
Subject: Re: [PATCH tracing/kprobes v2 4/5] perf: Add perf probe subcommand
 for kprobe-event setup helper
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>	 <20091002214904.30906.11622.stgit@dhcp-100-2-132.bos.redhat.com>	 <1254788953.13160.209.camel@gandalf.stny.rr.com>	 <4ACA95F8.7020407@redhat.com> <1254819822.21044.125.camel@laptop>
In-Reply-To: <1254819822.21044.125.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-10-05 at 20:57 -0400, Masami Hiramatsu wrote:
>>>> +ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
>>>> +    msg := $(warning No libdwarf.h found, disables probe subcommand. Please install libdwarf-dev/libdwarf-devel);
>>>
>>> Wow! And I thought my macros were ugly ;-)
>>
>> :-)
>> Maybe, would I better make a separate c file to check this?
>> Like "autoconf-checkdwarf.c".
> 
> I'm the one who started this trend.. Maybe putting all those tests in a
> static .c file makes sense now, put them in a tests/ or checks/
> directory though, so it doesn't litter the regular files.
> 
> Then again,.. the actual .c file is only half that line, so it doesn't
> really clean up that much.

Yeah, ok, then I'll leave this part in this series.
It's better to be done in another series.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

