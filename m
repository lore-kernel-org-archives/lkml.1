Return-Path: <linux-kernel-owner+w=401wt.eu-S966483AbXG3CuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966483AbXG3CuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966326AbXG3Crh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:47:37 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:41624 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966238AbXG3Crd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:47:33 -0400
Message-Id: <20070730024718.890110769@mvista.com>
References: <20070730024534.369897977@mvista.com>
User-Agent: quilt/0.46-1
Date: Sun, 29 Jul 2007 19:45:36 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Content-Disposition: inline; filename=preempt-hardirqs-selects-preempt-softirqs.patch
Subject: [PATCH -rt 2/9] Dont allow non-threaded softirqs and threaded hardirqs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Ingo,

I think this was sent before, and it did cause problems before. Would
there be *any* reason to have non-threaded softirqs but threaded hardirqs.
I can see lots of issues with that.

This patch has selecting hardirqs also select softirqs as threads.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

---
 kernel/Kconfig.preempt |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.22/kernel/Kconfig.preempt
===================================================================
--- linux-2.6.22.orig/kernel/Kconfig.preempt	2007-07-26 14:59:11.000000000 +0000
+++ linux-2.6.22/kernel/Kconfig.preempt	2007-07-26 14:59:48.000000000 +0000
@@ -106,6 +106,7 @@ config PREEMPT_HARDIRQS
 	bool "Thread Hardirqs"
 	default n
 	depends on !GENERIC_HARDIRQS_NO__DO_IRQ
+	select PREEMPT_SOFTIRQS
 	help
 	  This option reduces the latency of the kernel by 'threading'
           hardirqs. This means that all (or selected) hardirqs will run

-- 
