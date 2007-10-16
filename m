Return-Path: <linux-kernel-owner+w=401wt.eu-S934058AbXJPRTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058AbXJPRTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933466AbXJPRSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:18:50 -0400
Received: from 193.4.221.87.dynamic.jazztel.es ([87.221.4.193]:59844 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760018AbXJPRSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:18:49 -0400
Date: Tue, 16 Oct 2007 19:18:52 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] Videopix Frame Grabber: Convert device_lock_sem to mutex
Message-ID: <20071016171851.GB31288@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Videopix Frame Grabber: Convert the semaphore device_lock_sem to the
mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/sbus/char/vfc.h b/drivers/sbus/char/vfc.h
index 63941a2..f1aa138 100644
--- a/drivers/sbus/char/vfc.h
+++ b/drivers/sbus/char/vfc.h
@@ -126,7 +126,7 @@ struct vfc_dev {
 	volatile struct vfc_regs __iomem *regs;
 	struct vfc_regs *phys_regs;
 	unsigned int control_reg;
-	struct semaphore device_lock_sem;
+	struct mutex device_lock_mtx;
 	int instance;
 	int busy;
 	unsigned long which_io;
diff --git a/drivers/sbus/char/vfc_dev.c b/drivers/sbus/char/vfc_dev.c
index 9269f7f..e7a1642 100644
--- a/drivers/sbus/char/vfc_dev.c
+++ b/drivers/sbus/char/vfc_dev.c
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/mm.h>
 
 #include <asm/openprom.h>
@@ -54,12 +55,12 @@ static unsigned char saa9051_init_array[VFC_SAA9051_NR] = {
 
 void vfc_lock_device(struct vfc_dev *dev)
 {
-	down(&dev->device_lock_sem);
+	mutex_lock(&dev->device_lock_mtx);
 }
 
 void vfc_unlock_device(struct vfc_dev *dev)
 {
-	up(&dev->device_lock_sem);
+	mutex_unlock(&dev->device_lock_mtx);
 }

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             If liberty means anything at all, it means the
           right to tell people what they do not want to hear
                            (George Orwell)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
