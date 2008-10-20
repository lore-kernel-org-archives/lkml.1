Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbYJTWpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbYJTWpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYJTWp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:45:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:49267 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbYJTWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:45:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=oZBIjDEIrm/3jD/nD5IibyMQNAP4beLYGhrOO1v16t99ubA2xbTPlQ9e+2U2xQxzdx
         woqZWdO8GmHBAYKHYmGZ9GyWfNC9ehWQHYF5uJcxy+cQHRqPuCv+jhOW0uI1U0IsXcKs
         NMW+ZXLWbB0/VtWglPgFLwC/oVdlJrJr2WUp8=
Subject: [PATCH] staging: remove remaining uses of __FUNCTION__
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 15:45:25 -0700
Message-Id: <1224542725.31861.224.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
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



