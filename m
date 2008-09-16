Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYIPSDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYIPSDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757105AbYIPSCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:02:14 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38051 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065AbYIPSCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WsnZZzZ9gOmls8OzGwejfEHSW2hFGyLqz57EfBzoxFwQt020lgvBFUCZSZcd3jBIhn
         TTsdFbyVhNzgAfaPBVjOgmbcmIqVjH5IZtO2bosucPpVaytu7Pf09keKXtrpXbbClcjH
         Bqh+NZfEm3Nud4B8s9UuM8ISBGel+7taNTLNQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/5] acpi: add acpi_printk v2
Date: Tue, 16 Sep 2008 11:01:24 -0700
Message-Id: <1221588085-30578-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221588085-30578-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221588085-30578-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use DEFINE_LOGLEVEL_SETUP to set loglevel for acpi
v2: use <acpi, "acpi:"> instead

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
 
+DEFINE_LOGLEVEL_SETUP(acpi, "acpi:");
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
 
+DECLARE_LOGLEVEL(acpi);
 
 enum acpi_irq_model_id {
 	ACPI_IRQ_MODEL_PIC = 0,
