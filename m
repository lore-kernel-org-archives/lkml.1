Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYJ2PQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYJ2PQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYJ2PQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:16:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50281 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYJ2PQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:16:00 -0400
Date: Wed, 29 Oct 2008 11:15:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH] ftrace: fix trace_nop config select
In-Reply-To: <20081029091857.GA4414@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.1.10.0810291113500.2865@gandalf.stny.rr.com>
References: <200810281802.m9SI2fYX030138@hera.kernel.org> <20081029091857.GA4414@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The trace_nop is the tracer that is defined when no tracer is set in
the ftrace infrastructure.

The trace_nop was mistakenly selected by HAVE_FTRACE due to the confusion
between ftrace infrastructure and the ftrace function tracer (which has
been solved by renaming the function tracer).

This patch changes the select to the approriate TRACING.

This patch should fix compile errors on architectures that do not define
the FUNCTION_TRACER.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/Kconfig
===================================================================
--- linux-tip.git.orig/kernel/trace/Kconfig	2008-10-29 10:37:49.000000000 -0400
+++ linux-tip.git/kernel/trace/Kconfig	2008-10-29 11:07:20.000000000 -0400
@@ -8,7 +8,6 @@ config NOP_TRACER
 
 config HAVE_FUNCTION_TRACER
 	bool
-	select NOP_TRACER
 
 config HAVE_DYNAMIC_FTRACE
 	bool
@@ -28,6 +27,7 @@ config TRACING
 	select RING_BUFFER
 	select STACKTRACE
 	select TRACEPOINTS
+	select NOP_TRACER
 
 menu "Tracers"
 


