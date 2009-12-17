Return-Path: <linux-kernel-owner+w=401wt.eu-S1764775AbZLQOUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764775AbZLQOUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 09:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764620AbZLQOUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 09:20:33 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:58008 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303AbZLQOUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:20:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=TBIZ0Ga5ZiCHu0Fzmu2EZ10dsf8iOydoUHG7GinO9/LBH1rarE3WKDN1PGJgKRdZEu
         fcXloaXq8Zk/k86GmSzIu0z6AL1AO3W8Mv9df5cPLo7u9zJEvPQXK7qpjXkAmS5IBuik
         XvAB3jBFLcA1PR97Mw9Uvra7awJoD9RqJTIUY=
Date: Thu, 17 Dec 2009 22:24:10 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "viro" <viro@zeniv.linux.org.uk>
Cc: "strongzgy" <strongzgy@gmail.com>,
       "Xiao Guangrong" <xiaoguangrong@cn.fujitsu.com>,
       "Liu Hui" <onlyflyer@gmail.com>, "qingshenlwy" <qingshenlwy@gmail.com>
Subject: [PATCH 2/3]posix acl:Add an acl check
Message-ID: <200912172224077656512@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this function, the parameter of acl will be called by FOREACH_ACL_ENTRY(macro) 
without null pointer check. 

I add a Null point checker to it. 

In the fs/btrfs/btrfs_acl.c, the posix_acl_equiv_mode will make a error by null pointer.


---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 39df95a..37d0485 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -150,6 +150,9 @@ posix_acl_equiv_mode(const struct posix_acl *acl, mode_t *mode_p)
 	mode_t mode = 0;
 	int not_equiv = 0;
 
+	if(!acl)
+		return -EINVAL;
+
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
 		switch (pa->e_tag) {
 			case ACL_USER_OBJ:

 				
--------------
Best Regards,
Liuweni
2009-12-17

