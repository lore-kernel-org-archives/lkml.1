Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbYFAXbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbYFAXbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbYFAX2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:28:02 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:6146 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbYFAX17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=NQAuIrenv2fclRJFJGvRbhY6j2LZss3qPbW+9XR+yckNuytd4Gm75yENCyPM6HSPRp4u6umUtiesR5MF1ylMEwGFt/xzFIMoVq3LaFT/LpTo8IL88UNKp8bszi3ZeCLjlx5IwWriCv1p/aZ9Direq64vevaKed0BJXk9BAQ94U8=
Message-Id: <20080601231543.372911291@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:40 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: [patch -v2 11/23] airo: use simple_read_from_buffer
Content-Disposition: inline; filename=airo-use-simple-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/airo.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

Index: 2.6-git/drivers/net/wireless/airo.c
===================================================================
--- 2.6-git.orig/drivers/net/wireless/airo.c
+++ 2.6-git/drivers/net/wireless/airo.c
@@ -4560,22 +4560,13 @@ static ssize_t proc_read( struct file *f
 			  size_t len,
 			  loff_t *offset )
 {
-	loff_t pos = *offset;
-	struct proc_data *priv = (struct proc_data*)file->private_data;
+	struct proc_data *priv = file->private_data;
 
 	if (!priv->rbuffer)
 		return -EINVAL;
 
-	if (pos < 0)
-		return -EINVAL;
-	if (pos >= priv->readlen)
-		return 0;
-	if (len > priv->readlen - pos)
-		len = priv->readlen - pos;
-	if (copy_to_user(buffer, priv->rbuffer + pos, len))
-		return -EFAULT;
-	*offset = pos + len;
-	return len;
+	return simple_read_from_buffer(buffer, len, offset, priv->rbuffer,
+					priv->readlen);
 }
 
 /*

-- 
