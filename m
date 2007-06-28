Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbXF1WvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbXF1WvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932453AbXF1Wue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:50:34 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:61872 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbXF1Wud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:50:33 -0400
Date: Thu, 28 Jun 2007 18:49:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RT] Move RECURSION_LIMIT define up for global use.
Message-ID: <Pine.LNX.4.58.0706281846580.28911@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

If one has CONFIG_PROVE_LOCKING off but CONFIG_TRACE_IRQFLAGS on, the
RECURSION_LIMIT definition is not defined.  This patch move
RECURSION_LIMIT up for global use.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21.5-rt18/kernel/lockdep.c
===================================================================
--- linux-2.6.21.5-rt18.orig/kernel/lockdep.c	2007-06-28 18:36:32.000000000 -0400
+++ linux-2.6.21.5-rt18/kernel/lockdep.c	2007-06-28 18:36:51.000000000 -0400
@@ -44,6 +44,8 @@

 #include "lockdep_internals.h"

+#define RECURSION_LIMIT 40
+
 #ifdef CONFIG_PROVE_LOCKING
 int prove_locking = 1;
 module_param(prove_locking, int, 0644);
@@ -740,8 +742,6 @@ static noinline int print_circular_bug_t
 	return 0;
 }

-#define RECURSION_LIMIT 40
-
 static int noinline print_infinite_recursion_bug(void)
 {
 	if (!debug_locks_off_graph_unlock())
