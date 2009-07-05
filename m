Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZGELKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZGELKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 07:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbZGELKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 07:10:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:33109 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZGELKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 07:10:17 -0400
Date: Sun, 5 Jul 2009 11:09:31 GMT
From: "tip-bot for Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, rjw@sisk.pl
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rjw@sisk.pl
In-Reply-To: <200907050022.35117.rjw@sisk.pl>
References: <200907050022.35117.rjw@sisk.pl>
Subject: [tip:irq/core] genirq: Fix comment describing suspend_device_irqs()
Message-ID: <tip-c71320d0c445e01555a86fa6523609db47eeaef6@git.kernel.org>
Git-Commit-ID: c71320d0c445e01555a86fa6523609db47eeaef6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 05 Jul 2009 11:09:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c71320d0c445e01555a86fa6523609db47eeaef6
Gitweb:     http://git.kernel.org/tip/c71320d0c445e01555a86fa6523609db47eeaef6
Author:     Rafael J. Wysocki <rjw@sisk.pl>
AuthorDate: Sun, 5 Jul 2009 00:22:34 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 5 Jul 2009 13:07:00 +0200

genirq: Fix comment describing suspend_device_irqs()

The kerneldoc comment describing suspend_device_irqs() is currently
misleading, because generally the function doesn't really disable
interrupt lines at the chip level.  Replace it with a more accurate
one.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
LKML-Reference: <200907050022.35117.rjw@sisk.pl>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/irq/pm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 638d8be..a0bb09e 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -15,10 +15,10 @@
 /**
  * suspend_device_irqs - disable all currently enabled interrupt lines
  *
- * During system-wide suspend or hibernation device interrupts need to be
- * disabled at the chip level and this function is provided for this purpose.
- * It disables all interrupt lines that are enabled at the moment and sets the
- * IRQ_SUSPENDED flag for them.
+ * During system-wide suspend or hibernation device drivers need to be prevented
+ * from receiving interrupts and this function is provided for this purpose.
+ * It marks all interrupt lines in use, except for the timer ones, as disabled
+ * and sets the IRQ_SUSPENDED flag for each of them.
  */
 void suspend_device_irqs(void)
 {
