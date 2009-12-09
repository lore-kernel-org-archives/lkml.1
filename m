Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbZLIVDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbZLIVDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZLIVDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:03:35 -0500
Received: from mail.perches.com ([173.55.12.10]:1059 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbZLIVDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:03:34 -0500
Subject: [PATCH] drivers/char/nvram: Restore #include <linux/smp_lock.h>
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 13:03:40 -0800
Message-ID: <1260392620.5351.48.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8587b33f4adee4e7614ea7f443346c3b6bb5427a removed
the include, but it's still required for a different
lock_kernel/unlock_kernel pair in nvram_open

Compiled: x86/defconfig

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 2100a8f..3cfa0f6 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -38,6 +38,7 @@
 #define NVRAM_VERSION	"1.3"
 
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 #include <linux/nvram.h>
 
 #define PC		1


