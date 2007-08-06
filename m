Return-Path: <linux-kernel-owner+w=401wt.eu-S933550AbXHFN6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550AbXHFN6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbXHFNym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:54:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573AbXHFNy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:54:28 -0400
Date: Mon, 6 Aug 2007 09:54:22 -0400
Message-Id: <200708061354.l76DsMrh002285@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 06/25] coda: call attr_kill_to_mode from coda_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: codalist@TELEMANN.coda.cs.cmu.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/coda/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 342f4e0..c06d031 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -239,6 +239,7 @@ int coda_setattr(struct dentry *de, struct iattr *iattr)
 	memset(&vattr, 0, sizeof(vattr)); 
 
 	inode->i_ctime = CURRENT_TIME_SEC;
+	attr_kill_to_mode(inode, iattr);
 	coda_iattr_to_vattr(iattr, &vattr);
 	vattr.va_type = C_VNON; /* cannot set type */
 
-- 
1.5.2.2

