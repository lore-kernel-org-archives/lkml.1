Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYIQHMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYIQHMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 03:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYIQHK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 03:10:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:23335 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYIQHK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 03:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=toaFMsjISnaSrwKdJnXY4sDwfClLknKvQwSlhwRrTpraEfmtPp/JU2pHt+TjBduZji
         YpvgCZecNFkgV9m6PvsrdpK4+T0ko6z56KC7q9ItwBm4IqWbpcB4vqb5x8gKOi75iAjw
         a+EfXq0lZ+39+3FgFws0dn3pkSZPSXYFC1d1c=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/6] acpi: add KERN_ACPI v3
Date: Wed, 17 Sep 2008 00:10:13 -0700
Message-Id: <1221635415-14859-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com>
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
