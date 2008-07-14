Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbYGNWD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbYGNWD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758138AbYGNWCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:02:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758158AbYGNWCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:02:04 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>
Subject: [PATCH 05/17] ocfs2: Silence an error message in ocfs2_file_aio_read()
Date: Mon, 14 Jul 2008 15:01:38 -0700
Message-Id: <1216072910-27226-6-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch silences an EINVAL error message in ocfs2_file_aio_read()
that is always due to a user error.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 57e0d30..e8514e8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2202,7 +2202,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 
 	ret = generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
 	if (ret == -EINVAL)
-		mlog(ML_ERROR, "generic_file_aio_read returned -EINVAL\n");
+		mlog(0, "generic_file_aio_read returned -EINVAL\n");
 
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(filp->f_flags & O_DIRECT));
-- 
1.5.4.1

