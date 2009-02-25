Return-Path: <linux-kernel-owner+w=401wt.eu-S1762209AbZBYK13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762209AbZBYK13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761188AbZBYK1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:27:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64021 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760853AbZBYK1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:27:05 -0500
Message-ID: <49A51CD9.4060408@cn.fujitsu.com>
Date: Wed, 25 Feb 2009 18:26:33 +0800
From: Wei Yongjun <yjwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: remove some pointless conditionals before kfree_skb()
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some pointless conditionals before kfree_skb().

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 drivers/staging/at76_usb/at76_usb.c |    3 +--
 drivers/staging/otus/wwrap.c        |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/at76_usb/at76_usb.c b/drivers/staging/at76_usb/at76_usb.c
index c8e4d31..6f5c1cb 100644
--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -5370,8 +5370,7 @@ static void at76_delete_device(struct at76_priv *priv)
 
 	at76_dbg(DBG_PROC_ENTRY, "%s: unlinked urbs", __func__);
 
-	if (priv->rx_skb)
-		kfree_skb(priv->rx_skb);
+	kfree_skb(priv->rx_skb);
 
 	at76_free_bss_list(priv);
 	del_timer_sync(&priv->bss_list_timer);
diff --git a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
index 1bb5f59..a0b1e0b 100644
--- a/drivers/staging/otus/wwrap.c
+++ b/drivers/staging/otus/wwrap.c
@@ -971,8 +971,7 @@ int zfLnxCencSendMsg(struct sock *netlink_sk, u_int8_t *msg, int len)
 out:
 	return ret;
 nlmsg_failure: /*NLMSG_PUT Ê§°Ü£¬Ôò³·ÏúÌ×½Ó×Ö»º´æ*/
-  	if(skb)
-    		kfree_skb(skb);
+	kfree_skb(skb);
 	goto out;
 
 #undef COMMTYPE_GROUP
-- 
1.5.3.8




