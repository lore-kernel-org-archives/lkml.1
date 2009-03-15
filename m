Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbZCOTjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbZCOTjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760021AbZCOTf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:35:56 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:61284 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759996AbZCOTfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:35:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8FACvwvElMQW1W/2dsb2JhbACBTM4jg38GYQ
Date: Sun, 15 Mar 2009 15:35:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC patch 02/21] LTTng Kernel Trace Thread Flag ARM fix
	syscall exit
Message-ID: <20090315193548.GA10601@Krystal>
References: <20090315190340.229569867@polymtl.ca> <20090315191102.623800671@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090315191102.623800671@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:34:32 up 15 days, 16:00,  2 users,  load average: 0.28, 0.30,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry, forgot to pick this one from my tree in the original post)

Make sure we re-test the kernel trace thread flag at syscall exit even if we
were not tracing at syscall entry. This fixes syscall exit tracing early in the
trace.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/arm/kernel/entry-common.S |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-omap-2.6/arch/arm/kernel/entry-common.S
===================================================================
--- linux-omap-2.6.orig/arch/arm/kernel/entry-common.S	2009-02-21 16:31:10.000000000 +0000
+++ linux-omap-2.6/arch/arm/kernel/entry-common.S	2009-02-21 16:32:18.000000000 +0000
@@ -43,6 +43,8 @@
  * Ok, we need to do extra processing, enter the slow path.
  */
 fast_work_pending:
+	tst	r1, #_TIF_KERNEL_TRACE		@ flag can be set asynchronously
+	bne	__sys_trace_return
 	str	r0, [sp, #S_R0+S_OFF]!		@ returned r0
 work_pending:
 	tst	r1, #_TIF_NEED_RESCHED

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
