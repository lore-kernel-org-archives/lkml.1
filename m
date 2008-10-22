Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbYJVRn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbYJVRn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYJVRev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:34:51 -0400
Received: from kroah.org ([198.145.64.141]:53095 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757892AbYJVRet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:34:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/42] Staging: remove remaining uses of __FUNCTION__
Date: Wed, 22 Oct 2008 10:29:09 -0700
Message-Id: <1224696563-5170-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/usbip/usbip_common.c  |    2 +-
 drivers/staging/wlan-ng/wlan_compat.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index e64918f..72e2092 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -221,7 +221,7 @@ static void usbip_dump_request_type(__u8 rt)
 static void usbip_dump_usb_ctrlrequest(struct usb_ctrlrequest *cmd)
 {
 	if (!cmd) {
-		printk("      %s : null pointer\n", __FUNCTION__);
+		printk("      %s : null pointer\n", __func__);
 		return;
 	}
 
diff --git a/drivers/staging/wlan-ng/wlan_compat.h b/drivers/staging/wlan-ng/wlan_compat.h
index 1702657..59dfa8f 100644
--- a/drivers/staging/wlan-ng/wlan_compat.h
+++ b/drivers/staging/wlan-ng/wlan_compat.h
@@ -245,11 +245,11 @@ typedef int64_t		INT64;
 #  define preempt_count() (0UL)
 #endif
 
-#define WLAN_LOG_ERROR(x,args...) printk(KERN_ERR "%s: " x , __FUNCTION__ , ##args);
+#define WLAN_LOG_ERROR(x,args...) printk(KERN_ERR "%s: " x , __func__ , ##args);
 
-#define WLAN_LOG_WARNING(x,args...) printk(KERN_WARNING "%s: " x , __FUNCTION__ , ##args);
+#define WLAN_LOG_WARNING(x,args...) printk(KERN_WARNING "%s: " x , __func__ , ##args);
 
-#define WLAN_LOG_NOTICE(x,args...) printk(KERN_NOTICE "%s: " x , __FUNCTION__ , ##args);
+#define WLAN_LOG_NOTICE(x,args...) printk(KERN_NOTICE "%s: " x , __func__ , ##args);
 
 #define WLAN_LOG_INFO(args... ) printk(KERN_INFO args)
 
@@ -265,7 +265,7 @@ typedef int64_t		INT64;
 	#define DBFENTER { if ( WLAN_DBVAR >= 5 ){ WLAN_LOG_DEBUG(3,"---->\n"); } }
 	#define DBFEXIT  { if ( WLAN_DBVAR >= 5 ){ WLAN_LOG_DEBUG(3,"<----\n"); } }
 
-	#define WLAN_LOG_DEBUG(l,x,args...) if ( WLAN_DBVAR >= (l)) printk(KERN_DEBUG "%s(%lu): " x ,  __FUNCTION__, (preempt_count() & PREEMPT_MASK), ##args );
+	#define WLAN_LOG_DEBUG(l,x,args...) if ( WLAN_DBVAR >= (l)) printk(KERN_DEBUG "%s(%lu): " x ,  __func__, (preempt_count() & PREEMPT_MASK), ##args );
 #else
 	#define WLAN_ASSERT(c)
 	#define WLAN_HEX_DUMP( l, s, p, n)
-- 
1.6.0.2

