Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbYBGGWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbYBGGWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYBGGSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 12/16] dlm: fix dlm_dir_lookup() handling of too long names
Date: Thu,  7 Feb 2008 00:09:15 -0600
Message-Id: <1202364559-9201-13-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

... those can happen and BUG() from DLM_ASSERT() in allocate_direntry() is
not a good way to handle them.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dir.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/dlm/dir.c b/fs/dlm/dir.c
index 831050e..85defeb 100644
--- a/fs/dlm/dir.c
+++ b/fs/dlm/dir.c
@@ -319,6 +319,9 @@ static int get_entry(struct dlm_ls *ls, int nodeid, char *name,
 
 	write_unlock(&ls->ls_dirtbl[bucket].lock);
 
+	if (namelen > DLM_RESNAME_MAXLEN)
+		return -EINVAL;
+
 	de = kzalloc(sizeof(struct dlm_direntry) + namelen, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
-- 
1.5.3.3

