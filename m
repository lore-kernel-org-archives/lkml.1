Return-Path: <linux-kernel-owner+w=401wt.eu-S933817AbYBGUJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbYBGUJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761656AbYBGUD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:39216 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761630AbYBGUD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=B60Bx7M8ZX+YnxHk/IO70IH3aqY1A9wjuljMKS/u9mYJo1B7vPCZayjvRN1jOCTnG7utIrwlq0JsU5j6Pr84k3IfNe0NaWnvKHfXiErkA3jpv0i9KgTW6bD48Igf87vd0HuCJGOv7W4kAB+UmS+QqJmxqHaYFp62Hhohf/t3ZwE=
Message-ID: <6101e8c40802071203r69a1fd9fge2b65c611e5a8e71@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:03:57 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {14/14} - knfsd: query filesystem for NFSv4 getattr of FATTR4_MAXNAME - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka: nfsv4-MAXNAME-fix.patch

From: J. Bruce Fields <bfields@citi.umich.edu>
Date: Fri, 28 Sep 2007 16:45:51 -0400
Subject: knfsd: query filesystem for NFSv4 getattr of FATTR4_MAXNAME
References: 271803
Patch-mainline: 2.6.24 (likely)

mainline: a16e92edcd0a2846455a30823e1bac964e743baa

Without this we always return 2^32-1 as the the maximum namelength.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>

---
 fs/nfsd/nfs4xdr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.22.orig/fs/nfsd/nfs4xdr.c
+++ linux-2.6.22/fs/nfsd/nfs4xdr.c
@@ -1453,7 +1453,8 @@ nfsd4_encode_fattr(struct svc_fh *fhp, s
 	err = vfs_getattr(exp->ex_mnt, dentry, &stat);
 	if (err)
 		goto out_nfserr;
-	if ((bmval0 & (FATTR4_WORD0_FILES_FREE | FATTR4_WORD0_FILES_TOTAL)) ||
+	if ((bmval0 & (FATTR4_WORD0_FILES_FREE | FATTR4_WORD0_FILES_TOTAL |
+			FATTR4_WORD0_MAXNAME)) ||
 	    (bmval1 & (FATTR4_WORD1_SPACE_AVAIL | FATTR4_WORD1_SPACE_FREE |
 		       FATTR4_WORD1_SPACE_TOTAL))) {
 		err = vfs_statfs(dentry, &statfs);
@@ -1699,7 +1700,7 @@ out_acl:
 	if (bmval0 & FATTR4_WORD0_MAXNAME) {
 		if ((buflen -= 4) < 0)
 			goto out_resource;
-		WRITE32(~(u32) 0);
+		WRITE32(statfs.f_namelen);
 	}
 	if (bmval0 & FATTR4_WORD0_MAXREAD) {
 		if ((buflen -= 8) < 0)


-- 
Thanks,
Oliver
