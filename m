Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbYBTULf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbYBTULf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763926AbYBTUKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:10:47 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:18079 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYBTUKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:10:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CY8lVy2u0GdZpxXMrkzUSCwbgsidIN9mVTA7rybpJqjh7ghraoToAjGa6bpuLn1XNmMmrunYmV5zxO+qRaxJVnmxgCouQDyTcBI+l/tduOWRHnAdf6fqUtwZUriNpWO21CsoZnFtgzliyDlQrKAMYhsnNa2J9uSLanVJ5ryTOdk=
Subject: [PATCH 2/4] nfs: fix sparse warning in delegation.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 12:10:46 -0800
Message-Id: <1203538246.25307.15.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/nfs/delegation.c:52:34: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/nfs/delegation.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index b9eadd1..00a5e44 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -49,7 +49,7 @@ static int nfs_delegation_claim_locks(struct nfs_open_context *ctx, struct nfs4_
 	struct file_lock *fl;
 	int status;
 
-	for (fl = inode->i_flock; fl != 0; fl = fl->fl_next) {
+	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
 			continue;
 		if (nfs_file_open_context(fl->fl_file) != ctx)
-- 
1.5.4.2.200.g99e75


