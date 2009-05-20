Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZETPTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZETPTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbZETPTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:19:33 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:35996 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZETPTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Srk6N0VaSP4LvmjXVneeQP0FmcOdtSzIMZdWfQ2CTmgMOg7YOpYmRAdP3vwX76rOTy
         M3vJPyJzbr5vkIi01LKMBlT3j8PO5qWZYx2veRw93Lzv6q48wSdzey91hLUAPx8u+9Sp
         ttQNxYFTatRz0gtWj9ola4Tcla1vYGz9e6HsY=
Message-ID: <4A141F83.10102@gmail.com>
Date: Wed, 20 May 2009 17:19:31 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: jmorris@namei.org
CC: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] smack:beyond ARRAY_SIZE of data
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not go beyond ARRAY_SIZE of data

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index e03a7e1..7407e5c 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -797,7 +797,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
-	if (count < SMK_NETLBLADDRMIN || count > SMK_NETLBLADDRMAX)
+	if (count < SMK_NETLBLADDRMIN || count >= SMK_NETLBLADDRMAX)
 		return -EINVAL;
 	if (copy_from_user(data, buf, count) != 0)
 		return -EFAULT;

