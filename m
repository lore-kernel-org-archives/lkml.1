Return-Path: <linux-kernel-owner+w=401wt.eu-S1761616AbYFDMNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761616AbYFDMNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760762AbYFDMKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:43163 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760753AbYFDMKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=xx6mLVOrbFkcJLYyrHm3AWJH8Ls9Y7Cr22Z6KPawGOioA1v3YOdoCHyomiqJanoUhx
         BYVbiVtajZ9i5duUTFNy6Azly3vqLfvVvR42B9D/ZnTJRQBaA6z7DebY8yb7U1qIty+Q
         NPTDSSZPulCz89ul2fEmdpN/anvJYx24q9Cmc=
Message-Id: <20080604115751.496499508@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:43 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: [patch -v3 10/22] airo: use simple_read_from_buffer
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
