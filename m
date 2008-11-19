Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYKSVXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYKSVXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYKSVXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:23:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58897 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYKSVXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:23:35 -0500
Message-Id: <20081119212204.318400312@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Nov 2008 16:22:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org
Subject: [PATCH 0/9] powerpc: port of dynamic ftrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

Here are the patches that include the changes suggested by both you
and Milton. This series includes the back port of three commits from tip
that are needed for the PowerPC port.

I also made a git branch called "ppc/ftrace-disable" that does not
include two of the three commits. It adds a patch to keep dynamic
ftrace from being enabled by PowerPC architectures.

As I stated above, both branches include one commit from tip:

  ftrace: align __mcount_loc sections

This is because one of the PowerPC patches will not apply without
it. That commit was a clean cherry pick into mainline, so I'm not
worried about it. Still, the only commits that should go to mainline
from the PowerPC git repo are the ones that start with "powerpc".

In the ppc/ftrace-hack branch, I folded the other two commits
from tip, that are needed for the port, into a single commit.
This commit is called:

 NOT FOR MAINLINE ftrace: pass module struct to arch dynamic ftrace functions

This is only to let you test the rest of the patches. I've booted
this branch and ran it on both my PPC64 and my PP32 boxes.

Again:

  The working branch is:                   ppc/ftrace-hack

  The disabling dynamic ftrace branch is:  ppc/ftrace-disable

Only the commits starting with "powerpc" should be pushed to mainline
by you. Those patches are the same in both of the above branches.

Also, I have not tested that "NOT FOR MAINLINE" patch on x86. It may
break that arch. Which is another reason not to push it.


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: ppc/ftrace-hack


Matt Fleming (1):
      ftrace: align __mcount_loc sections

Steven Rostedt (8):
      NOT FOR MAINLINE ftrace: pass module struct to arch dynamic ftrace functions
      powerpc: ftrace, do not latency trace idle
      powerpc: ftrace, convert to new dynamic ftrace arch API
      powerpc/ppc64: ftrace, mcount record powerpc port
      powerpc: ftrace, use probe_kernel API to modify code
      powerpc/ppc64: ftrace, handle module trampolines for dyn ftrace
      powerpc/ppc32: ftrace, enabled dynamic ftrace
      powerpc/ppc32: ftrace, dynamic ftrace to handle modules

----
 arch/powerpc/Kconfig              |    2 +
 arch/powerpc/include/asm/ftrace.h |   14 +-
 arch/powerpc/include/asm/module.h |   16 ++-
 arch/powerpc/kernel/ftrace.c      |  473 +++++++++++++++++++++++++++++++++---
 arch/powerpc/kernel/idle.c        |    5 +
 arch/powerpc/kernel/module_32.c   |   10 +
 arch/powerpc/kernel/module_64.c   |   13 +
 arch/x86/include/asm/ftrace.h     |    9 +-
 arch/x86/kernel/ftrace.c          |  168 +++++++++++++-
 include/linux/ftrace.h            |   51 ++++-
 kernel/module.c                   |    2 +-
 kernel/trace/ftrace.c             |  137 ++++++------
 scripts/recordmcount.pl           |   20 ++-
 13 files changed, 790 insertions(+), 130 deletions(-)
