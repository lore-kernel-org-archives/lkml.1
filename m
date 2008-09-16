Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYIPIyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYIPIyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYIPIyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:54:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:23702 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYIPIyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZbJfuQhY0CCnHYPVMAzOvvo8eRb2SVymLbLD0im2Qga39D9yJSoiF96rz5Y9W9sVP5
         k7bRDY3VvUrEqhM22U3AFK4VMx5caA5UoKUH+iy1b94dev5BsiFRtMoS/GqDhTwS7ADv
         h9AtiF8iBsxIJ+fUy+Kt1xMe31oM4mCJElpX4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/5] acpi: add acpi_printk
Date: Tue, 16 Sep 2008 01:52:53 -0700
Message-Id: <1221555174-30060-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221555174-30060-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221555174-30060-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use DEFINE_LOGLEVEL_SETUP to set loglevel for acpi

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
 
+DEFINE_LOGLEVEL_SETUP(acpi);
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
