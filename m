Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbYKTTMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbYKTTMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbYKTTLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:11:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbYKTTLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:11:51 -0500
Message-Id: <20081120190948.057007623@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 14:09:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Milton Miller <miltonm@bga.com>
Subject: [PATCH 0/5] powerpc: dynamic ftrace port
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul and Ingo,

The following are the changes to get dynamic ftrace working on PowerPC.
I modified these a little from the last postings.

 1) I removed the changes to recordmcount.pl.  This is not a PowerPC
    change, although PowerPC needs it for dynamic ftrace. But
    the changes here can go via linux-tip.

 2) I removed the adding of HAVE_DYNAMIC_FTRACE and HAVE_FTRACE_MCOUNT_RECORD.
    Without these config options, this code will not be compiled.
    I have a separate patch that adds them in when the time is right.

Paul, these patches should not harm anything if you decide to pull them
in. As I stated above, without the above config options, they are
not enabled.

There is one exception and that is for the first patch. The first patch
is actually a fix for the irqsoff latency tracer which is already
in mainline for PowerPC.

These patches only touch PowerPC code.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: ppc/ftrace


Steven Rostedt (5):
      powerpc: ftrace, do not latency trace idle
      powerpc: ftrace, convert to new dynamic ftrace arch API
      powerpc: ftrace, use probe_kernel API to modify code
      powerpc/ppc64: ftrace, handle module trampolines for dyn ftrace
      powerpc/ppc32: ftrace, dynamic ftrace to handle modules

----
 arch/powerpc/include/asm/ftrace.h |   14 +-
 arch/powerpc/include/asm/module.h |   16 ++-
 arch/powerpc/kernel/ftrace.c      |  473 +++++++++++++++++++++++++++++++++---
 arch/powerpc/kernel/idle.c        |    5 +
 arch/powerpc/kernel/module_32.c   |   10 +
 arch/powerpc/kernel/module_64.c   |   13 +
 6 files changed, 489 insertions(+), 42 deletions(-)
