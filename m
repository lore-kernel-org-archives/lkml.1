Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbYIPIyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbYIPIyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYIPIyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:54:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:17181 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYIPIyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ax0EKrW/8uZPFMfwdryCC+AncGCfDqdRv7MTeLFidVmsofBOdRqfxvDGmzTmBeK+zm
         Rtd8Cres4EiPeEeONwW2osLDT+OIe6YN3vEMjOJlwepAWro6LT11ZccP6MFM1uTpev2F
         iBXfhMqNKacmuT/hA+hmrs2i9sLh8vtd/0b0c=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/5] pci: add pci_printk v2
Date: Tue, 16 Sep 2008 01:52:51 -0700
Message-Id: <1221555174-30060-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221555174-30060-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221555174-30060-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use DEFINE_LOGLEVEL_SETUP to set loglevel for pci
v2: two lines only

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
 
+DEFINE_LOGLEVEL_SETUP(pci);
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
 
+DECLARE_LOGLEVEL(pci);
+
 /* pci_slot represents a physical slot */
 struct pci_slot {
 	struct pci_bus *bus;		/* The bus this slot is on */
