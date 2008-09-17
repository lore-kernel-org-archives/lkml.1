Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbYIQIaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbYIQIaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYIQI2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:28:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:23388 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbYIQI2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:28:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xB8siKUbqamD39djPMdZPBFaM3iO4ecX25he/OTSz3VFfOygMEYzPvY4KqKXWkebrs
         pK0OpjDTtL2GX86ntgpcIsIO1MNN5ci1rTL562D9L6yTScH7Slk7Qxl9bExWhzU4QMQL
         fMvm4+CrcO0oPGL1UuyENWUEJPtIku6nC4pmw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 5/6] apci: dump slit with printk(KERN_ACPI...)
Date: Wed, 17 Sep 2008 01:27:46 -0700
Message-Id: <1221640067-24389-6-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/acpi/numa.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/drivers/acpi/numa.c
===================================================================
--- linux-2.6.orig/drivers/acpi/numa.c
+++ linux-2.6/drivers/acpi/numa.c
@@ -150,6 +150,15 @@ static __init int slit_valid(struct acpi
 {
 	int i, j;
 	int d = slit->locality_count;
+	printk(KERN_DEBUG KERN_ACPI "ACPI: SLIT: nodes = %d\n", d);
+	for (i = 0; i < d; i++) {
+		printk(KERN_DEBUG KERN_ACPI "  ");
+		for (j = 0; j < d; j++)  {
+			u8 val = slit->entry[d*i + j];
+			printk(KERN_CONT KERN_ACPI " %d", val);
+		}
+		printk(KERN_CONT KERN_ACPI "\n");
+	}
 	for (i = 0; i < d; i++) {
 		for (j = 0; j < d; j++)  {
 			u8 val = slit->entry[d*i + j];
