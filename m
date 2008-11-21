Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbYKUHOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbYKUHOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYKUHNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:13:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50769 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbYKUHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:13:30 -0500
Message-Id: <20081121071213.365288293@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Nov 2008 02:12:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 0/4] trace: profiling branches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following patches clean up the unlikely/likely tracer. Namely
it consolidates it into a single file called "profile_annotated_branch".

It also adds a new profiler. A true branch profiler that profiles all
if() statements where the conditional is not a constant. It puts 
a bit of overhead on the system, but the results seem pretty interesting.
The results are placed in "profile_branch".

Anyway, enjoy ;-)

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (4):
      trace: remove extra assign in branch check
      trace: consolidate unlikely and likely profiler
      trace: branch profiling should not print percent without data
      trace: profile all if conditionals

----
 include/asm-generic/vmlinux.lds.h |   20 +++++++----
 include/linux/compiler.h          |   64 +++++++++++++++++++++------------
 kernel/trace/Kconfig              |   19 +++++++++-
 kernel/trace/trace_branch.c       |   72 +++++++++++++++++++++++-------------
 4 files changed, 117 insertions(+), 58 deletions(-)
