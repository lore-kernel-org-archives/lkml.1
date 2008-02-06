Return-Path: <linux-kernel-owner+w=401wt.eu-S1762423AbYBFXDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762423AbYBFXDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbYBFXDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:03:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:17141 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762854AbYBFXDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:03:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wHsIObk8qHfVISo9uwGZedkPE3ymKmApb5bZnxYnFP7NN/MIV3jtMT1ztB6/68o6HyJU2uva8ZT4a2Z7rjQ/zSCcs082bmeY/nKIdt2GInD0hbtilmO3u1s8nzatFTffNvw6ZebhKfJoN1ahu02iOKSc5VO81ZPa7yl3V2ZrJv4=
Message-ID: <6101e8c40802061503k39333288s3b5112576663d2f8@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:03:30 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {16/17} - nfsv4-MAXNAME-fix.diff - series for stable kernel #2
In-Reply-To: <6101e8c40802011734t235bc7j88a5f3fb6227aaf4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802011734t235bc7j88a5f3fb6227aaf4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>
Date: Fri, 28 Sep 2007 16:45:51 -0400
Subject: knfsd: query filesystem for NFSv4 getattr of FATTR4_MAXNAME
References: 271803
Patch-mainline: 2.6.24 (likely)

Without this we always return 2^32-1 as the the maximum namelength.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

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


On 2/2/08, Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> mainline: a16e92edcd0a2846455a30823e1bac964e743baa
>
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
