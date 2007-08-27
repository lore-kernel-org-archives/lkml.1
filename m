Return-Path: <linux-kernel-owner+w=401wt.eu-S1763569AbXH0U2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763569AbXH0U2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762108AbXH0UXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:23:15 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43360 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760202AbXH0UXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:23:02 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: linux-kernel@vger.kernel.org
Cc: nfs@lists.sourceforge.net, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/15] nfsd: fix horrible indentation in nfsd_setattr
Date: Mon, 27 Aug 2007 16:22:44 -0400
Message-Id: <1188246177833-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.3.rc6.48.g17437
In-Reply-To: <1188246176897-git-send-email-bfields@fieldses.org>
References: <11882461763072-git-send-email-bfields@fieldses.org>
 <1188246176681-git-send-email-bfields@fieldses.org>
 <1188246176897-git-send-email-bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfsd/vfs.c |   43 ++++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index a0c2b25..11ae949 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -294,7 +294,8 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 	if (!iap->ia_valid)
 		goto out;
 
-	/* NFSv2 does not differentiate between "set-[ac]time-to-now"
+	/*
+	 * NFSv2 does not differentiate between "set-[ac]time-to-now"
 	 * which only requires access, and "set-[ac]time-to-X" which
 	 * requires ownership.
 	 * So if it looks like it might be "set both to the same time which
@@ -307,25 +308,33 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 	 */
 #define BOTH_TIME_SET (ATTR_ATIME_SET | ATTR_MTIME_SET)
 #define	MAX_TOUCH_TIME_ERROR (30*60)
-	if ((iap->ia_valid & BOTH_TIME_SET) == BOTH_TIME_SET
-	    && iap->ia_mtime.tv_sec == iap->ia_atime.tv_sec
-	    ) {
-	    /* Looks probable.  Now just make sure time is in the right ballpark.
-	     * Solaris, at least, doesn't seem to care what the time request is.
-	     * We require it be within 30 minutes of now.
-	     */
-	    time_t delta = iap->ia_atime.tv_sec - get_seconds();
-	    if (delta<0) delta = -delta;
-	    if (delta < MAX_TOUCH_TIME_ERROR &&
-		inode_change_ok(inode, iap) != 0) {
-		/* turn off ATTR_[AM]TIME_SET but leave ATTR_[AM]TIME
-		 * this will cause notify_change to set these times to "now"
+	if ((iap->ia_valid & BOTH_TIME_SET) == BOTH_TIME_SET &&
+	    iap->ia_mtime.tv_sec == iap->ia_atime.tv_sec) {
+		/*
+		 * Looks probable.
+		 *
+		 * Now just make sure time is in the right ballpark.
+		 * Solaris, at least, doesn't seem to care what the time
+		 * request is.  We require it be within 30 minutes of now.
 		 */
-		iap->ia_valid &= ~BOTH_TIME_SET;
-	    }
+		time_t delta = iap->ia_atime.tv_sec - get_seconds();
+		if (delta < 0)
+			delta = -delta;
+		if (delta < MAX_TOUCH_TIME_ERROR &&
+		    inode_change_ok(inode, iap) != 0) {
+			/*
+			 * Turn off ATTR_[AM]TIME_SET but leave ATTR_[AM]TIME.
+			 * This will cause notify_change to set these times
+			 * to "now"
+			 */
+			iap->ia_valid &= ~BOTH_TIME_SET;
+		}
 	}
 	    
-	/* The size case is special. It changes the file as well as the attributes.  */
+	/*
+	 * The size case is special.
+	 * It changes the file as well as the attributes.
+	 */
 	if (iap->ia_valid & ATTR_SIZE) {
 		if (iap->ia_size < inode->i_size) {
 			err = nfsd_permission(rqstp, fhp->fh_export, dentry, MAY_TRUNC|MAY_OWNER_OVERRIDE);
-- 
1.5.3.rc5.19.g0734d

