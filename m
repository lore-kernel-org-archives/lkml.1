Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZCULWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZCULWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 07:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZCULW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 07:22:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbZCULW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 07:22:27 -0400
Date: Sat, 21 Mar 2009 04:13:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [RFC][PATCH -tip 0/5 V2] tracing: kprobe-based event tracer
Message-Id: <20090321041316.562e7a0f.akpm@linux-foundation.org>
In-Reply-To: <49C443E1.6070400@redhat.com>
References: <49C443E1.6070400@redhat.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009 21:33:21 -0400 Masami Hiramatsu <mhiramat@redhat.com> wrote:

>   echo /debug/tracing/trace

Should be cat, I assume?

> # tracer: nop
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>            <...>-2376  [001]   262.389131: do_sys_open: @do_sys_open+0 0xffffff9c 0x98db83e 0x8880 0x0
>            <...>-2376  [001]   262.391166: sys_open: <-do_sys_open+0 0x5 0xc06e8ebb
>            <...>-2376  [001]   264.384876: do_sys_open: @do_sys_open+0 0xffffff9c 0x98db83e 0x8880 0x0
>            <...>-2376  [001]   264.386880: sys_open: <-do_sys_open+0 0x5 0xc06e8ebb
>            <...>-2084  [001]   265.380330: do_sys_open: @do_sys_open+0 0xffffff9c 0x804be3e 0x0 0x1b6
>            <...>-2084  [001]   265.380399: sys_open: <-do_sys_open+0 0x3 0xc06e8ebb

Well...  this is cool and all that, but nowhere near as useful as kgdb! 
Its main competition however will be plain old printk.

Do we really honestly think that this feature will be sufficiently useful
to a sufficiently large number of kernel developers as to warrant
inclusion?

Perhaps a bit more thought about some more complex use cases would help.

And given that the users of this (and other tracing features) are general
kernel developers rather than tracing (or kprobes) developers, it would be
nice to get some feedback and even testing/usage results from those people.
ie: everyone else.
