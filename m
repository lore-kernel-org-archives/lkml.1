Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYIPB3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYIPB3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 21:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYIPB3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 21:29:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:8952 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYIPB27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 21:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Pz2giSNpd+Boak0mqCS0mTr2ybIepTAV6BYZPURFByH47Vy6LoEhkteGN/qas+nTWn
         klQeTwSDzvE5zUn/JN31ISH/ykqIFiRJ542sxxgdPjM9tXqm6PqdYXZqkXkml2Mk6agn
         xqR7AMiv6y3gfFisGHJxszQpmaZjH7oYEnGz4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/3] pci: add pci_printk
Date: Mon, 15 Sep 2008 18:28:21 -0700
Message-Id: <1221528502-4945-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221528502-4945-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221528502-4945-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use DEFINE_LOGLEVEL_SETUP to set loglevel for pci

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/pci/pci.c   |    7 +++++++
 include/linux/pci.h |    6 ++++++
 2 files changed, 13 insertions(+)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1953,6 +1953,13 @@ static int __devinit pci_setup(char *str
 }
 early_param("pci", pci_setup);
 
+static void __init setup_loglevel_pci(char *str)
+{
+	get_option(&str, &loglevel_pci);
+}
+
+DEFINE_LOGLEVEL_SETUP(pci, "pci:", setup_loglevel_pci);
+
 device_initcall_sync(pci_init);
 
 EXPORT_SYMBOL(pci_reenable_device);
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -55,6 +55,12 @@
 /* Include the ID list */
 #include <linux/pci_ids.h>
 
+extern int loglevel_pci;
+#define pci_printk(v, s, a...) do {        \
+		if ((v) <= loglevel_pci)  \
+			printk(s, ##a);    \
+	} while (0)
+
 /* pci_slot represents a physical slot */
 struct pci_slot {
 	struct pci_bus *bus;		/* The bus this slot is on */
