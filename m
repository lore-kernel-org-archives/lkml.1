Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792Ab0BQJwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:52:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933738Ab0BQJv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:51:57 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/2] dlm: Remove obsolete lockspace lookup
Date: Wed, 17 Feb 2010 09:41:35 +0000
Message-Id: <1266399695-29885-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1266399695-29885-2-git-send-email-swhiteho@redhat.com>
References: <1266399695-29885-1-git-send-email-swhiteho@redhat.com>
 <1266399695-29885-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to look up the lockspace in this particular
case since we already have a pointer to it (which was being
dereferenced in order to do the lookup in the first place).

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/dlm/lockspace.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 26a8bd4..ce0fdf5 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -37,10 +37,6 @@ static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
 	ssize_t ret = len;
 	int n = simple_strtol(buf, NULL, 0);
 
-	ls = dlm_find_lockspace_local(ls->ls_local_handle);
-	if (!ls)
-		return -EINVAL;
-
 	switch (n) {
 	case 0:
 		dlm_ls_stop(ls);
@@ -51,7 +47,7 @@ static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
 	default:
 		ret = -EINVAL;
 	}
-	dlm_put_lockspace(ls);
+
 	return ret;
 }
 
-- 
1.6.2.5

