Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZDXGOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZDXGOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZDXGNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:13:51 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:40879 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZDXGNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:13:50 -0400
Date: Fri, 24 Apr 2009 11:43:38 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>
Subject: [Patch 00/12] Hardware Breakpoint Interfaces
Message-ID: <20090424061338.GA23812@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
	The following patches contain the changes mentioned below and is based
on commit 335a1e07e2281795064b909aa75e3071609abd0e of -tip tree.

The changes to passing of DR6 register value in traps.c is separated into
[Patch 12/12]. kprobes and HW breakpoints have been found to work fine after 
the changes on an x86 box.

Kindly let me know what you think of the changes.

Hi Steven/Frederick,
		The changes to the ftrace plugin that converts all mutex locks
into spinlocks are done now and have been tested to work fine. The patch can be 
found in Patch 11/12. Kindly acknowledge the same.

Changelog
-----------
- Convert hw_breakpoint_mutex into a spinlock() based implementation (will now
  be called as hw_breakpoint_lock). This is to avoid a call to a mutex (which
  can potentially sleep) in the context of a softIRQ through which
  flush_thread_hw_breakpoint() is invoked at the time of process exit.
- Call put_cpu_no_resched() unconditionally in hw_breakpoint_handler() code (the
  previous code erroneously invoked it inside an "if" condition)
- Use PTR_ERR and ERR_PTR macros for passing dr6 register value in do_debug()
- Reset bits in local copy of DR6 register in do_debug() function to indicate
  that the exception corresponding to the bit has been handled.
- Convert all synchronisation primitives into spinlocks in trace_ksym.c to
  prevent the potential interference between statistics collection code in
  ksym_collect_stats() with other ksym filter file's read/write routines.
- A few changes in comments and code following comments from Alan Stern.

Thanks,
K.Prasad


