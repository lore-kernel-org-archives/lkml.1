Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZLUL56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZLUL56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZLUL55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:57:57 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:55314 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZLUL55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:57:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=cYzbDtnJMnB9u2lXD6ViDj5UQodutE/MhaJN1jH+FOGzMO46J2g45okRSd4wXtAC9E
         jKIsy73njzOhQ27d+eaGH5T3gQ1UhooVnlySQUbhtX/l67O/BJrbcLUi78n138LrMHgK
         entwwkkptH7PJWmuFC17klZ9PoWCEPZ3DKuIQ=
Message-ID: <4B2F637C.2080506@gmail.com>
Date: Mon, 21 Dec 2009 20:01:00 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
Reply-To: qingshenlwy@gmail.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: mfasheh@suse.com, joel.becker@oracle.com, tiger.yang@oracle.com,
       viro@zeniv.linux.org.uk, jmorris@namei.org, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, strongzgy@gmail.com, onlyflyer@gmail.com
Subject: [PATCHv2 10/12]posix_acl: Add the check items
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Tiger Yang <tiger.yang@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <jmorris@namei.org>
Cc: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index e3e4741..b11c72c 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -408,13 +408,9 @@ static int ocfs2_xattr_set_acl(struct dentry
*dentry, const char *name,

if (value) {
acl = posix_acl_from_xattr(value, size);
- if (IS_ERR(acl))
- return PTR_ERR(acl);
- else if (acl) {
- ret = posix_acl_valid(acl);
- if (ret)
- goto cleanup;
- }
+ ret = posix_acl_valid(acl);
+ if (ret)
+ goto cleanup;
} else
acl = NULL;


-- 
Best Regards,
Liuwenyi

