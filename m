Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZDPUWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZDPUWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZDPUWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:22:43 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:45070 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZDPUWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=rg9oe/HRtII8hdgy/SvaoqlQmgDJd0RENZWzH2B/gTtfAF6NtayKbyDnQyZAHqxLce
         mzrSWrndz/rVnulS6shqY1EJ/Z4JXy6rO47NVUcYyoqeUDRKNHM0Xest0vE+STPXt9vr
         UIT3Dr9CIPNQBofDdAJFsZqR5UIDTpZWxRr1M=
Message-ID: <49E79390.7070809@gmail.com>
Date: Thu, 16 Apr 2009 22:22:40 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: operator precedence errors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`!' has a higher precedence than `&' and `|' has a higher precedence than `?'

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 515ba74..cf3bc49 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -482,7 +482,7 @@ static int pcl816_ai_cmdtest(struct comedi_device * dev, struct comedi_subdevice
 	if (!cmd->scan_begin_src || tmp != cmd->scan_begin_src)
 		err++;
 
-	if (!cmd->convert_src & (TRIG_EXT | TRIG_TIMER))
+	if (!(cmd->convert_src & (TRIG_EXT | TRIG_TIMER)))
 		err++;
 
 	tmp = cmd->scan_end_src;
diff --git a/drivers/staging/pohmelfs/trans.c b/drivers/staging/pohmelfs/trans.c
index bcb5942..6855224 100644
--- a/drivers/staging/pohmelfs/trans.c
+++ b/drivers/staging/pohmelfs/trans.c
@@ -101,7 +101,8 @@ static int netfs_trans_send_pages(struct netfs_trans *t, struct netfs_state *st)
 			goto err_out;
 		}
 
-		msg.msg_flags = MSG_WAITALL|(attached_pages == 1)?0:MSG_MORE;
+		msg.msg_flags = MSG_WAITALL | (attached_pages == 1 ? 0 :
+				MSG_MORE);
 
 		err = kernel_sendpage(st->socket, page, 0, size, msg.msg_flags);
 		if (err <= 0) {
diff --git a/drivers/staging/rt2870/tmp60 b/drivers/staging/rt2870/tmp60
index 975e444..eb50243 100644
--- a/drivers/staging/rt2870/tmp60
+++ b/drivers/staging/rt2870/tmp60
@@ -1776,7 +1776,7 @@ int rt_ioctl_siwencode(struct net_device *dev,
             }
         else
 			/* Don't complain if only change the mode */
-			if(!erq->flags & IW_ENCODE_MODE) {
+			if(!(erq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 		}
 	}
diff --git a/drivers/staging/rt2870/tmp61 b/drivers/staging/rt2870/tmp61
index 975e444..eb50243 100644
--- a/drivers/staging/rt2870/tmp61
+++ b/drivers/staging/rt2870/tmp61
@@ -1776,7 +1776,7 @@ int rt_ioctl_siwencode(struct net_device *dev,
             }
         else
 			/* Don't complain if only change the mode */
-			if(!erq->flags & IW_ENCODE_MODE) {
+			if(!(erq->flags & IW_ENCODE_MODE)) {
 				return -EINVAL;
 		}
 	}
diff --git a/drivers/staging/rt3070/sta_ioctl.c b/drivers/staging/rt3070/sta_ioctl.c
index 0794548..9373ae8 100644
--- a/drivers/staging/rt3070/sta_ioctl.c
+++ b/drivers/staging/rt3070/sta_ioctl.c
@@ -1725,10 +1725,8 @@ int rt_ioctl_siwencode(struct net_device *dev,
             }
         else
 			/* Don't complain if only change the mode */
-		if(!erq->flags & IW_ENCODE_MODE)
-		{
+		if (!(erq->flags & IW_ENCODE_MODE))
 				return -EINVAL;
-		}
 	}
 
 done:
