Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbYCFBPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbYCFBPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757769AbYCFBPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:15:00 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:47826 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYCFBO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:14:58 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mark.fasheh@oracle.com, teigland@redhat.com
Subject: [PATCH 08/10] ocfs2: Change mlog_bug_on to BUG_ON in ocfs2_lockid.h
Date: Wed,  5 Mar 2008 17:13:56 -0800
Message-Id: <1204766038-31721-9-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
References: <1204766038-31721-1-git-send-email-joel.becker@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The masklog code is in the o2cb stack, but ocfs2_lockid.h now needs to
be included by the user stack.  The BUG() in ocfs2_lock_type_string()
does not need masklog support, so change it to a regular BUG_ON().

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/ocfs2_lockid.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ocfs2_lockid.h b/fs/ocfs2/ocfs2_lockid.h
index 86f3e37..82c200f 100644
--- a/fs/ocfs2/ocfs2_lockid.h
+++ b/fs/ocfs2/ocfs2_lockid.h
@@ -100,7 +100,7 @@ static char *ocfs2_lock_type_strings[] = {
 static inline const char *ocfs2_lock_type_string(enum ocfs2_lock_type type)
 {
 #ifdef __KERNEL__
-	mlog_bug_on_msg(type >= OCFS2_NUM_LOCK_TYPES, "%d\n", type);
+	BUG_ON(type >= OCFS2_NUM_LOCK_TYPES);
 #endif
 	return ocfs2_lock_type_strings[type];
 }
-- 
1.5.3.8

