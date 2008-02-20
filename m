Return-Path: <linux-kernel-owner+w=401wt.eu-S1765548AbYBTULI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765548AbYBTULI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763999AbYBTUKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:10:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:18294 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763926AbYBTUKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:10:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UbQZJGj7GhxNenHBpo2kRzgh+/Ryj6Rc7HVo/TUwGsctniorbRzPpdaLQZXlFoV6abJEpMfTtTld24mjW1hE6sbH6uA9sFQll8vr9urDR4c+VoSIAYvkrJJJErBja8G8VojgBGPXLk495S0gmdHZ9M/SRYqPXEO+pmyZ+Wu8iU0=
Subject: [PATCH 1/4] nfs: fix sparse warning in nfs4state.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 12:10:46 -0800
Message-Id: <1203538246.25307.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/nfs/nfs4state.c:788:34: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/nfs/nfs4state.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 6233eb5..b962397 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -785,7 +785,7 @@ static int nfs4_reclaim_locks(struct nfs4_state_recovery_ops *ops, struct nfs4_s
 	struct file_lock *fl;
 	int status = 0;
 
-	for (fl = inode->i_flock; fl != 0; fl = fl->fl_next) {
+	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
 		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
 			continue;
 		if (nfs_file_open_context(fl->fl_file)->state != state)
-- 
1.5.4.2.200.g99e75


