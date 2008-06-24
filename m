Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYFXVK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYFXVK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYFXVJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:09:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbYFXVJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:09:57 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/2] [GFS2] BUG: unable to handle kernel paging request at ffff81002690e000
Date: Tue, 24 Jun 2008 21:20:18 +0100
Message-Id: <12143388271016-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12143388193217-git-send-email-swhiteho@redhat.com>
References: <12143388193217-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes bugzilla bug bz448866: gfs2: BUG: unable to
handle kernel paging request at ffff81002690e000.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 6387523..3401628 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -195,7 +195,7 @@ ulong_aligned:
 	   depending on architecture.  I've experimented with several ways
 	   of writing this section such as using an else before the goto
 	   but this one seems to be the fastest. */
-	while ((unsigned char *)plong < end - 1) {
+	while ((unsigned char *)plong < end - sizeof(unsigned long)) {
 		prefetch(plong + 1);
 		if (((*plong) & LBITMASK) != lskipval)
 			break;
-- 
1.5.1.2

