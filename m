Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbYE2PRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbYE2PRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbYE2PQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:16:17 -0400
Received: from smtp.movial.fi ([62.236.91.34]:35034 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbYE2PQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:16:15 -0400
X-Greylist: delayed 1140 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 May 2008 11:16:14 EDT
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] [MIPS] fix sparse warning about setup_early_printk()
Date: Thu, 29 May 2008 17:57:08 +0300
Message-Id: <121207303298-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.4.4.3
In-Reply-To: <12120730323761-git-send-email-dmitri.vorobiev@movial.fi>
References: <12120730323761-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warning:

<<<<<<<<

arch/mips/kernel/early_printk.c:35:13: warning: symbol 'setup_early_printk'
was not declared. Should it be static?

<<<<<<<<

The fix is to define a prototype of the setup_early_printk() function and
to include the appropriate header into arch/mips/kernel/early_printk.c.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 arch/mips/kernel/early_printk.c |    1 +
 arch/mips/kernel/setup.c        |    6 +-----
 include/asm-mips/setup.h        |    2 ++
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kernel/early_printk.c b/arch/mips/kernel/early_printk.c
index 9dccfa4..cb602c1 100644
--- a/arch/mips/kernel/early_printk.c
+++ b/arch/mips/kernel/early_printk.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2007 MIPS Technologies, Inc.
  *   written by Ralf Baechle (ralf@linux-mips.org)
  */
+#include <asm/setup.h>
 #include <linux/console.h>
 #include <linux/init.h>
 
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index c6a063b..0370794 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -557,11 +557,7 @@ void __init setup_arch(char **cmdline_p)
 	prom_init();
 
 #ifdef CONFIG_EARLY_PRINTK
-	{
-		extern void setup_early_printk(void);
-
-		setup_early_printk();
-	}
+	setup_early_printk();
 #endif
 	cpu_report();
 	check_bugs_early();
diff --git a/include/asm-mips/setup.h b/include/asm-mips/setup.h
index 70009a9..883f59b 100644
--- a/include/asm-mips/setup.h
+++ b/include/asm-mips/setup.h
@@ -3,4 +3,6 @@
 
 #define COMMAND_LINE_SIZE	256
 
+extern void setup_early_printk(void);
+
 #endif /* __SETUP_H */
-- 
1.4.4.3

