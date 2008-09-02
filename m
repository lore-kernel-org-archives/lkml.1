Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbYIBSuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbYIBSuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 14:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYIBSuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 14:50:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:31714 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbYIBSuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 14:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VWuQYFtuYV7J9lWhhu5y0ETL4MpqMa40yAFpclQPS+Y01dRWkjDBjzmR8RV6TDZmUc
         /TOWJlhIpVZlMYmixAbVqVVlh3pVAW3yWsf2gEcZz1qqAwlNGSZ9eSX8OCiwaYY8TSPB
         xiXiBQ1/umjh649xk8QydN36WDbx3QAIgMW9M=
Subject: [BUILDFIX] byteorder: remove direct byteorder includes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, v4l <video4linux-list@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <1220380552.2137.3.camel@brick>
References: <1218324197.24441.20.camel@brick>
	 <200808301436.22322.hverkuil@xs4all.nl>  <1220380552.2137.3.camel@brick>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 11:50:00 -0700
Message-Id: <1220381401.2137.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the functionality has been collected in linux/swab.h

Needed to prevent build brakage as arches start moving over
to the new byteorder implementation.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Sorry, I only sent you half-a-patch in my last message, this is the
full patch needed.

 drivers/media/dvb/ttpci/av7110.c       |    2 +-
 drivers/media/video/cx18/cx18-driver.h |    2 +-
 drivers/media/video/ivtv/ivtv-driver.h |    2 +-
 drivers/media/video/vpx3220.c          |    2 +-
 kernel/rcupreempt.c                    |    2 +-
 tests/rcutorture.c                     |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110.c
b/drivers/media/dvb/ttpci/av7110.c
index c0a1746..792a175 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -36,7 +36,7 @@
 #include <linux/fs.h>
 #include <linux/timer.h>
 #include <linux/poll.h>
-#include <linux/byteorder/swabb.h>
+#include <linux/swab.h>
 #include <linux/smp_lock.h>
 
 #include <linux/kernel.h>
diff --git a/drivers/media/video/cx18/cx18-driver.h
b/drivers/media/video/cx18/cx18-driver.h
index 2635989..8787a5f 100644
--- a/drivers/media/video/cx18/cx18-driver.h
+++ b/drivers/media/video/cx18/cx18-driver.h
@@ -38,7 +38,7 @@
 #include <linux/i2c-algo-bit.h>
 #include <linux/list.h>
 #include <linux/unistd.h>
-#include <linux/byteorder/swab.h>
+#include <linux/swab.h>
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
diff --git a/drivers/media/video/ivtv/ivtv-driver.h
b/drivers/media/video/ivtv/ivtv-driver.h
index 2ceb522..2213473 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -49,7 +49,7 @@
 #include <linux/i2c-algo-bit.h>
 #include <linux/list.h>
 #include <linux/unistd.h>
-#include <linux/byteorder/swab.h>
+#include <linux/swab.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
diff --git a/drivers/media/video/vpx3220.c
b/drivers/media/video/vpx3220.c
index 3529302..6828411 100644
--- a/drivers/media/video/vpx3220.c
+++ b/drivers/media/video/vpx3220.c
@@ -24,7 +24,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 
-#include <linux/byteorder/swab.h>
+#include <linux/swab.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index ca4bbbe..494d0e8 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -54,7 +54,7 @@
 #include <linux/cpu.h>
 #include <linux/random.h>
 #include <linux/delay.h>
-#include <linux/byteorder/swabb.h>
+#include <linux/swab.h>
 #include <linux/cpumask.h>
 #include <linux/rcupreempt_trace.h>
 
diff --git a/tests/rcutorture.c b/tests/rcutorture.c
index 90b5b12..67856af 100644
--- a/tests/rcutorture.c
+++ b/tests/rcutorture.c
@@ -42,7 +42,7 @@
 #include <linux/freezer.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
-#include <linux/byteorder/swabb.h>
+#include <linux/swab.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
-- 
1.6.0.1.400.ga23d3



