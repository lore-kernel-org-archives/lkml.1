Return-Path: <linux-kernel-owner+w=401wt.eu-S1764804AbZLQOXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764804AbZLQOXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 09:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764772AbZLQOXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 09:23:20 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:48418 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762715AbZLQOXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:23:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=GoKznm0PpwB/y7ciZMSfLSANJOSalz+z0pwZM2MMoxMsLywLhrEkcs/C5MQmLimE0j
         Tv4/pQGz0D2JQejIJ2VF9jxMfdlDZAtC2u2Djf/QL4AXqSBZsE22Cz9cL8RSAZzli4tJ
         Q9e65OAptlEs/qxeLRpL5XGsXU27741UxN5EY=
Date: Thu, 17 Dec 2009 22:26:57 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "viro" <viro@zeniv.linux.org.uk>
Cc: "Liu Hui" <onlyflyer@gmail.com>,
       "Xiao Guangrong" <xiaoguangrong@cn.fujitsu.com>,
       "strongzgy" <strongzgy@gmail.com>,
       "qingshenlwy" <qingshenlwy@gmail.com>
Subject: [PATCH 3/3]posix acl:Add an acl check
Message-ID: <200912172226552340782@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this function, the parameter of acl will be called by FOREACH_ACL_ENTRY(macro) 
without null point check. I add a Null point check to it. 

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 39df95a..6d81a13 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -213,6 +213,9 @@ posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
 	const struct posix_acl_entry *pa, *pe, *mask_obj;
 	int found = 0;
 
+	if (!acl)
+		return -EINVAL;
+
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
                 switch(pa->e_tag) {
                         case ACL_USER_OBJ:

 				
--------------
Best Regards,
Liuweni
2009-12-17

