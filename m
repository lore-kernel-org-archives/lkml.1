Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbYDRSS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbYDRSS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759550AbYDRSRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:17:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759467AbYDRSRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:17:39 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] dlm: save master info after failed no-queue request
Date: Fri, 18 Apr 2008 13:12:45 -0500
Message-Id: <1208542368-13417-4-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a NOQUEUE request fails, the rsb res_master field is unnecessarily
reset to -1, instead of leaving the valid master setting in place.  We
want to save the looked-up master values while the rsb is on the "toss
list" so that another lookup can be avoided if the rsb is soon reused.
The fix is to simply leave res_master value alone.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 1e9e8eb..2d3d102 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1956,8 +1956,7 @@ static void confirm_master(struct dlm_rsb *r, int error)
 			list_del_init(&lkb->lkb_rsb_lookup);
 			r->res_first_lkid = lkb->lkb_id;
 			_request_lock(r, lkb);
-		} else
-			r->res_nodeid = -1;
+		}
 		break;
 
 	default:
-- 
1.5.3.3

