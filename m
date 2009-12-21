Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZLUMAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZLUMAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 07:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZLUMAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 07:00:15 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:44218 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbZLUMAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 07:00:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ssakd1f5vJAa3ZMAgtKC87Bsr8nbI+VNmVDIcoXuS1xmr3DLzjI+PWjcUJUsNWdl99
         lMyhxxs3yH9170mOmygqNKB+zRvE2VpH3/wZY68uVoLvNFlrLdnQ+FTKnmft29YuYzmI
         wJtZTG8WGnUqVrcgydAy+ghOJ4cPaKESObyI0=
Message-ID: <4B2F63B1.4080109@gmail.com>
Date: Mon, 21 Dec 2009 20:01:53 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
Reply-To: qingshenlwy@gmail.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk, jeffm@suse.com, joel.becker@oracle.com,
       jmorris@namei.org, hch@lst.de, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, onlyflyer@gmail.com, strongzgy@gmail.com
Subject: [PATCHv2 11/12]posix_acl: Add the check items
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
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: James Morris <jmorris@namei.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: reiserfs-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index cc32e6a..4cf1f18 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -30,13 +30,9 @@ posix_acl_set(struct dentry *dentry, const char
*name, const void *value,

if (value) {
acl = posix_acl_from_xattr(value, size);
- if (IS_ERR(acl)) {
- return PTR_ERR(acl);
- } else if (acl) {
- error = posix_acl_valid(acl);
- if (error)
- goto release_and_out;
- }
+ error = posix_acl_valid(acl);
+ if (error)
+ goto release_and_out;
} else
acl = NULL;


-- 
Best Regards,
Liuwenyi

