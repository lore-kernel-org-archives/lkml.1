Return-Path: <linux-kernel-owner+w=401wt.eu-S932942AbXBEOlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbXBEOlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXBEOlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:41:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932942AbXBEOle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:41:34 -0500
Subject: [DLM] zero new user lvbs [53/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:49:33 +0000
Message-Id: <1170686973.11001.377.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3c5b0f7925c4e4945f5589a6dd82c1eae81b17cc Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Wed, 31 Jan 2007 13:25:00 -0600
Subject: [PATCH] [DLM] zero new user lvbs

A new lvb for a userland lock wasn't being initialized to zero.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index c10257f..e725005 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3643,7 +3643,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 	}
 
 	if (flags & DLM_LKF_VALBLK) {
-		ua->lksb.sb_lvbptr = kmalloc(DLM_USER_LVB_LEN, GFP_KERNEL);
+		ua->lksb.sb_lvbptr = kzalloc(DLM_USER_LVB_LEN, GFP_KERNEL);
 		if (!ua->lksb.sb_lvbptr) {
 			kfree(ua);
 			__put_lkb(ls, lkb);
@@ -3712,7 +3712,7 @@ int dlm_user_convert(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	ua = (struct dlm_user_args *)lkb->lkb_astparam;
 
 	if (flags & DLM_LKF_VALBLK && !ua->lksb.sb_lvbptr) {
-		ua->lksb.sb_lvbptr = kmalloc(DLM_USER_LVB_LEN, GFP_KERNEL);
+		ua->lksb.sb_lvbptr = kzalloc(DLM_USER_LVB_LEN, GFP_KERNEL);
 		if (!ua->lksb.sb_lvbptr) {
 			error = -ENOMEM;
 			goto out_put;
-- 
1.4.4.2



