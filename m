Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZCDLsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZCDLsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZCDLsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:48:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42199 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbZCDLsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:48:23 -0500
Subject: [PATCH] lockdep: require framepointers for x86
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 12:48:15 +0100
Message-Id: <1236167295.5330.7240.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: lockdep: require framepointers for x86
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Mar 04 12:27:27 CET 2009

Require framepointers for x86, because otherwise we'll be having empty stack
traces, which is useless.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug
+++ linux-2.6/lib/Kconfig.debug
@@ -452,7 +452,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !X86 && !MIPS && !PPC
+	select FRAME_POINTER if !MIPS && !PPC
 	select KALLSYMS
 	select KALLSYMS_ALL
 


