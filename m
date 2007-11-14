Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbXKNCIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbXKNCIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761591AbXKNCF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:05:26 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4770 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761567AbXKNCFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:25 -0500
Subject: [PATCH] - [9/15] - remove defconfig ptr comparisons to 0 - fs/nfsd
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       nfs@lists.sourceforge.net
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:05:25 -0800
Message-Id: <1195005925.5163.95.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index d019918..07b38cf 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -987,7 +987,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 	 * flushing the data to disk is handled separately below.
 	 */
 
-	if (file->f_op->fsync == 0) {/* COMMIT3 cannot work */
+	if (!file->f_op->fsync) {/* COMMIT3 cannot work */
 	       stable = 2;
 	       *stablep = 2; /* FILE_SYNC */
 	}


