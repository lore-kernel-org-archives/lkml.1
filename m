Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZLUMBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZLUMBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 07:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZLUMBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 07:01:44 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:62376 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZLUMBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 07:01:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Q+Kbqjj/A/dpIHKwNZ0VRxf16phg1RFPEyh1X78wtImv3yqmSWRzd4E6G15i8j0nIL
         6kjo00DBFqesyUn430Hz8Cldg3LxJZg5ZvIyBcjxmbw3xtE6euWChYoMgSd4lW0LDT3Q
         cHYa88jzqLiDVbLUH2N9jXbhIvAcSdGXjNNsQ=
Message-ID: <4B2F6407.4060805@gmail.com>
Date: Mon, 21 Dec 2009 20:03:19 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
Reply-To: qingshenlwy@gmail.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: aelder@sgi.com, xfs-masters@oss.sgi.com, hch@lst.de,
       viro@zeniv.linux.org.uk, sandeen@sandeen.net, joel.becker@oracle.com,
       xfs@oss.sgi.com, linux-kernel@vger.kernel.org, strongzgy@gmail.com,
       onlyflyer@gmail.com
Subject: [PATCHv2 12/12]posix_acl: Add the check items
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: xfs-masters@oss.sgi.com
Cc :Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/xfs/linux-2.6/xfs_acl.c b/fs/xfs/linux-2.6/xfs_acl.c
index 2512125..3de2533 100644
--- a/fs/xfs/linux-2.6/xfs_acl.c
+++ b/fs/xfs/linux-2.6/xfs_acl.c
@@ -392,17 +392,6 @@ xfs_xattr_acl_set(struct dentry *dentry, const char
*name,
goto set_acl;

acl = posix_acl_from_xattr(value, size);
- if (!acl) {
- /*
- * acl_set_file(3) may request that we set default ACLs with
- * zero length -- defend (gracefully) against that here.
- */
- goto out;
- }
- if (IS_ERR(acl)) {
- error = PTR_ERR(acl);
- goto out;
- }

error = posix_acl_valid(acl);
if (error)

-- 
Best Regards,
Liuwenyi

