Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbZFNVcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbZFNVcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 17:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758002AbZFNVby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 17:31:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55150 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142AbZFNVbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 17:31:53 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Jon Masters <jcm@redhat.com>
Subject: [PATCH -rt] include linux/delay.h in hwlat_detector
Date: Sun, 14 Jun 2009 23:31:42 +0200
Message-Id: <1245015102-22057-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This broke when compiling on i386 without X86_LOCAL_APIC because then
arch/x86/include/asm/smp.h doesn't include asm/apic.h which in turn includes
linux/delay.h.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jon Masters <jcm@redhat.com>
---

diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
index dbd9661..e02d8e1 100644
--- a/drivers/misc/hwlat_detector.c
+++ b/drivers/misc/hwlat_detector.c
@@ -49,6 +49,7 @@
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
 #include <linux/version.h>
+#include <linux/delay.h>
 
 #define BUF_SIZE_DEFAULT	262144UL		/* 8K*(sizeof(entry)) */
 #define BUF_FLAGS		(RB_FL_OVERWRITE)	/* no block on full */
