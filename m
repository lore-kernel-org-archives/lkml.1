Return-Path: <linux-kernel-owner+w=401wt.eu-S934707AbYCFCbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707AbYCFCbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932524AbYCFCZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:25:12 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:52325 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbYCFCZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:25:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LJUEj1NLp8thDzjx2mUc6c4yWvThSvq6NP4dwmL0cCKUo0XP5fx8HxKx6c3gCaZ4euiVN8IY5O2QtFtjR3ClnE8wJTLrqGn7a/78VG/lQBo+dmCbgcjz7TYVPmr9cuYaaNRqfct140KjwAD8OZ6L5eq6dsew13v2Umi/GjeUf34=
Subject: [PATCH 13/16] watchdog: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:58 -0800
Message-Id: <1204770298.14154.49.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/watchdog/machzwd.c     |    2 +-
 drivers/watchdog/pcwd_usb.c    |    4 ++--
 drivers/watchdog/s3c2410_wdt.c |    8 ++++----
 drivers/watchdog/shwdt.c       |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index e6e07b4..6905135 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -141,7 +141,7 @@ static unsigned long next_heartbeat = 0;
 #ifndef ZF_DEBUG
 #	define dprintk(format, args...)
 #else
-#	define dprintk(format, args...) printk(KERN_DEBUG PFX ":%s:%d: " format, __FUNCTION__, __LINE__ , ## args)
+#	define dprintk(format, args...) printk(KERN_DEBUG PFX ":%s:%d: " format, __func__, __LINE__ , ## args)
 #endif
 

diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index 0f3fd6c..bf443d0 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -179,11 +179,11 @@ static void usb_pcwd_intr_done(struct urb *urb)
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 		return;
 	/* -EPIPE:  should clear the halt */
 	default:		/* error */
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 		goto resubmit;
 	}
 
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 5d1c15f..7645e88 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -144,7 +144,7 @@ static int s3c2410wdt_start(void)
 	}
 
 	DBG("%s: wdt_count=0x%08x, wtcon=%08lx\n",
-	    __FUNCTION__, wdt_count, wtcon);
+	    __func__, wdt_count, wtcon);
 
 	writel(wdt_count, wdt_base + S3C2410_WTDAT);
 	writel(wdt_count, wdt_base + S3C2410_WTCNT);
@@ -167,7 +167,7 @@ static int s3c2410wdt_set_heartbeat(int timeout)
 	count = timeout * freq;
 
 	DBG("%s: count=%d, timeout=%d, freq=%d\n",
-	    __FUNCTION__, count, timeout, freq);
+	    __func__, count, timeout, freq);
 
 	/* if the count is bigger than the watchdog register,
 	   then work out what we need to do (and if) we can
@@ -189,7 +189,7 @@ static int s3c2410wdt_set_heartbeat(int timeout)
 	tmr_margin = timeout;
 
 	DBG("%s: timeout=%d, divisor=%d, count=%d (%08x)\n",
-	    __FUNCTION__, timeout, divisor, count, count/divisor);
+	    __func__, timeout, divisor, count, count/divisor);
 
 	count /= divisor;
 	wdt_count = count;
@@ -355,7 +355,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	int ret;
 	int size;
 
-	DBG("%s: probe=%p\n", __FUNCTION__, pdev);
+	DBG("%s: probe=%p\n", __func__, pdev);
 
 	dev = &pdev->dev;
 	wdt_dev = &pdev->dev;
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index 61dde86..1277f7e 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -298,7 +298,7 @@ static int sh_wdt_mmap(struct file *file, struct vm_area_struct *vma)
 	if (io_remap_pfn_range(vma, vma->vm_start, addr >> PAGE_SHIFT,
 			       PAGE_SIZE, vma->vm_page_prot)) {
 		printk(KERN_ERR PFX "%s: io_remap_pfn_range failed\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EAGAIN;
 	}
 
-- 
1.5.4.GIT


