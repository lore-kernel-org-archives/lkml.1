Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZHDIYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZHDIYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbZHDIYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:24:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:36442 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755257AbZHDIYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:24:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/nQqxU5iDnNhMv+xc+Z4VnwEXLET94VzKXIWaD+P
	LTMzf5HtIiB2Lq
Subject: [patch] perf tools: update perf top man page
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1249374083.10069.18.camel@marge.simson.net>
References: <1248422990.28486.3.camel@marge.simson.net>
	 <1248425937.6987.0.camel@twins> <1248431821.9722.4.camel@marge.simson.net>
	 <20090802200049.GF24486@elte.hu>
	 <1249276178.17959.67.camel@marge.simson.net>
	 <1249374083.10069.18.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 10:24:41 +0200
Message-Id: <1249374281.10069.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf_counter tools: update perf top manual page to reflect current implementation.


Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 tools/perf/Documentation/perf-top.txt |  112 ++++++++++++++++++++++++++++++----
 1 file changed, 99 insertions(+), 13 deletions(-)

Index: linux-2.6/tools/perf/Documentation/perf-top.txt
===================================================================
--- linux-2.6.orig/tools/perf/Documentation/perf-top.txt
+++ linux-2.6/tools/perf/Documentation/perf-top.txt
@@ -3,36 +3,122 @@ perf-top(1)
 
 NAME
 ----
-perf-top - Run a command and profile it
+perf-top - System profiling tool.
 
 SYNOPSIS
 --------
 [verse]
-'perf top' [-e <EVENT> | --event=EVENT] [-l] [-a] <command>
+'perf top' [-e <EVENT> | --event=EVENT] [<options>]
 
 DESCRIPTION
 -----------
-This command runs a command and gathers a performance counter profile
-from it.
+This command generates and displays a performance counter profile in realtime.
 
 
 OPTIONS
 -------
-<command>...::
-	Any command you can specify in a shell.
+-a::
+--all-cpus::
+        System-wide collection.  (default)
+
+-c <count>::
+--count=<count>::
+	Event period to sample.
+
+-C <cpu>::
+--CPU=<cpu>::
+	CPU to profile.
+
+-d <seconds>::
+--delay=<seconds>::
+	Number of seconds to delay between refreshes.
 
--e::
---event=::
+-e <event>::
+--event=<event>::
 	Select the PMU event. Selection can be a symbolic event name
 	(use 'perf list' to list all events) or a raw PMU
 	event (eventsel+umask) in the form of rNNN where NNN is a
-	 hexadecimal event descriptor.
+	hexadecimal event descriptor.
 
--a::
-        system-wide collection
+-E <entries>::
+--entries=<entries>::
+	Display this many functions.
+
+-f <count>::
+--count-filter=<count>::
+	Only display functions with more events than this.
+
+-F <freq>::
+--freq=<freq>::
+	Profile at this frequency.
+
+-i::
+--inherit::
+	Child tasks inherit counters, only makes sens with -p option.
+
+-k <path>::
+--vmlinux=<path>::
+	Path to vmlinux.  Required for annotation functionality.
+
+-m <pages>::
+--mmap-pages=<pages>::
+	Number of mmapped data pages.
+
+-p <pid>::
+--pid=<pid>::
+	Profile events on existing pid.
+
+-r <priority>::
+--realtime=<priority>::
+	Collect data with this RT SCHED_FIFO priority.
+
+-s <symbol>::
+--sym-annotate=<symbol>::
+        Annotate this symbol.  Requires -k option.
+
+-v::
+--verbose::
+	Be more verbose (show counter open errors, etc).
+
+-z::
+--zero::
+	Zero history across display updates.
+
+INTERACTIVE PROMPTING KEYS
+--------------------------
+
+[d]::
+	Display refresh delay.
+
+[e]::
+	Number of entries to display.
+
+[E]::
+	Event to display when multiple counters are active.
+
+[f]::
+	Profile display filter (>= hit count).
+
+[F]::
+	Annotation display filter (>= % of total).
+
+[s]::
+	Annotate symbol.
+
+[S]::
+	Stop annotation, return to full profile display.
+
+[w]::
+	Toggle between weighted sum and individual count[E]r profile.
+
+[z]::
+	Toggle event count zeroing across display updates.
+
+[qQ]::
+	Quit.
+
+Pressing any unmapped key displays a menu, and prompts for input.
 
--l::
-        scale counter values
 
 SEE ALSO
 --------


