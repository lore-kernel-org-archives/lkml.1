Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbYLWQO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbYLWQO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYLWQNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:13:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48929 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYLWQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:13:04 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/10] dlm: replace schedule with cond_resched
Date: Tue, 23 Dec 2008 10:58:37 -0600
Message-Id: <1230051523-5478-5-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This is a one-liner to use cond_resched() rather than schedule()
in the ast delivery loop. It should not be necessary to schedule
every time, so this will save some cpu time while continuing to
allow scheduling when required.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/ast.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 8bf31e3..30c11f3 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -101,7 +101,7 @@ static void process_asts(void)
 		   and may result in the lkb being freed */
 		dlm_put_lkb(lkb);
 
-		schedule();
+		cond_resched();
 	}
 }
 
-- 
1.5.5.1

