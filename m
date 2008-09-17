Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYIQBQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYIQBQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 21:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYIQBOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 21:14:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:52946 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbYIQBOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 21:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ey79GLXcu6Ml8Z0PHYEKED9KHAG+WJ2U8SovJ0u64wbI6m3TuzwKJUqYmk8Pbr0/oC
         u7Qx649G61e1ZWZ5kBmbsP3YanMDcSZe3E5mPD63NFj+psv1huGcCLGnJjXQk4E97brm
         osn9ob8Xu3ZfSfB6fkUfllCVhI3di/C17c9WE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/5] acpi: add acpi_printk v3
Date: Tue, 16 Sep 2008 18:14:12 -0700
Message-Id: <1221614053-28804-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221614053-28804-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221614053-28804-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use DEFINE_LOGLEVEL_SETUP to set loglevel for acpi
v2: use <acpi, "acpi:"> instead
v3: use KERN_ACPI

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/acpi/osl.c   |    2 ++
 include/linux/acpi.h |    1 +
 2 files changed, 3 insertions(+)

Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -75,6 +75,8 @@ EXPORT_SYMBOL(acpi_in_debugger);
 extern char line_buf[80];
 #endif				/*ENABLE_DEBUGGER */
 
+DEFINE_LOGLEVEL_SETUP(acpi, KERN_ACPI, "acpi:");
+
 static unsigned int acpi_irq_irq;
 static acpi_osd_handler acpi_irq_handler;
 static void *acpi_irq_context;
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -43,6 +43,7 @@
 #include <asm/acpi.h>
 #include <linux/dmi.h>
 
+#define KERN_ACPI "<acpi>"
 
 enum acpi_irq_model_id {
 	ACPI_IRQ_MODEL_PIC = 0,
