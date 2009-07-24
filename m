Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZGXTfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZGXTfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZGXTfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:35:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbZGXTfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:35:39 -0400
Date: Fri, 24 Jul 2009 15:35:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][GIT PULL] trace: stop tracer in oops_enter()
Message-ID: <alpine.DEB.2.00.0907241533540.29550@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo or Thomas,

This is on top of the previous pull requests I made for 31.

Please pull the latest tip/tracing/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent-2


Thomas Gleixner (1):
      trace: stop tracer in oops_enter()

----
 kernel/panic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
---------------------------
commit bdff78707f3ce47e891f3201c9666122a70556ce
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Jul 24 15:30:45 2009 -0400

    trace: stop tracer in oops_enter()
    
    If trace_printk_on_oops is set we lose interesting trace information
    when the tracer is enabled across oops handling and printing. We want
    the trace which might give us information _WHY_ we oopsed.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/panic.c b/kernel/panic.c
index 984b3ec..512ab73 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -301,6 +301,7 @@ int oops_may_print(void)
  */
 void oops_enter(void)
 {
+	tracing_off();
 	/* can't trust the integrity of the kernel anymore: */
 	debug_locks_off();
 	do_oops_enter_exit();

