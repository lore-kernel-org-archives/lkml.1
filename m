Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYHPChp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYHPChp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 22:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYHPChf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 22:37:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:54834 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYHPChe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 22:37:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fGuxO/w7yKJU4B75fTprbqaRsK903BNTfnR532APjbtCWmrTEru3fUxFCztqvp2Vhc
         7O5cUwqAew8e2bZIfaqV56XE/zqN2yuS+YwQYbSXivFK7EUEG6agSBpEVC6+S2kEmpAT
         uE7yXFgZh/GK3syw8t1xlLAeTjeOE1BlYV+pU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] pci: change msi-x vector to 32bit
Date: Fri, 15 Aug 2008 19:36:45 -0700
Message-Id: <1218854205-2375-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we are using 28bit pci (bus/dev/fn + 12 bits) as irq number, so the
cache for irq number should be 32 bit too.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

---
 drivers/scsi/qla2xxx/qla_def.h |    2 +-
 include/linux/pci.h            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/scsi/qla2xxx/qla_def.h
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_def.h
+++ linux-2.6/drivers/scsi/qla2xxx/qla_def.h
@@ -2109,7 +2109,7 @@ struct scsi_qla_host;
 
 struct qla_msix_entry {
 	int have_irq;
-	uint16_t msix_vector;
+	uint32_t msix_vector;
 	uint16_t msix_entry;
 };
 
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -730,7 +730,7 @@ enum pci_dma_burst_strategy {
 };
 
 struct msix_entry {
-	u16 	vector;	/* kernel uses to write allocated vector */
+	u32	vector;	/* kernel uses to write allocated vector */
 	u16	entry;	/* driver uses to specify entry, OS writes */
 };
 
