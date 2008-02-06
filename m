Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYBFXGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYBFXGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763444AbYBFXFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:05:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:39856 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762729AbYBFXFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:05:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=urgHHm/527d6BTkELhphpMeUFLaB/6J7Dzy5Oo5wthCA7jUrBwYp+XVPN33tA5NkhJ67C7uF3HZfIxhgiXSdFiQMrXXEBXsFQmeqgVf3vfmCUdBcuwwfd89P87pqmk3oKOXEfBQ12B+dsTedpz9TksjcY/zTIltY55oxC5DblbQ=
Message-ID: <6101e8c40802061505g101d2cafq477b57f110cbae66@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:05:03 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {12/17} - nfsacl-retval.diff - series for stable kernel #2
In-Reply-To: <6101e8c40802011734l63bdb871r29006ad5af408234@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802011734l63bdb871r29006ad5af408234@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>
Date: Fri, 2 Nov 2007 15:36:08 -0400
Subject: [PATCH] knfsd: fix spurious EINVAL errors on first access of
new filesystem
References: 340873

The v2/v3 acl code in nfsd is translating any return from fh_verify() to
nfserr_inval.  This is particularly unfortunate in the case of an
nfserr_dropit return, which is an internal error meant to indicate to
callers that this request has been deferred and should just be dropped
pending the results of an upcall to mountd.

Thanks to Roland <devzero@web.de> for bug report and data collection.

Cc: Roland <devzero@web.de>
Acked-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

Index: linux-2.6.23/fs/nfsd/nfs2acl.c
===================================================================
--- linux-2.6.23.orig/fs/nfsd/nfs2acl.c
+++ linux-2.6.23/fs/nfsd/nfs2acl.c
@@ -41,7 +41,7 @@ static __be32 nfsacld_proc_getacl(struct

 	fh = fh_copy(&resp->fh, &argp->fh);
 	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
-		RETURN_STATUS(nfserr_inval);
+		RETURN_STATUS(nfserr);

 	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
 		RETURN_STATUS(nfserr_inval);
Index: linux-2.6.23/fs/nfsd/nfs3acl.c
===================================================================
--- linux-2.6.23.orig/fs/nfsd/nfs3acl.c
+++ linux-2.6.23/fs/nfsd/nfs3acl.c
@@ -37,7 +37,7 @@ static __be32 nfsd3_proc_getacl(struct s

 	fh = fh_copy(&resp->fh, &argp->fh);
 	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
-		RETURN_STATUS(nfserr_inval);
+		RETURN_STATUS(nfserr);

 	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
 		RETURN_STATUS(nfserr_inval);


On 2/2/08, Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> mainline: ac8587dcb58e40dd336d99d60f852041e06cc3dd
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
