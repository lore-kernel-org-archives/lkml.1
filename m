Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbZJTA2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbZJTA2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758067AbZJTA2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:28:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758035AbZJTA2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:28:37 -0400
Message-ID: <4ADD049E.9080000@redhat.com>
Date: Mon, 19 Oct 2009 20:30:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ashwin Chaugule <ashbertslists@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
 	probe and kprobe-tracer bugfixes
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <ad7a95ae0910191610q6f6200f1n112a71a0cbd483f1@mail.gmail.com>
In-Reply-To: <ad7a95ae0910191610q6f6200f1n112a71a0cbd483f1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashwin,

Ashwin Chaugule wrote:
> Masami,
>            I really like your idea with kprobes ! I havent yet run
> this stuff on my machine, but I've been planning to utilize kprobes
> with perfevents too. Please let me know if the following functionality
> is already possible with your patches.

Thanks! I'm happy to here that you are interested in.

> The basic idea I had was to be able to profile any function in the
> kernel using kprobes and use the perfevents framework to monitor
> things like incorrect branch predictions, cache misses etc. for the
> scope of that function. That way, we can fine tune kernel functions
> that are in the hot path of kernel control flow, using gcc tricks,
> inline assembly, or even architecture specific tricks.

Actually, perf-probe can add tracepoint-like events. It will allow you
to probe function inside by both C-source-line level and address level.
perf-probe already supports inline function too.

Currently, even its syntax is unstable, but you can add an event inside
some function which is at cfile.c line 100, as below;

 perf probe -P 'p:probe1 cfile.c:100'

and you can trace it by using perf record as same as other tracepoints

 perf record -f -e kprobes:myprobe:record -F 1 -a ls


> Alternately, I think even dynamic trace could provide similar insight
> with perfevents ? If none of this is already done, I plan to work on
> this in my spare time and would like to team up with anyone else
> interested.

Yes, it's done as I said above.
But it still has long TODO list, including support type of arguments,
arrays, fields of structures and so on (of course, defining useful
syntax too). So any comments and contributes are welcome :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

