Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbZLQOMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbZLQOMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 09:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760156AbZLQOMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 09:12:13 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:65259 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbZLQOMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:12:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=kK/L1ffL+NoxKA65Wnng5uJXHs2ouGiFc+yxVcOXGa54tfakAakdMdobsL7aKCO9Ci
         5tVvA4yJaTKslbaDmzvCdUtD87s1i3cxsuzeiolhy8vwVYWCFDPycXWT8P0mkicANzHH
         p5cPpHV/v7R7u+5tVr+2iAvDe7Ty0/Ub53FzQ=
Date: Thu, 17 Dec 2009 22:15:43 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "viro" <viro@zeniv.linux.org.uk>
Cc: "Xiao Guangrong" <xiaoguangrong@cn.fujitsu.com>,
       "strongzgy" <strongzgy@gmail.com>, "Liu Hui" <onlyflyer@gmail.com>,
       "qingshenlwy" <qingshenlwy@gmail.com>
Subject: [PATCH 1/3]posix acl:Add an acl check
Message-ID: <200912172215402654375@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this function, the parameter of acl will be called by FOREACH_ACL_ENTRY(macro) 
without null point check. I add a null point check to it. 

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 39df95a..956df14 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -76,6 +76,9 @@ posix_acl_valid(const struct posix_acl *acl)
 	unsigned int id = 0;  /* keep gcc happy */
 	int needs_mask = 0;
 
+	if (!acl)
+		return -EINVAL;
+
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
 		if (pa->e_perm & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
 			return -EINVAL;

 				
--------------
Best Regards,
Liuweni
2009-12-17

