Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbYBNPmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbYBNPmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbYBNPj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:39:27 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:49929 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753464AbYBNPjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:14 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
Subject: [PATCH 13/14] kernel/irq/spurious.c: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:51 +0200
Message-Id: <1203003412-11594-14-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: y
References: y
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 kernel/irq/spurious.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index a6b2bc8..088dabb 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -6,6 +6,7 @@
  * This file contains spurious interrupt handling.
  */
 
+#include <linux/jiffies.h>
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
@@ -179,7 +180,7 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		 * otherwise the couter becomes a doomsday timer for otherwise
 		 * working systems
 		 */
-		if (jiffies - desc->last_unhandled > HZ/10)
+		if (time_after(jiffies, desc->last_unhandled + HZ/10))
 			desc->irqs_unhandled = 1;
 		else
 			desc->irqs_unhandled++;
-- 
1.5.3.7

