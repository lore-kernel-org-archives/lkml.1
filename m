Return-Path: <linux-kernel-owner+w=401wt.eu-S1422878AbXBANwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422878AbXBANwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422885AbXBANwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:52:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51272 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422878AbXBANwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:52:44 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] endianness bug: ntohl() misspelled as >> 24 in fh_verify().
Cc: linux-kernel@vger.kernel.org, neilb@suse.de
Message-Id: <E1HCcMl-0007Qy-Vu@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 01 Feb 2007 13:52:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/nfsd/nfsfh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 98338a5..c59d6fb 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -269,7 +269,7 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
 			"acc=%x, error=%d\n",
 			dentry->d_parent->d_name.name,
 			dentry->d_name.name,
-			access, (error >> 24));
+			access, ntohl(error));
 	}
 out:
 	if (exp && !IS_ERR(exp))
-- 
1.5.0-rc2.GIT


