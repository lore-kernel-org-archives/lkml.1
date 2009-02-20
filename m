Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbZBTTuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbZBTTuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZBTTuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:50:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZBTTuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:50:23 -0500
Message-Id: <20090220193239.561624242@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 20 Feb 2009 14:32:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [git pull v2 @num@/@total@] updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I incorporated your comments, and rebased against your tip/x86/urgent
branch.

Updates are:
 - rename ftrace_arch_modify_* to ftrace_arch_code_modify_*
 - use pr_debug over KERN_INFO in set_kernel_text_*
 - removed comment about ftrace on set_kernel_text_*
 - use return instead of goto to break out of double loop
 - merged akpm's suggestion into 2cd patch

My last commit is:

 4377245aa93b65b6597e4b7bb460fb9abc48b56b
 ftrace: break out modify loop immediately on detection of error

Because I did recently rebase, you might want to confirm that
the SHA1 matches and is not stale data.

Please pull the latest tip/x86/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/x86/ftrace


Steven Rostedt (4):
      ftrace: allow archs to preform pre and post process for code modification
      ftrace, x86: make kernel text writable only for conversions
      ftrace: immediately stop code modification if failure is detected
      ftrace: break out modify loop immediately on detection of error

----
 arch/x86/include/asm/cacheflush.h |    5 +++++
 arch/x86/kernel/ftrace.c          |   17 +++++++++++++++++
 arch/x86/mm/init_32.c             |   35 ++++++++++++++++++++++++++++++++---
 arch/x86/mm/init_64.c             |   37 ++++++++++++++++++++++++++++++++-----
 include/linux/ftrace.h            |    3 +++
 kernel/trace/ftrace.c             |   33 ++++++++++++++++++++++++++++++++-
 6 files changed, 121 insertions(+), 9 deletions(-)

-- 
