Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbZFMObc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbZFMObc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757145AbZFMObM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:31:12 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52804 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZFMObK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:31:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic: hard_irqs: handle NR_IRQS > 256 automatically
Date: Sat, 13 Jun 2009 10:30:47 -0400
Message-Id: <1244903447-23579-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244903447-23579-1-git-send-email-vapier@gentoo.org>
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're going to automatically set HARDIRQ_BITS for the arch, might as
well be a little bit smart about it and set it to 9 automatically if
NR_IRQS is larger than 8 bits.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/hardirq.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/hardirq.h b/include/asm-generic/hardirq.h
index 3d5d2c9..d93acec 100644
--- a/include/asm-generic/hardirq.h
+++ b/include/asm-generic/hardirq.h
@@ -12,7 +12,11 @@ typedef struct {
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
 
 #ifndef HARDIRQ_BITS
-#define HARDIRQ_BITS	8
+# if NR_IRQS > 256
+#  define HARDIRQ_BITS	9
+# else
+#  define HARDIRQ_BITS	8
+# endif
 #endif
 
 /*
-- 
1.6.3.1

