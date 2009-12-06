Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbZLFHe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbZLFHe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZLFHey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:34:54 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35687 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbZLFHex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eZy+zz45Oe6IdUYEZfs7yqGTsnjKlFUwX4YfIQJf45qGlaUvAIUB9zhaQb+O6IzqPQ
         JfataRFIcoFErZTVfJMrDC/j35NcqQ458kM7w8hbm3V5Weh2kE31jRNEkCjvlqo2Pap1
         wHd6ufun8RTALrrs9PiKRlldpbGD2VE0I4v0w=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [GIT PULL] perf/hw-breakpoints: Various updates
Date: Sun,  6 Dec 2009 08:34:49 +0100
Message-Id: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

I have hesitations about the 2 last patches as they should probably
go into another branch. Their scope is wider than perf as they also
fix x86-64 stacktraces in general.

Tell me if you'd prefer them in a separate tree based on something else.

Thanks,
	Frederic
---

Frederic Weisbecker (9):
      hw-breakpoints: Add two reserved fields for future extensions
      perf: Remove pointless union that wraps the hw breakpoint fields
      perf: Remove unused struct perf_event::event_callback
      hw-breakpoints: Drop callback and task parameters from modify helper
      hw-breakpoints: Use overflow handler instead of the event callback
      perf: Remove the "event" callback from perf events
      x86/perf: Exclude the debug stack from the callchains
      x86: Fixup wrong debug exception frame link in stacktraces
      x86: Fixup wrong irq frame link in stacktraces


 arch/x86/kernel/cpu/perf_event.c        |    9 ++++---
 arch/x86/kernel/dumpstack_64.c          |   33 +++++++++++++++++++++++++++++-
 arch/x86/kernel/entry_64.S              |    6 ++--
 arch/x86/kernel/hw_breakpoint.c         |    5 +--
 arch/x86/kernel/ptrace.c                |   13 +++++++----
 include/linux/hw_breakpoint.h           |   34 +++++++++++-------------------
 include/linux/perf_event.h              |   28 +++++++++++--------------
 kernel/hw_breakpoint.c                  |   22 ++++++-------------
 kernel/perf_event.c                     |   24 ++++++++-------------
 kernel/trace/trace_ksym.c               |    5 ++-
 samples/hw_breakpoint/data_breakpoint.c |    7 ++++-
 11 files changed, 99 insertions(+), 87 deletions(-)
