Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZBCCoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZBCCoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 21:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZBCCn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 21:43:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53867 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZBCCn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 21:43:58 -0500
Message-Id: <20090203023830.440860800@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 02 Feb 2009 21:38:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 0/3] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The first patch here is to disable the branch tracer on ALPHA.
There has been several reports that the branch tracer breaks the
compile on ALPHA. Alpha uses ifs extern inlines, and the injecting
of static elements breaks the build.

The next patch fixes the selecting of a tracer for bootup.
Now you can select the default tracer from the kernel command line.

i.e.

  ftrace=function

Will start the function tracer as soon as it is registered.

Now that we have the kernel command line tracer selection working
we can use it for he boot "initcall" tracer. Instead of having the
initcall tracer disable selftests, it now needs to be selected
in the kernel command line as the default tracer to be implemented.
This means we can keep both selftest and boot initcall tracer configured
at the same time.

  ftrace=initcall

Will now enable the boot initcall tracer. No need to recompile.

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (3):
      trace: disable branch tracer on alpha
      trace: fix default boot up tracer
      trace: let boot trace be chosen by command line

----
 kernel/trace/Kconfig      |    9 +++---
 kernel/trace/trace.c      |   65 ++++++++++++++++++++++++++++++++++++++-------
 kernel/trace/trace_boot.c |   11 +++++---
 3 files changed, 67 insertions(+), 18 deletions(-)
-- 
