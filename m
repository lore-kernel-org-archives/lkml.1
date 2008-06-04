Return-Path: <linux-kernel-owner+w=401wt.eu-S1761738AbYFDMNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761738AbYFDMNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbYFDMKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:20551 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbYFDMKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:10:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=n5+q/RnikcxZEwTXdLppOKa+IFSmcobVVM0b/hmLNK64W5gFiLykOaCObSrKVCXZLr
         H5kfzbU4xtQUq71w5OVc8bYmbqs8e3hfmAHXm90rccWX+Aghae/pAn3qUUBtHseeyCGG
         0n0802eCXdZhtDk4Kx2GGO5utfbTPf0nj/Rr8=
Message-Id: <20080604115758.089716740@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:44 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, dev-etrax@axis.com
Subject: [patch -v3 11/22] cris: use simple_read_from_buffer
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
