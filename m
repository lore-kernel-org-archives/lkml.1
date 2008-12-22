Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYLVVt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYLVVt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbYLVVss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:48:48 -0500
Received: from ns2.suse.de ([195.135.220.15]:38590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbYLVVsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:48:47 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 03/56] quota: Remove bogus 'optimization' in check_idq() and check_bdq()
Date: Mon, 22 Dec 2008 13:47:44 -0800
Message-Id: <1229982517-3455-4-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Checks like <= 0 for an unsigned type do not make much sence. The value
could be only 0 and that does not happen often enough for the check
to be worth it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/dquot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 59e8aea..735e2c3 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1041,7 +1041,7 @@ static inline char ignore_hardlimit(struct dquot *dquot)
 static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
 {
 	*warntype = QUOTA_NL_NOWARN;
-	if (inodes <= 0 || test_bit(DQ_FAKE_B, &dquot->dq_flags))
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
 	if (dquot->dq_dqb.dqb_ihardlimit &&
@@ -1073,7 +1073,7 @@ static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
 static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *warntype)
 {
 	*warntype = QUOTA_NL_NOWARN;
-	if (space <= 0 || test_bit(DQ_FAKE_B, &dquot->dq_flags))
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
 	if (dquot->dq_dqb.dqb_bhardlimit &&
-- 
1.5.6

