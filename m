Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbZDHLu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbZDHLu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932252AbZDHL2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:28:42 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37856 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764669AbZDHL1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:39 -0400
X-Sasl-enc: N4vROtlaFM1rapJYlNJPKt/SM23Oo1TlQJ9iA9lUWCjF 1239190057
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 36/56] ocfs2: Remove void casts
Date: Wed,  8 Apr 2009 12:22:08 +0100
Message-Id: <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 fs/ocfs2/dlm/dlmmaster.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index f8b653f..e4c2f5b 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -758,8 +758,7 @@ lookup:
 		spin_unlock(&dlm->spinlock);
 		mlog(0, "allocating a new resource\n");
 		/* nothing found and we need to allocate one. */
-		alloc_mle = (struct dlm_master_list_entry *)
-			kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
+		alloc_mle = kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
 		if (!alloc_mle)
 			goto leave;
 		res = dlm_new_lockres(dlm, lockid, namelen);
@@ -1543,8 +1542,7 @@ way_up_top:
 			spin_unlock(&dlm->master_lock);
 			spin_unlock(&dlm->spinlock);
 
-			mle = (struct dlm_master_list_entry *)
-				kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
+			mle = kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
 			if (!mle) {
 				response = DLM_MASTER_RESP_ERROR;
 				mlog_errno(-ENOMEM);
@@ -2455,7 +2453,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 		goto leave;
 	}
 
-	mle = (struct dlm_master_list_entry *) kmem_cache_alloc(dlm_mle_cache,
+	mle = kmem_cache_alloc(dlm_mle_cache,
 								GFP_NOFS);
 	if (!mle) {
 		mlog_errno(ret);
@@ -3036,7 +3034,7 @@ int dlm_migrate_request_handler(struct o2net_msg *msg, u32 len, void *data,
 	hash = dlm_lockid_hash(name, namelen);
 
 	/* preallocate.. if this fails, abort */
-	mle = (struct dlm_master_list_entry *) kmem_cache_alloc(dlm_mle_cache,
+	mle = kmem_cache_alloc(dlm_mle_cache,
 							 GFP_NOFS);
 
 	if (!mle) {
-- 
1.5.4.3

