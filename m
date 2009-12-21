Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZLUL4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZLUL4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbZLUL4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:56:45 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:42332 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbZLUL4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:56:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=JcLZEePqnS5xSbHtWqvoTDQeUyi3Fk14smygRbkgVZvihUKgZUCr0aoIv5PkgE4BK6
         jBUZoz6NTJOlpr+2L1yYkZgPZ6Q8aSx0EkEPFTKxdHYYWkI4ogf9stLY3fzbEBWGqcPm
         R2L7FVUwiaNu2Cj2PYFjFCmp9KZ88aVPtywK0=
Message-ID: <4B2F6338.2040609@gmail.com>
Date: Mon, 21 Dec 2009 19:59:52 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
Reply-To: qingshenlwy@gmail.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: bfields@fieldses.org, neilb@suse.de, ffilzlnx@us.ibm.com,
       bharrosh@panasas.com, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, strongzgy@gmail.com, onlyflyer@gmail.com
Subject: [PATCHv2 09/12]posix_acl: Add the check items
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Frank Filz <ffilzlnx@us.ibm.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---

diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
index 8815068..0c2cd6c 100644
--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@ -135,27 +135,21 @@ nfs4_acl_posix_to_nfsv4(struct posix_acl *pacl,
struct posix_acl *dpacl,
struct nfs4_acl *acl;
int size = 0;

- if (pacl) {
- if (posix_acl_valid(pacl) < 0)
- return ERR_PTR(-EINVAL);
- size += 2*pacl->a_count;
- }
- if (dpacl) {
- if (posix_acl_valid(dpacl) < 0)
- return ERR_PTR(-EINVAL);
- size += 2*dpacl->a_count;
- }
+ if (posix_acl_valid(pacl) < 0)
+ return ERR_PTR(-EINVAL);
+ size += 2*pacl->a_count;
+
+ if (posix_acl_valid(dpacl) < 0)
+ return ERR_PTR(-EINVAL);
+ size += 2*dpacl->a_count;

/* Allocate for worst case: one (deny, allow) pair each: */
acl = nfs4_acl_new(size);
if (acl == NULL)
return ERR_PTR(-ENOMEM);

- if (pacl)
- _posix_to_nfsv4_one(pacl, acl, flags & ~NFS4_ACL_TYPE_DEFAULT);
-
- if (dpacl)
- _posix_to_nfsv4_one(dpacl, acl, flags | NFS4_ACL_TYPE_DEFAULT);
+ _posix_to_nfsv4_one(pacl, acl, flags & ~NFS4_ACL_TYPE_DEFAULT);
+ _posix_to_nfsv4_one(dpacl, acl, flags | NFS4_ACL_TYPE_DEFAULT);

return acl;
}

-- 
Best Regards,
Liuwenyi

