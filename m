Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbZLULzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbZLULzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbZLULz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:55:29 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:38336 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbZLULz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:55:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=tE0QrIJl+W3ZlDE5rrOjj85xITt+aWGGa1WxlE65468EIZC9UMFa2DnnV6RQbg3/GU
         gvC6DVOceRBwV6rMjnMwdE5RXcpUMRbmHZz0UWdlkp0ykKp1eCpzOLLszL5Sesk8M0j2
         lNLxVGUFPiYIQTf9ctN+QsNgEgHrS8GkJ6ulY=
Message-ID: <4B2F6302.5050302@gmail.com>
Date: Mon, 21 Dec 2009 19:58:58 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
Reply-To: qingshenlwy@gmail.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: swhiteho@redhat.com, viro@zeniv.linux.org.uk, joel.becker@oracle.com,
       jmorris@namei.org, hch@lst.de, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, onlyflyer@gmail.com, strongzgy@gmail.com
Subject: [PATCHv2 07/12]posix_acl: Add the check items
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: James Morris <jmorris@namei.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 87ee309..462f4e3 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -284,17 +284,6 @@ static int gfs2_xattr_system_set(struct dentry
*dentry, const char *name,
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

