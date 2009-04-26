Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZDZO4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZDZO4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 10:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbZDZO4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 10:56:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:18886 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbZDZO4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 10:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=eiHlTk8WbQSaSlEumzBgkcGaA9ComdpF0vDDFObyzRgb7X3qRRd0J/53LE778IDKoz
         jQ2trXpd9BMfBihG1QUJRT5IPg3zTcBnndSkfvb/OKLb+/hp/AWFwpabrmFTOwHFqbQB
         RLt7e13SIoxPTDcCBc/oomQNdaaupEUvspnzA=
Message-ID: <49F47616.8040102@gmail.com>
Date: Sun, 26 Apr 2009 16:56:22 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] staging: scalar tests on pointers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RTUSBCmdThr_pid, TimerQThr_pid and MLMEThr_pid are pointers.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I think this is correct, right?

diff --git a/drivers/staging/rt3070/2870_main_dev.c b/drivers/staging/rt3070/2870_main_dev.c
index 401ddb0..6f405f9 100644
--- a/drivers/staging/rt3070/2870_main_dev.c
+++ b/drivers/staging/rt3070/2870_main_dev.c
@@ -976,7 +976,7 @@ VOID RT28xxThreadTerminate(
 		}
 	}
 
-	if (pObj->RTUSBCmdThr_pid >= 0)
+	if (pid_nr(pObj->RTUSBCmdThr_pid) >= 0)
 	{
 		printk("Terminate the RTUSBCmdThr_pid=%d!\n", pid_nr(pObj->RTUSBCmdThr_pid));
 		mb();
@@ -998,7 +998,7 @@ VOID RT28xxThreadTerminate(
 			pObj->RTUSBCmdThr_pid = NULL;
 		}
 	}
-	if (pObj->TimerQThr_pid >= 0)
+	if (pid_nr(pObj->TimerQThr_pid) >= 0)
 	{
 		POS_COOKIE pObj = (POS_COOKIE)pAd->OS_Cookie;
 
diff --git a/drivers/staging/rt3070/common/rtusb_io.c b/drivers/staging/rt3070/common/rtusb_io.c
index a6a52e3..aa6eecc 100644
--- a/drivers/staging/rt3070/common/rtusb_io.c
+++ b/drivers/staging/rt3070/common/rtusb_io.c
@@ -873,7 +873,7 @@ NDIS_STATUS	RTUSBEnqueueCmdFromNdis(
 	POS_COOKIE pObj = (POS_COOKIE) pAd->OS_Cookie;
 
 
-	if (pObj->RTUSBCmdThr_pid < 0)
+	if (pid_nr(pObj->RTUSBCmdThr_pid) < 0)
 		return (NDIS_STATUS_RESOURCES);
 
 	status = RTMPAllocateMemory((PVOID *)&cmdqelmt, sizeof(CmdQElmt));
diff --git a/drivers/staging/rt3070/rt2870.h b/drivers/staging/rt3070/rt2870.h
index d32a2bf..193bff4 100644
--- a/drivers/staging/rt3070/rt2870.h
+++ b/drivers/staging/rt3070/rt2870.h
@@ -567,18 +567,18 @@ VOID RTUSBBulkOutPsPollComplete(purbb_t pUrb, struct pt_regs *pt_regs);
 VOID RTUSBBulkRxComplete(purbb_t pUrb, struct pt_regs *pt_regs);
 
 
-#define RTUSBMlmeUp(pAd)	        \
-{								    \
+#define RTUSBMlmeUp(pAd)				\
+{							\
 	POS_COOKIE pObj = (POS_COOKIE) pAd->OS_Cookie;	\
-	if(pObj->MLMEThr_pid>0)		    \
-        up(&(pAd->mlme_semaphore)); \
+	if (pid_nr(pObj->MLMEThr_pid) > 0)		\
+		up(&(pAd->mlme_semaphore));		\
 }
 
-#define RTUSBCMDUp(pAd)	                \
-{									    \
+#define RTUSBCMDUp(pAd)					\
+{							\
 	POS_COOKIE pObj = (POS_COOKIE) pAd->OS_Cookie;	\
-	if(pObj->RTUSBCmdThr_pid>0)		    \
-	    up(&(pAd->RTUSBCmd_semaphore)); \
+	if (pid_nr(pObj->RTUSBCmdThr_pid) > 0)		\
+		up(&(pAd->RTUSBCmd_semaphore));		\
 }
 
 
