Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbYIYMi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbYIYMi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYIYMiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 08:38:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48432 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbYIYMiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 08:38:21 -0400
Date: Thu, 25 Sep 2008 14:38:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [Patch -tip 1/3] Tracing/ftrace: Relay unhandled entry output
Message-ID: <20080925123802.GA6900@elte.hu>
References: <48DB81BA.2050204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48DB81BA.2050204@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> Hi!
> 
> I tried to figure out the origin of the bug reported by Pekka Paalanen
> about the broken pipe:
> http://kerneltrap.org/mailarchive/linux-kernel/2008/9/15/3305224
> 
> When I add a trace_mark with the boot tracer, I had this same problem
> but this time it was easy to reproduce.
> 
> When it calls a tracer's print_line callback, the print_trace_line function 
> in trace.c returns whithout verifying if it could handle the entry properly.
> And actually the seq could be empty.
> 
> For example the boot_tracer don't handle TRACE_PRINT. Nevertheless it
> wants them to be printed as a default way.
> 
> So print_trace_line function should relay on the other functions which could handle
> an output if one of them fail.
> 
> Reported-by: Pekka Paalanen <pq@iki.fi>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

ah, nice! Applied to tip/tracing/ftrace.

Small nit: could you please send another patch on top of this patch that 
cleans up the checkpatch failures below?

checkpatch usage: you can run it like this:

  scripts/checkpatch.pl --file kernel/trace/*.c

and/or you can run it over patches as well before you submit them.

	Ingo

------------->
ERROR: do not use assignment in if condition
#43: FILE: kernel/trace/trace.c:1910:
+		if ((ret = iter->trace->print_line(iter)))

ERROR: do not use assignment in if condition
#48: FILE: kernel/trace/trace.c:1914:
+		if ((ret = print_bin_fmt(iter)))

ERROR: do not use assignment in if condition
#53: FILE: kernel/trace/trace.c:1918:
+		if ((ret = print_hex_fmt(iter)))

ERROR: do not use assignment in if condition
#58: FILE: kernel/trace/trace.c:1922:
+		if ((ret = print_raw_fmt(iter)))

ERROR: do not use assignment in if condition
#63: FILE: kernel/trace/trace.c:1926:
+		if ((ret = print_lat_fmt(iter, iter->idx, iter->cpu)))

total: 5 errors, 0 warnings, 0 checks, 32 lines checked

