Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZLULxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZLULxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbZLULxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:53:12 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35401 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZLULxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:53:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=mGCoj4dus9uulemXmgSJa2tT/DjD2141K2ZTotnuOFLQ8JmDLM9pUHAZEu1XOY20b7
         NYT2WhXf2ow+gPwT7/Tt5qtQEvv3yT5EZZ3CAq8ox0th7Z1wxQAkQ+F0vpJQrY49HaDu
         G7FNafx/+kcSyzGLK8Ol1+7UjzdJ/INi/PqaQ=
Message-ID: <4B2F626E.3090402@gmail.com>
Date: Mon, 21 Dec 2009 19:56:30 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
Reply-To: qingshenlwy@gmail.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, adilger@sun.com, viro@zeniv.linux.org.uk,
       jmorris@namei.org, joel.becker@oracle.com, serue@us.ibm.com,
       jack@suse.cz, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       onlyflyer@gmail.com, strongzgy@gmail.com
Subject: [PATCHv2 04/12]posix_acl: Add the check items
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.

---

Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <jmorris@namei.org>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 82ba341..3758304 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -432,13 +432,11 @@ ext3_xattr_set_acl(struct dentry *dentry, const
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

