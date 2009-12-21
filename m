Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZLULvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZLULvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbZLULu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:50:59 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:40301 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbZLULu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:50:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=tSDdiIeCI5Rb530o7UoNVFfhnsMrkdSnkj7cP6oK+133hSV4wfO96EyqlgHsL9zVZL
         tNf/sMZ+5TDg6ECTXwljGT4zUrOIXkdWX+CTwqkcWe9j65VRI70odowQ1dVf0b27Bvly
         c8VyKxUBouOe9QYnpVx0oDOP0510wloOkHRvk=
Message-ID: <4B2F61D7.5000302@gmail.com>
Date: Mon, 21 Dec 2009 19:53:59 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
Reply-To: qingshenlwy@gmail.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk, jmorris@namei.org, joel.becker@oracle.com,
       serue@us.ibm.com, hch@lst.de, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, strongzgy@gmail.com, onlyflyer@gmail.com
Subject: [PATCHv2 03/12]posix_acl: Add the check items
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <jmorris@namei.org>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index a99e543..480fe88 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -403,13 +403,11 @@ ext2_xattr_set_acl(struct dentry *dentry, const
char *name, const void *value,

if (value) {
acl = posix_acl_from_xattr(value, size);
- if (IS_ERR(acl))
- return PTR_ERR(acl);
- else if (acl) {
- error = posix_acl_valid(acl);
- if (error)
- goto release_and_out;
- }
+
+ error = posix_acl_valid(acl);
+ if (error)
+ goto release_and_out;
+
} else
acl = NULL;


-- 
Best Regards,
Liuwenyi

