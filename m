Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZCKVNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZCKVNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZCKVNC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:13:02 -0400
Received: from kroah.org ([198.145.64.141]:56830 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751178AbZCKVNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:13:01 -0400
Subject: patch staging-remove-some-pointless-conditionals-before-kfree_skb.patch added to gregkh-2.6 tree
To: yjwei@cn.fujitsu.com, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Wed, 11 Mar 2009 14:10:02 -0700
In-Reply-To: <49A51CD9.4060408@cn.fujitsu.com>
Message-ID: <12368058023242@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: remove some pointless conditionals before kfree_skb()

to my gregkh-2.6 tree.  Its filename is

    staging-remove-some-pointless-conditionals-before-kfree_skb.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From yjwei@cn.fujitsu.com  Wed Mar 11 13:27:24 2009
From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 25 Feb 2009 18:26:33 +0800
Subject: Staging: remove some pointless conditionals before kfree_skb()
To: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <49A51CD9.4060408@cn.fujitsu.com>


Remove some pointless conditionals before kfree_skb().

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/at76_usb/at76_usb.c |    3 +--
 drivers/staging/otus/wwrap.c        |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -5370,8 +5370,7 @@ static void at76_delete_device(struct at
 
 	at76_dbg(DBG_PROC_ENTRY, "%s: unlinked urbs", __func__);
 
-	if (priv->rx_skb)
-		kfree_skb(priv->rx_skb);
+	kfree_skb(priv->rx_skb);
 
 	at76_free_bss_list(priv);
 	del_timer_sync(&priv->bss_list_timer);
--- a/drivers/staging/otus/wwrap.c
+++ b/drivers/staging/otus/wwrap.c
@@ -971,8 +971,7 @@ int zfLnxCencSendMsg(struct sock *netlin
 out:
 	return ret;
 nlmsg_failure: /*NLMSG_PUT Ê§°Ü£¬Ôò³·ÏúÌ×½Ó×Ö»º´æ*/
-  	if(skb)
-    		kfree_skb(skb);
+	kfree_skb(skb);
 	goto out;
 
 #undef COMMTYPE_GROUP

