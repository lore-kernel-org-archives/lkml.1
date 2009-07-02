Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbZGBP3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbZGBP3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbZGBP2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:28:33 -0400
Received: from ey-out-1920.google.com ([74.125.78.145]:63176 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbZGBP2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UMqnZ2tnsQKYc1hprwjEYKclJ7AlI5iustZkY2KIQvFGD0uxqju1G2XrXjKLjBybdE
         hrkQg+HJhBkyxdciNDqBjzYqqcir0u5B4t67+WKuJXjL7AqI0hmeFzQ5s2wYBaUXMBy1
         ml/MYisyvOk3+0T9N89zZ7YAQN4xBbgOHVNwM=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 05/16] [loongson] pm: clean up the reboot support
Date: Thu,  2 Jul 2009 23:21:27 +0800
Message-Id: <1ec9ff2c1bbb1d27824afed422c52e8d7af24c40.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

several magic numbers have been replaced by relative macros, which will
be more readable and understandable.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/lemote/lm2e/reset.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/mips/lemote/lm2e/reset.c b/arch/mips/lemote/lm2e/reset.c
index 47ff506..7758093 100644
--- a/arch/mips/lemote/lm2e/reset.c
+++ b/arch/mips/lemote/lm2e/reset.c
@@ -6,21 +6,23 @@
  *
  * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
  * Author: Fuxin Zhang, zhangfx@lemote.com
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
+ * Author: Zhangjin Wu, wuzj@lemote.com
  */
 #include <linux/pm.h>
+#include <linux/io.h>
 
 #include <asm/reboot.h>
+#include <asm/mips-boards/bonito64.h>
 
 static void loongson2e_restart(char *command)
 {
-#ifdef CONFIG_32BIT
-	*(unsigned long *)0xbfe00104 &= ~(1 << 2);
-	*(unsigned long *)0xbfe00104 |= (1 << 2);
-#else
-	*(unsigned long *)0xffffffffbfe00104 &= ~(1 << 2);
-	*(unsigned long *)0xffffffffbfe00104 |= (1 << 2);
-#endif
-	__asm__ __volatile__("jr\t%0"::"r"(0xbfc00000));
+	/* do preparation for reboot */
+	BONITO_BONGENCFG &= ~(1 << 2);
+	BONITO_BONGENCFG |= (1 << 2);
+
+	/* reboot via jumping to boot base address */
+	((void (*)(void))ioremap_nocache(BONITO_BOOT_BASE, 4)) ();
 }
 
 static void loongson2e_halt(void)
-- 
1.6.2.1

