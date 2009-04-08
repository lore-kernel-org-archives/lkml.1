Return-Path: <linux-kernel-owner+w=401wt.eu-S1765315AbZDHOEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765315AbZDHOEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbZDHOEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:04:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53479 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410AbZDHOEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:04:09 -0400
X-Sasl-enc: 2o3EONKiMQM4I0eIx1H5NbBnF2FP3KtA4LgI0wt46o/2 1239199448
Message-ID: <49DCAED6.1080404@fastmail.fm>
Date: Wed, 08 Apr 2009 15:04:06 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 36/56] ocfs2: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080519s2996a423yfe7eca91a411c8c1@mail.gmail.com>
In-Reply-To: <36ca99e90904080519s2996a423yfe7eca91a411c8c1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed Patch

Thanks,

Jack

--

ocfs2: Remove void casts

From: Jack Stone <jwjstone@fastmail.fm>

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---

 fs/ocfs2/dlm/dlmmaster.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index f8b653f..52ee37d 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -758,8 +758,7 @@ lookup:
         spin_unlock(&dlm->spinlock);
         mlog(0, "allocating a new resource\n");
         /* nothing found and we need to allocate one. */
-        alloc_mle = (struct dlm_master_list_entry *)
-            kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
+        alloc_mle = kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
         if (!alloc_mle)
             goto leave;
         res = dlm_new_lockres(dlm, lockid, namelen);
@@ -1543,8 +1542,7 @@ way_up_top:
             spin_unlock(&dlm->master_lock);
             spin_unlock(&dlm->spinlock);
 
-            mle = (struct dlm_master_list_entry *)
-                kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
+            mle = kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
             if (!mle) {
                 response = DLM_MASTER_RESP_ERROR;
                 mlog_errno(-ENOMEM);
@@ -2455,8 +2453,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
         goto leave;
     }
 
-    mle = (struct dlm_master_list_entry *) kmem_cache_alloc(dlm_mle_cache,
-                                GFP_NOFS);
+    mle = kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
     if (!mle) {
         mlog_errno(ret);
         goto leave;
@@ -3036,8 +3033,7 @@ int dlm_migrate_request_handler(struct o2net_msg
*msg, u32 len, void *data,
     hash = dlm_lockid_hash(name, namelen);
 
     /* preallocate.. if this fails, abort */
-    mle = (struct dlm_master_list_entry *) kmem_cache_alloc(dlm_mle_cache,
-                             GFP_NOFS);
+    mle = kmem_cache_alloc(dlm_mle_cache, GFP_NOFS);
 
     if (!mle) {
         ret = -ENOMEM;
