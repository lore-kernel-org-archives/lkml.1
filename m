Return-Path: <linux-kernel-owner+w=401wt.eu-S1762201AbXHWJeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201AbXHWJeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbXHWJeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:34:12 -0400
Received: from il.qumranet.com ([82.166.9.18]:40138 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036AbXHWJeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:34:11 -0400
From: Avi Kivity <avi@qumranet.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH] Move PREEMPT_NOTIFIERS into an always-included Kconfig
Date: Thu, 23 Aug 2007 12:34:01 +0300
Message-Id: <1187861641842-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig.preempt is not included on some archs (for example, m68k).  On those
archs, the Kconfig machinery complains that KVM selects an undefined symbol
PREEMPT_NOTIFIERS (which lives in Kconfig.preempt).  Pointing out that this
is a Kconfig bug does not seem to silence the error, so move the offending
symbol into a Kconfig file which is included by everyone.

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/init/Kconfig b/init/Kconfig
index 96b5459..aae3928 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -667,3 +667,6 @@ config STOP_MACHINE
 	  Need stop_machine() primitive.
 
 source "block/Kconfig"
+
+config PREEMPT_NOTIFIERS
+	bool
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 6b06663..c64ce9c 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -63,6 +63,3 @@ config PREEMPT_BKL
 	  Say Y here if you are building a kernel for a desktop system.
 	  Say N if you are unsure.
 
-config PREEMPT_NOTIFIERS
-	bool
-
