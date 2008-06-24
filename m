Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYFXAKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYFXAKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYFXAJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:09:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:52740 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbYFXAJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rlTqfVa1kxTNxBBA7e+vndYp2MYDvXYi5iEygeiq2j5CiuJRoZE4W54gVAanRsJKdy
         vbMD8ETVEsZMqPoJxY4859fiJszy0qTRWeL002NwEvGu9asxsMwxSfXxQoUgS7CkI+nt
         +boooAzuVeib0Jz7ug8oVFywz0PRGmK53j5pY=
Subject: [PATCH 4/6] byteorder: fix direct byteswap includes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 17:09:09 -0700
Message-Id: <1214266149.21092.45.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/dvb/ttpci/av7110.c       |    2 +-
 drivers/media/video/cx18/cx18-driver.h |    2 +-
 drivers/media/video/ivtv/ivtv-driver.h |    2 +-
 drivers/media/video/vpx3220.c          |    2 +-
 kernel/rcupreempt.c                    |    2 +-
 kernel/rcutorture.c                    |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index f05d43d..757196f 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -36,7 +36,6 @@
 #include <linux/fs.h>
 #include <linux/timer.h>
 #include <linux/poll.h>
-#include <linux/byteorder/swabb.h>
 #include <linux/smp_lock.h>
 
 #include <linux/kernel.h>
@@ -53,6 +52,7 @@
 #include <linux/kthread.h>
 #include <asm/unaligned.h>
 
+#include <asm/byteorder.h>
 #include <asm/system.h>
 
 #include <linux/dvb/frontend.h>
diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
index de14ab5..ce7bda5 100644
--- a/drivers/media/video/cx18/cx18-driver.h
+++ b/drivers/media/video/cx18/cx18-driver.h
@@ -38,10 +38,10 @@
 #include <linux/i2c-algo-bit.h>
 #include <linux/list.h>
 #include <linux/unistd.h>
-#include <linux/byteorder/swab.h>
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <asm/byteorder.h>
 
 #include <linux/dvb/video.h>
 #include <linux/dvb/audio.h>
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index 9d23b1e..a77804e 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -49,11 +49,11 @@
 #include <linux/i2c-algo-bit.h>
 #include <linux/list.h>
 #include <linux/unistd.h>
-#include <linux/byteorder/swab.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <asm/byteorder.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
diff --git a/drivers/media/video/vpx3220.c b/drivers/media/video/vpx3220.c
index 3529302..5920a9e 100644
--- a/drivers/media/video/vpx3220.c
+++ b/drivers/media/video/vpx3220.c
@@ -24,7 +24,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 
-#include <linux/byteorder/swab.h>
+#include <asm/byteorder.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 5e02b77..8bd89ca 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -54,9 +54,9 @@
 #include <linux/cpu.h>
 #include <linux/random.h>
 #include <linux/delay.h>
-#include <linux/byteorder/swabb.h>
 #include <linux/cpumask.h>
 #include <linux/rcupreempt_trace.h>
+#include <asm/byteorder.h>
 
 /*
  * Macro that prevents the compiler from reordering accesses, but does
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 33acc42..e50ec0d 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -42,10 +42,10 @@
 #include <linux/freezer.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
-#include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
+#include <asm/byteorder.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
-- 
1.5.6.290.gc4e15


