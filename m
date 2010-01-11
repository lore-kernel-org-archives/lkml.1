Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358Ab0AKMZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0AKMZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309Ab0AKMZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:25:28 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40933 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0AKMZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:25:27 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jan 2010 17:55:21 +0530
Message-Id: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
Subject: [RFC] [PATCH 0/7] UBP, XOL and Uprobes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

This patchset implements Uprobes which enables you to dynamically
break into any routine in a user space application and collect
information non-disruptively.  Uprobes is based on utrace and uses
x86 instruction decoder.

When a uprobe is registered, Uprobes makes a copy of the probed
instruction, stops the probed application, replaces the first
byte(s) of the probed instruction with a breakpoint instruction and
allows the probed application to continue.  (Uprobes uses the same
copy-on-write mechanism so that the breakpoint affects only that
process.)

When a CPU hits the breakpoint instruction, Uprobes intercepts the
SIGTRAP and finds the associated uprobe.  It then executes the
associated handler.  Uprobes single-steps its copy of the probed
instruction and resumes execution of the probed process at the
instruction following the probepoint. Instruction copies to be
single-stepped are stored in a per-process "single-step out of line
(XOL) area,"

Uprobes can be used to take advantage of static markers available
in user space applications.

Advantages of uprobes over conventional debugging include:
1. Non-disruptive.
2. Uses Execution out of line(XOL), 
3. Much better handling of multithreaded programs because of XOL.
4. No context switch between tracer, tracee.

Here is the list of TODO Items.

- Provide a perf interface to uprobes.
- Return probes.
- Support for Other Architectures.
- Jump optimization.


This patchset provides
Subject: [RFC] [PATCH 0/7] UBP, XOL and Uprobes
Subject: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Subject: [RFC] [PATCH 2/7] x86 support for  UBP 
Subject: [RFC] [PATCH 3/7] Execution out of line (XOL)
Subject: [RFC] [PATCH 4/7] Uprobes Implementation
Subject: [RFC] [PATCH 5/7] X86 Support for Uprobes
Subject: [RFC] [PATCH 6/7] Uprobes Documentation
Subject: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes

This patchset is based on 
git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git

If and when utrace gets accepted into tip tree or Mainline, I will rebase
this patchset.

Please do provide your valuable comments.

--
Thanks and Regards
Srikar
