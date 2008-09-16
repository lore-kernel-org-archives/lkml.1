Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYIPXP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYIPXP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 19:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYIPXOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 19:14:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:11200 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYIPXOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 19:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qCfMvRQ3ynkqfBl+rDgYsd7s/0rGPR74MUbbyt+BieENwuiozF950ZYIuxpHFAP0nK
         DFOx/C/BntQvtdYSxfCf6nkkGglyXgICQAUcBxr3kJe6x+8smB0stwTPS4o76Q1Wxdfp
         FtOsElEBN5t0Z23o3ODqLf6HqBmeEHde027Sg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/5] acpi: add acpi_printk v3
Date: Tue, 16 Sep 2008 16:13:57 -0700
Message-Id: <1221606838-30246-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221606838-30246-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221606838-30246-1-git-send-email-yhlu.kernel@gmail.com>
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
