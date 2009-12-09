Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbZLIHWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbZLIHWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757122AbZLIHWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:22:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35488 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757106AbZLIHWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:22:46 -0500
Date: Wed, 9 Dec 2009 08:22:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/8] perf-probe updates
Message-ID: <20091209072220.GA4328@elte.hu>
References: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi Ingo,
> 
> I made several usability updates and added --del option
> for perf-probe. I think most of basic functions are implemented.
> I'm planning to support checking build-id next, because it
> can prevent users to use old vmlinux for debuginfo analysis.
> 
> Here are the todo list I have (most of them had been requested
> on LKML). I'd like to share this list with other developers
> who are interested in.
> 
> Short-term TODOs:
>   - Support checking kernel Build-ID
> 
> Long-term TODOs (future features):
>   - Support --line option to show which lines user can probe
>   - Support lazy string matching(glob?) for selecting probing
>     line
>   - Support sys_perf_counter_open (for non-root users)
>   - Support tracing static variables (non global)
>   - Support variable types from debuginfo (e.g. char, int, ...)
>   - Support fields of data structures (var->field)
>   - Support array (var[N])
>   - Support dynamic array-indexing (var[var2])
>   - Support string/dynamic arrays (*var, var[N..M])
>   - Support force type-casting ((type)var)
>   - Support the type of return value
> 
> Miscs:
>   - Support glob expression with --del option (like --del "*")
>   - Support event/group name specifying for new events
>   - Better support for probes on modules
>   - Symbol search by libelf/kallsyms
>   - Move onto libdw/libdwfl
>   - Storing file name/line number information in the
>     kernel for listing events
>   
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (8):
>       perf probe: Update perf-probe document
>       perf probe: Support --del option
>       trace-kprobe: Support delete probe syntax
>       perf probe: Support vmlinux on cwd by default
>       perf probe: Remove event suffix number _0
>       perf probe: Fix add-probe command syntax without --add option
>       perf probe: Change probe-added message more user-friendly
>       perf probe: Change event list format
> 
> 
>  kernel/trace/trace_kprobe.c             |   37 +++++++--
>  tools/perf/Documentation/perf-probe.txt |   21 ++++-
>  tools/perf/builtin-probe.c              |   76 ++++++++++++++++---
>  tools/perf/util/probe-event.c           |  122 ++++++++++++++++++++++++++++---
>  tools/perf/util/probe-event.h           |    1 
>  5 files changed, 217 insertions(+), 40 deletions(-)

Applied - thanks Masami!

These are very nice enhancements. I tried out the new features and they 
worked well, and the use of the tool is intuitive.

One hickup is that -d/--del does not appear to be working yet:

  # perf probe -l
  probe:schedule                           (on schedule)

  # perf probe -d probe:schedule
  Fatal: Failed to write event: Invalid argument

	Ingo
