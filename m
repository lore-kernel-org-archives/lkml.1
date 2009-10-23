Return-Path: <linux-kernel-owner+w=401wt.eu-S1752509AbZJWQwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbZJWQwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 12:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZJWQwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 12:52:32 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50296 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZJWQwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 12:52:32 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: [PATCH] Staging: Android logger: fix compiling error
Date: Sat, 24 Oct 2009 00:52:21 +0800
Message-Id: <1256316741-14053-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling Android staging driver for PXA3XX machine, met following error:

  CC      drivers/staging/android/logger.o
drivers/staging/android/logger.c: In function 'logger_read':
drivers/staging/android/logger.c:165: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/staging/android/logger.c:165: error: (Each undeclared identifier is reported only once
drivers/staging/android/logger.c:165: error: for each function it appears in.)
drivers/staging/android/logger.c:178: error: implicit declaration of function 'signal_pending'
drivers/staging/android/logger.c:183: error: implicit declaration of function 'schedule'
drivers/staging/android/logger.c: In function 'logger_aio_write':
drivers/staging/android/logger.c:325: error: dereferencing pointer to incomplete type
drivers/staging/android/logger.c:333: error: dereferencing pointer to incomplete type
drivers/staging/android/logger.c:334: error: dereferencing pointer to incomplete type
drivers/staging/android/logger.c:337: error: dereferencing pointer to incomplete type
drivers/staging/android/logger.c:360: error: dereferencing pointer to incomplete type
drivers/staging/android/logger.c:363: error: dereferencing pointer to incomplete type
drivers/staging/android/logger.c:370: error: increment of pointer to unknown structure
drivers/staging/android/logger.c:370: error: arithmetic on pointer to an incomplete type
drivers/staging/android/logger.c:377: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
make[3]: *** [drivers/staging/android/logger.o] Error 1

Compiling broke since commit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184
    headers: remove sched.h from poll.h

Adding <linux/sched.h> to fix this compiling bug.

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/staging/android/logger.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 6c10b45..a8eb7d1 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -21,6 +21,7 @@
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/uaccess.h>
+#include <linux/sched.h>
 #include <linux/poll.h>
 #include <linux/time.h>
 #include "logger.h"
-- 
1.6.3.3

