Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbXF1Wrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbXF1Wrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759953AbXF1Wre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:47:34 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:44742 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619AbXF1Wre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:47:34 -0400
Date: Thu, 28 Jun 2007 18:46:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RT] Don't allow non-threaded softirqs and threaded hardirqs
Message-ID: <Pine.LNX.4.58.0706281844120.28911@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I think this was sent before, and it did cause problems before. Would
there be *any* reason to have non-threaded softirqs but threaded hardirqs.
I can see lots of issues with that.

This patch has selecting hardirqs also select softirqs as threads.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21.5-rt18/kernel/Kconfig.preempt
===================================================================
--- linux-2.6.21.5-rt18.orig/kernel/Kconfig.preempt	2007-06-28 16:58:49.000000000 -0400
+++ linux-2.6.21.5-rt18/kernel/Kconfig.preempt	2007-06-28 17:00:07.000000000 -0400
@@ -106,6 +106,7 @@ config PREEMPT_HARDIRQS
 	bool "Thread Hardirqs"
 	default n
 	depends on !GENERIC_HARDIRQS_NO__DO_IRQ
+	select PREEMPT_SOFTIRQS
 	help
 	  This option reduces the latency of the kernel by 'threading'
           hardirqs. This means that all (or selected) hardirqs will run
