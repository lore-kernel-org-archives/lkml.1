Return-Path: <linux-kernel-owner+w=401wt.eu-S1762479AbYD3PI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762479AbYD3PI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762449AbYD3PGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:06:36 -0400
Received: from styx.suse.cz ([82.119.242.94]:36440 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762175AbYD3PGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:06:24 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] quota: Add a convenience macro for filesystems
Date: Wed, 30 Apr 2008 17:06:18 +0200
Message-Id: <12095679824183-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12095679812717-git-send-email-jack@suse.cz>
References: y
 <12095679813226-git-send-email-jack@suse.cz>
 <12095679812375-git-send-email-jack@suse.cz>
 <12095679812452-git-send-email-jack@suse.cz>
 <1209567981639-git-send-email-jack@suse.cz>
 <1209567981323-git-send-email-jack@suse.cz>
 <12095679812717-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that it cannot be an inline function because we don't have struct
super_block prototype...

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/quota.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/quota.h b/include/linux/quota.h
index 52e49dc..dcddfb2 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -347,6 +347,9 @@ struct quota_info {
 	((type) == USRQUOTA ? (sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED) : \
 			      (sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED))
 
+#define sb_any_quota_suspended(sb) (sb_has_quota_suspended(sb, USRQUOTA) | \
+				  sb_has_quota_suspended(sb, GRPQUOTA))
+
 int register_quota_format(struct quota_format_type *fmt);
 void unregister_quota_format(struct quota_format_type *fmt);
 
-- 
1.5.2.4

