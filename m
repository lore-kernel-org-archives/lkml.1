Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbYIOIGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbYIOIGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 04:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYIOIGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 04:06:22 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:60330 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbYIOIGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 04:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SrVokI45RK/mXSiGK1CR3Tfy7Eo/1ttDrMDSNObTJFUKk2IGiGLk5LVxLRiEZ+P7IL
         WaHUr+hz7p3wnNd/eR90l3+ONxZhSAk7CeRMLgJnLMStKcAQQo1D0t5JUSEuRvdQcj/S
         Kw3wZetxSoCJazqaQPsa/0slIpLsy0lhiKZyY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] apci: dump slit v2
Date: Mon, 15 Sep 2008 01:05:44 -0700
Message-Id: <1221465944-30938-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: using boot_printk

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
+	boot_printk(BOOT_VERBOSE, KERN_DEBUG "ACPI: SLIT: nodes = %d\n", d);
+	for (i = 0; i < d; i++) {
+		for (j = 0; j < d; j++)  {
+			u8 val = slit->entry[d*i + j];
+			boot_printk(BOOT_VERBOSE, " %d", val);
+		}
+		boot_printk(BOOT_VERBOSE, "\n");
+	}
 	for (i = 0; i < d; i++) {
 		for (j = 0; j < d; j++)  {
 			u8 val = slit->entry[d*i + j];
