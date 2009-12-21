Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbZLUL4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbZLUL4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbZLULz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:55:58 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33622 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbZLULz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:55:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=nsLt+BTpDynEPA7np0cvMWSvEsa85AYBEl5OBYlFjx0bdJw2QaSaHSNo7aFctLzHQc
         Jxl4/Oh/g0LCNt4yEaznAFeFJluya1gKaee+XZbag+opJQA9868IcJSEAVlA5VKffRYp
         mopZyP8bFfntxza/FWKZQLyooDxCCTOR4ppVY=
Message-ID: <4B2F631F.4070303@gmail.com>
Date: Mon, 21 Dec 2009 19:59:27 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
Reply-To: qingshenlwy@gmail.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: dwmw2@infradead.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       akpm@linux-foundation.org, joel.becker@oracle.com, serue@us.ibm.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       onlyflyer@gmail.com, strongzgy@gmail.com
Subject: [PATCHv2 08/12]posix_acl: Add the check items
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <jmorris@namei.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 7cdc319..1eb4726 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -403,13 +403,10 @@ static int jffs2_acl_setxattr(struct dentry
*dentry, const char *name,

if (value) {
acl = posix_acl_from_xattr(value, size);
- if (IS_ERR(acl))
- return PTR_ERR(acl);
- if (acl) {
- rc = posix_acl_valid(acl);
- if (rc)
- goto out;
- }
+ rc = posix_acl_valid(acl);
+ if (rc)
+ goto out;
+
} else {
acl = NULL;
}

-- 
Best Regards,
Liuwenyi

