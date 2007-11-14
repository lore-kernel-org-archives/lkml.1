Return-Path: <linux-kernel-owner+w=401wt.eu-S1762870AbXKNEuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870AbXKNEuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbXKNEt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:49:56 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:41213 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286AbXKNEtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:49:55 -0500
Date: Wed, 14 Nov 2007 10:19:04 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net, apw@shadowen.org
Subject: [PATCH] 2.6.24-rc2-mm1 - Build fails - in nsfd/vfs.c
Message-ID: <20071114044904.GA12453@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The Kernel build fails, with error

  CC      fs/nfsd/vfs.o
fs/nfsd/vfs.c: In function ‘nfsd_rename’:
fs/nfsd/vfs.c:1695: error: request for member ‘mnt’ in something not a structure or union
make[2]: *** [fs/nfsd/vfs.o] Error 1
make[1]: *** [fs/nfsd] Error 2
make: *** [fs] Error 2

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.24-rc2/fs/nfsd/vfs.c	2007-11-13 22:16:18.000000000 -0500
+++ linux-2.6.24-rc2/fs/nfsd/~vfs.c	2007-11-13 23:10:18.000000000 -0500
@@ -1692,7 +1692,7 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 		if (!host_err)
 			host_err = nfsd_sync_dir(fdentry);
 	}
-	mnt_drop_write(ffhp->fh_export->ex_path.mnt);
+	mnt_drop_write(ffhp->fh_export->ex_mnt);
 
  out_dput_new:
 	dput(ndentry);

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
