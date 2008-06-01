Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbYFAXbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbYFAXbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYFAX2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:28:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:2864 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbYFAX2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=mMzEJF4eOpVy8J21j7Saaj01sULLgV2ynECcuOIwJmO2nEF+0K6K5WPP/Uvk9jn9OxqgVBgeJBMTWZJZQRWNpmYNxpUiL2EcyPXgFro6gDfrMKE68hLZEZU1jbcGd6yY0CHtW+v92Vj045sX+vagATO0p6gEA31f6lNXIOJO6hM=
Message-Id: <20080601231549.368333822@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:41 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, dev-etrax@axis.com
Subject: [patch -v2 12/23] cris: use simple_read_from_buffer
Content-Disposition: inline; filename=cris-profile-use-simple-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: dev-etrax@axis.com
---
 arch/cris/kernel/profile.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

Index: 2.6-git/arch/cris/kernel/profile.c
===================================================================
--- 2.6-git.orig/arch/cris/kernel/profile.c
+++ 2.6-git/arch/cris/kernel/profile.c
@@ -35,19 +35,16 @@ read_cris_profile(struct file *file, cha
 		  size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
+	ssize_t ret;
 
-	if (p > SAMPLE_BUFFER_SIZE)
-		return 0;
+	ret = simple_read_from_buffer(buf, count, ppos, sample_buffer,
+						SAMPLE_BUFFER_SIZE);
+	if (ret < 0)
+		return ret;
 
-	if (p + count > SAMPLE_BUFFER_SIZE)
-		count = SAMPLE_BUFFER_SIZE - p;
-	if (copy_to_user(buf, sample_buffer + p,count))
-		return -EFAULT;
+	memset(sample_buffer + p, 0, ret);
 
-	memset(sample_buffer + p, 0, count);
-	*ppos += count;
-
-	return count;
+	return ret;
 }
 
 static ssize_t

-- 
