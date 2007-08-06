Return-Path: <linux-kernel-owner+w=401wt.eu-S934285AbXHFOGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285AbXHFOGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbXHFNzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:55:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939AbXHFNzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:55:21 -0400
Date: Mon, 6 Aug 2007 09:55:19 -0400
Message-Id: <200708061355.l76DtJ1c002390@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 24/25] tmpfs: call attr_kill_to_mode from shmem_notify_change
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 mm/shmem.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fcd19d3..d3b5421 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -719,6 +719,8 @@ static int shmem_notify_change(struct dentry *dentry, struct iattr *attr)
 	struct page *page = NULL;
 	int error;
 
+	attr_kill_to_mode(inode, attr);
+
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
 		if (attr->ia_size < inode->i_size) {
 			/*
-- 
1.5.2.2

