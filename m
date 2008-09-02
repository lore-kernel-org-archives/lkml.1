Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYIBXL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYIBXL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 19:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYIBXLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 19:11:19 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:38270 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbYIBXLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z8+w8QaTPCFcp02F65fgsYDzaHXX5tbGIwvqV14f3qF88CfDnsDdx7RT5sq4G8gySz
         +sOSjp9+3tha+/3XMHCHn+7VJi8P58xlrVD+cC/S1TnjSBE8IHRSBzCTfMNYak/D8woH
         c1kofL3Y1Xo2hZHdBM5oGtPTIK+mog2TLML/k=
Subject: [BUILDFIX] byteorder: remove direct byteorder includes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, v4l <video4linux-list@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200809022142.04578.hverkuil@xs4all.nl>
References: <1218324197.24441.20.camel@brick>
	 <1220380552.2137.3.camel@brick> <1220381401.2137.6.camel@brick>
	 <200809022142.04578.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 16:11:15 -0700
Message-Id: <1220397075.2137.13.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the functionality has been collected in linux/swab.h

Needed to prevent build breakage as arches start moving over
to the new byteorder implementation. Ensure that each implementation
offers all byte-swapping methods to avoid build breakage when only
some arches are converted.

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Tested on a converted(ARM) and an unconverted(x86) arch.

 drivers/media/dvb/ttpci/av7110.c        |    2 +-
 drivers/media/video/cx18/cx18-driver.h  |    2 +-
 drivers/media/video/ivtv/ivtv-driver.h  |    2 +-
 drivers/media/video/vpx3220.c           |    3 +--
 include/linux/byteorder/big_endian.h    |    1 +
 include/linux/byteorder/little_endian.h |    1 +
 kernel/rcupreempt.c                     |    2 +-
 tests/rcutorture.c                      |    2 +-
 8 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index c0a1746..deb3829 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -36,7 +36,6 @@
 #include <linux/fs.h>
 #include <linux/timer.h>
 #include <linux/poll.h>
-#include <linux/byteorder/swabb.h>
 #include <linux/smp_lock.h>
 
 #include <linux/kernel.h>
@@ -52,6 +51,7 @@
 #include <linux/i2c.h>
 #include <linux/kthread.h>
 #include <asm/unaligned.h>
+#include <asm/byteorder.h>
 
 #include <asm/system.h>
 
diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
index 2635989..bd94d77 100644
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
index 2ceb522..99c3e7a 100644
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
index 3529302..256f77c 100644
--- a/drivers/media/video/vpx3220.c
+++ b/drivers/media/video/vpx3220.c
@@ -24,8 +24,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 
-#include <linux/byteorder/swab.h>
-
+#include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
diff --git a/include/linux/byteorder/big_endian.h b/include/linux/byteorder/big_endian.h
index 44f95b9..1cba3f3 100644
--- a/include/linux/byteorder/big_endian.h
+++ b/include/linux/byteorder/big_endian.h
@@ -10,6 +10,7 @@
 
 #include <linux/types.h>
 #include <linux/byteorder/swab.h>
+#include <linux/byteorder/swabb.h>
 
 #define __constant_htonl(x) ((__force __be32)(__u32)(x))
 #define __constant_ntohl(x) ((__force __u32)(__be32)(x))
diff --git a/include/linux/byteorder/little_endian.h b/include/linux/byteorder/little_endian.h
index 4cc170a..cedc1b5 100644
--- a/include/linux/byteorder/little_endian.h
+++ b/include/linux/byteorder/little_endian.h
@@ -10,6 +10,7 @@
 
 #include <linux/types.h>
 #include <linux/byteorder/swab.h>
+#include <linux/byteorder/swabb.h>
 
 #define __constant_htonl(x) ((__force __be32)___constant_swab32((x)))
 #define __constant_ntohl(x) ___constant_swab32((__force __be32)(x))
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index ca4bbbe..59236e8 100644
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
  * PREEMPT_RCU data structures.
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
1.6.0.1.400.ga23d3



