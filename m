Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZHDLhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZHDLhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZHDLhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:37:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:44844 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbZHDLho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:37:44 -0400
Date: Tue, 4 Aug 2009 11:37:07 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <1249374281.10069.22.camel@marge.simson.net>,
	<new-submission>
Subject: [tip:perfcounters/core] perf top: Update man page
Message-ID: <tip-2a7c07f3ba0bb1234ef787134c81a9a4a2319aa9@git.kernel.org>
Git-Commit-ID: 2a7c07f3ba0bb1234ef787134c81a9a4a2319aa9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 11:37:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a7c07f3ba0bb1234ef787134c81a9a4a2319aa9
Gitweb:     http://git.kernel.org/tip/2a7c07f3ba0bb1234ef787134c81a9a4a2319aa9
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 4 Aug 2009 10:24:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 10:35:19 +0200

perf top: Update man page

perf_counter tools: update perf top manual page to reflect
current implementation.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1249374281.10069.22.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>


---
 tools/perf/Documentation/perf-top.txt |  112 +++++++++++++++++++++++++++++----
 1 files changed, 99 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 539d012..4a7d558 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
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
