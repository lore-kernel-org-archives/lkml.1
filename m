Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYIPIy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYIPIy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYIPIyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:54:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:17181 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYIPIyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ky2MZsNgmQMVojuLYYUm+MVmNrfnPJW1oYBsvG0FQG3CwKRaR/1p/Vx6pK/d0TrIjy
         MXQYRperYrDyQ/LEAxqmHtErvf3EXrW3lo6/WvOHWAx/SpIXYcnRwLAmbg0hltA3CQ2F
         PXM3ZPETIEEbd9R6xu2/IAkxYDStmECYKh764=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 5/5] apci: dump slit v3
Date: Tue, 16 Sep 2008 01:52:54 -0700
Message-Id: <1221555174-30060-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221555174-30060-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221555174-30060-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: using boot_printk
v3: using acpi_printk

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
+	acpi_printk(KERN_LOG_DEBUG, KERN_DEBUG "ACPI: SLIT: nodes = %d\n", d);
+	for (i = 0; i < d; i++) {
+		for (j = 0; j < d; j++)  {
+			u8 val = slit->entry[d*i + j];
+			acpi_printk(KERN_LOG_DEBUG, " %d", val);
+		}
+		acpi_printk(KERN_LOG_DEBUG, "\n");
+	}
 	for (i = 0; i < d; i++) {
 		for (j = 0; j < d; j++)  {
 			u8 val = slit->entry[d*i + j];
