Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYIRAUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYIRAUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 20:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYIRATO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 20:19:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:43250 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbYIRATM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 20:19:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pYy+38nFgB8LDtezxS4CrA+TyMnKC2WJ1bUaYpWLogEnXTFxCiByC/G14jofLUCPH5
         D9U1Fo9QhsfkTPe38uLUt5Hua46mkvZvbBmgkjufyNCZTWqGhnXCp96hUsj7T4oPVsca
         3NnDySGIHEPz0k7tfIRA3dsA9fzie/+krYpE8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/7] acpi: add KERN_ACPI v3
Date: Wed, 17 Sep 2008 17:18:28 -0700
Message-Id: <1221697112-21814-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221697112-21814-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221697112-21814-1-git-send-email-yhlu.kernel@gmail.com>
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
