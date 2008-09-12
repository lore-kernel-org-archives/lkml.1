Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbYILSSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbYILSSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 14:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYILSSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 14:18:24 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:45251 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYILSSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 14:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=brmKglaXNSwmAGxv5kJTsERxWDBsIh287G//TYRvK9KKO4396phVdjYZANoqxuI996
         XyEOvSGn18hG3rf0+eItuNnn/wLfabgATC9zHB9zRsOmec0QMuDH8J90L8eYYEkBDBzz
         tgoCOI4wfFKj675/zWZwLNHSixmlpAzz6xoFo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] apci: dump slit
Date: Fri, 12 Sep 2008 11:17:48 -0700
Message-Id: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
+	printk(KERN_DEBUG "ACPI: SLIT: nodes = %d\n", d);
+	for (i = 0; i < d; i++) {
+		for (j = 0; j < d; j++)  {
+			u8 val = slit->entry[d*i + j];
+			printk(" %d", val);
+		}
+		printk("\n");
+	}
 	for (i = 0; i < d; i++) {
 		for (j = 0; j < d; j++)  {
 			u8 val = slit->entry[d*i + j];
