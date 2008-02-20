Return-Path: <linux-kernel-owner+w=401wt.eu-S935006AbYBTUtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935006AbYBTUtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761745AbYBTUsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:48:54 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:9674 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbYBTUsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:48:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WtmRN7e7OrQNfzL/WkEf3p9D0sRFTgp0EAzLXluXmRG6CNghqBfxaldzOWMsCEtTbzlEZoD+Z9a6peP+WOm4JLeT4Is5FQdixS97CWlJnj3KvukX/5+BuPJuL6CjwBQJ1SBqdSchb920JKVx0JxFHtTsVmGZsTuM45xTQwwPEEI=
Subject: [PATCH 2/2] nfsd: fix sparse warning in vfs.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 12:49:02 -0800
Message-Id: <1203540542.25307.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/nfsd/vfs.c:991:27: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/nfsd/vfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 0265310..17ac51b 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -988,7 +988,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 	 * flushing the data to disk is handled separately below.
 	 */
 
-	if (file->f_op->fsync == 0) {/* COMMIT3 cannot work */
+	if (!file->f_op->fsync) {/* COMMIT3 cannot work */
 	       stable = 2;
 	       *stablep = 2; /* FILE_SYNC */
 	}
-- 
1.5.4.2.200.g99e75

