Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0CFLVt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:21:49 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:42671 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0CFLVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:21:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=eGRNJRlo2RIgjpOaYx9iZNfn4DYFtRJK9H1+l1OXqScm+2bn2MBhQD9tuH/UEI5Vxe
         eM3J67HW78gtur6UNKI/mGXBZdQxbl2RH4bJaaYl8v6Wecqi4l/YeQkLXv9uGWIoARIV
         vhku9wS1CNg3sLTjSG08nchMIkp9G5VsPRl5M=
Date: Sat, 6 Mar 2010 14:21:25 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "J.R. Okajima" <hooanon05@yahoo.co.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] security: ima_file_mmap() don't just return zero
Message-ID: <20100306112125.GN4958@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>,
	Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
	"J.R. Okajima" <hooanon05@yahoo.co.jp>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems like we should return an error here.  That's what the comment
says we should do.

I also removed an out of date comment.  It wasn't needed and seemed likely
to get out of date again.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This was found with a static checker and I have only compile tested it.
The callers all seem to use the return code, but please review carefully.
The code has been like this since the module was merged.

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 294b005..90d5314 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -260,18 +260,17 @@ out:
  * policy decision.
  *
  * Return 0 on success, an error code on failure.
- * (Based on the results of appraise_measurement().)
  */
 int ima_file_mmap(struct file *file, unsigned long prot)
 {
-	int rc;
+	int rc = 0;
 
 	if (!file)
 		return 0;
 	if (prot & PROT_EXEC)
 		rc = process_measurement(file, file->f_dentry->d_name.name,
 					 MAY_EXEC, FILE_MMAP);
-	return 0;
+	return rc;
 }
 
 /**
