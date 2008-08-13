Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYHMAdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYHMAdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbYHMA12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:27:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:49095 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbYHMA10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=o3NnRK2fHmBrbd6LzXpsc97uP0MDhMNYah2AQjIjmOv9RWhz9SJkyByxF/Aq33R6fu
         D+oGUFAWhmBWWN5mF8tMAxrSF6bKZUWMnH98OhlQzCeR9z/GjY5mYSEIaX3biMHVLdPl
         t3VW9C2hDFY6RlkFTHrG3iaDKyV1ytLgmjUFA=
Subject: [PATCH 21/22] byteorder: fix direct byteswap includes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:27:15 -0700
Message-Id: <1218587236.30194.95.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, this needs to wait until all arches have moved to the new
headers.  It is a prerequisite for the removal of the old byteorder
headers (patch 22).

 arch/avr32/mach-at32ap/include/mach/io.h |    3 +--
 drivers/media/dvb/ttpci/av7110.c         |    2 +-
 drivers/media/video/cx18/cx18-driver.h   |    2 +-
 drivers/media/video/ivtv/ivtv-driver.h   |    2 +-
 drivers/media/video/vpx3220.c            |    2 +-
 kernel/rcupreempt.c                      |    2 +-
 tests/rcutorture.c                       |    2 +-
 7 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/avr32/mach-at32ap/include/mach/io.h b/arch/avr32/mach-at32ap/include/mach/io.h
index 4ec6abc..22ea79b 100644
--- a/arch/avr32/mach-at32ap/include/mach/io.h
+++ b/arch/avr32/mach-at32ap/include/mach/io.h
@@ -1,8 +1,7 @@
 #ifndef __ASM_AVR32_ARCH_AT32AP_IO_H
 #define __ASM_AVR32_ARCH_AT32AP_IO_H
 
-/* For "bizarre" halfword swapping */
-#include <linux/byteorder/swabb.h>
+#include <linux/swab.h>
 
 #if defined(CONFIG_AP700X_32_BIT_SMC)
 # define __swizzle_addr_b(addr)	(addr ^ 3UL)
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 25a1e39..351dea5 100644
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
index 4801bc7..928388d 100644
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
index ab287b4..966c74d 100644
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
index 2782793..f0289b9 100644
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
diff --git a/tests/rcutorture.c b/tests/rcutorture.c
index 90b5b12..85cb905 100644
--- a/tests/rcutorture.c
+++ b/tests/rcutorture.c
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
1.6.0.rc2.233.g3cb9d


