Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZJFA5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZJFA5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZJFA5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbZJFA47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:56:59 -0400
Message-ID: <4ACA95F8.7020407@redhat.com>
Date: Mon, 05 Oct 2009 20:57:28 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH tracing/kprobes v2 4/5] perf: Add perf probe subcommand
 for kprobe-event setup helper
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>	 <20091002214904.30906.11622.stgit@dhcp-100-2-132.bos.redhat.com> <1254788953.13160.209.camel@gandalf.stny.rr.com>
In-Reply-To: <1254788953.13160.209.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 2009-10-02 at 17:49 -0400, Masami Hiramatsu wrote:
>> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
>> index b5f1953..6dabcf1 100644
>> --- a/tools/perf/Makefile
>> +++ b/tools/perf/Makefile
>> @@ -419,6 +419,16 @@ ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf *
>>  	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
>>  endif
>>  
>> +ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
>> +	msg := $(warning No libdwarf.h found, disables probe subcommand. Please install libdwarf-dev/libdwarf-devel);
> 
> Wow! And I thought my macros were ugly ;-)

:-)
Maybe, would I better make a separate c file to check this?
Like "autoconf-checkdwarf.c".

>> +
>> +	/* Copy arguments */
>> +	pp->nr_args = argc - 2;
>> +	if (pp->nr_args > 0) {
>> +		pp->args = (char **)malloc(sizeof(char *) * pp->nr_args);
> 
> Hmm, you don't check for failed malloc here?

Oops...

>> +static int synthesize_probepoint(struct probe_point *pp)
>> +{
>> +	char *buf;
>> +	int i, len, ret;
>> +	pp->probes[0] = buf = (char *)calloc(MAX_CMDLEN, sizeof(char));
> 
> Again no check for failed calloc?

Oops again, I'll check it...


>> diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
>> index e11d8d2..ad5f0f4 100644
>> --- a/tools/perf/builtin.h
>> +++ b/tools/perf/builtin.h
> 
> The rest looks fine (for what I can tell, it is all dwarf magic to
> me ;-)

:-)

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

