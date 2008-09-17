Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYIQBPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYIQBPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 21:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYIQBOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 21:14:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:52946 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYIQBOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 21:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IZmhYJLF81yebXxRt/lHeFMSGTbpOhoDm3akloLw1z1zHUy5Mb1z9PEn/0daGVIEBk
         CJ31sZaffNUJmW9sCQfpu0b6UUCw6OvBRuspPJW9ThRqWTd7CnC6HJmNteC8LVvEzgSE
         93ldnUJO5tAxgWxQAdBQReI3Yc25O62vGBmeM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/5] pci: add pci_printk v4
Date: Tue, 16 Sep 2008 18:14:10 -0700
Message-Id: <1221614053-28804-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221614053-28804-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221614053-28804-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use DEFINE_LOGLEVEL_SETUP to set loglevel for pci
v2: two lines only
v3: use <pci, "pci:"> instead
v4: use KERN_PCI

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/pci/pci.c   |    2 ++
 include/linux/pci.h |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1953,6 +1953,8 @@ static int __devinit pci_setup(char *str
 }
 early_param("pci", pci_setup);
 
+DEFINE_LOGLEVEL_SETUP(pci, KERN_PCI, "pci:");
+
 device_initcall_sync(pci_init);
 
 EXPORT_SYMBOL(pci_reenable_device);
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -55,6 +55,8 @@
 /* Include the ID list */
 #include <linux/pci_ids.h>
 
+#define KERN_PCI "<pci>"
+
 /* pci_slot represents a physical slot */
 struct pci_slot {
 	struct pci_bus *bus;		/* The bus this slot is on */
