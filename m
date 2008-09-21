Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbYIUSM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbYIUSM1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 14:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYIUSMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 14:12:19 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:41879 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYIUSMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 14:12:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=DCEpM565n6NDSiQ+vVQ5GYrksZjDYW7f/Sx3rdUXHuPSryX+teBybVNU4X7Os7beK0
         haFot8BglZpfi19udz7rEl/R5No+cepgzNEc/VXOSDscnB5tIHs0U82en66BBfIGOAjd
         rVPVuRfDx6xu/5aZ6bowgvyW6bxspq8wzgxMU=
Message-ID: <48D68E7E.4010902@gmail.com>
Date: Sun, 21 Sep 2008 20:12:14 +0200
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>
Subject: [Patch 2/3] Tracing/ftrace: Tracing engine depends on Nop Tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that nop tracer is used as the default tracer by replacing "none" tracer, tracing engine depends on it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff -rup linux-2.6-tip (2)/kernel/trace/Kconfig linux-2.6-tip/kernel/trace/Kconfig
--- linux-2.6-tip (2)/kernel/trace/Kconfig	2008-09-19 18:01:26.000000000 +0200
+++ linux-2.6-tip/kernel/trace/Kconfig	2008-09-21 00:31:48.000000000 +0200
@@ -1,8 +1,13 @@
 #

 # Architectures that offer an FTRACE implementation should select HAVE_FTRACE:

-#

+#
+
+config NOP_TRACER

+	bool
+

 config HAVE_FTRACE

-	bool

+	bool
+	select NOP_TRACER
 

 config HAVE_DYNAMIC_FTRACE

 	bool

@@ -101,16 +106,6 @@ config SCHED_TRACER

 	  This tracer tracks the latency of the highest priority task

 	  to be scheduled in, starting from the point it has woken up.

 

-config NOP_TRACER

-	bool "NOP Tracer"

-	depends on HAVE_FTRACE

-	depends on DEBUG_KERNEL

-	select TRACING

-	help

-	  This tracer does nothing. The primary purpose for it is to

-	  politely print the output of ftrace_printk() calls without

-	  the overhead of an irrelevant trace taking place.

-

 config CONTEXT_SWITCH_TRACER

 	bool "Trace process context switches"

 	depends on HAVE_FTRACE
