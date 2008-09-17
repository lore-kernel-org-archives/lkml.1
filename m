Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYIQBQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYIQBQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 21:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYIQBO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 21:14:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:52946 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYIQBO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 21:14:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mN7f523k+BkRJO1hHt5OJRROP/PxaWfPSbMbI1iZDuc3XU7pSkOKo0B+rT+GTGgohk
         n/mRShIO+bFM7wQhUwezw54OYKlciIC4UHZFEnyrq3pJGeONPseIZG+CsT4xB0VKrBqi
         sMn+Lhq8Gfvh1h5k/VD61LURh8PJCbYcSPF+I=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 5/5] apci: dump slit v4
Date: Tue, 16 Sep 2008 18:14:13 -0700
Message-Id: <1221614053-28804-6-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221614053-28804-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221614053-28804-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: using boot_printk
v3: using acpi_printk
v4: using prink(KERN_DEBUG KERN_ACPI ... )

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/acpi/numa.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/drivers/acpi/numa.c
===================================================================
--- linux-2.6.orig/drivers/acpi/numa.c
+++ linux-2.6/drivers/acpi/numa.c
@@ -150,6 +150,14 @@ static __init int slit_valid(struct acpi
 {
 	int i, j;
 	int d = slit->locality_count;
+	printk(KERN_DEBUG KERN_ACPI "ACPI: SLIT: nodes = %d\n", d);
+	for (i = 0; i < d; i++) {
+		for (j = 0; j < d; j++)  {
+			u8 val = slit->entry[d*i + j];
+			printk(KERN_CONT KERN_ACPI " %d", val);
+		}
+		printk(KERN_CONT KERN_ACPI "\n");
+	}
 	for (i = 0; i < d; i++) {
 		for (j = 0; j < d; j++)  {
 			u8 val = slit->entry[d*i + j];
