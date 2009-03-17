Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbZCQVGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbZCQVGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbZCQVGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:06:17 -0400
Received: from ns2.suse.de ([195.135.220.15]:54764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbZCQVGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:06:14 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] fs: Warn about writing !uptodate buffers
Date: Tue, 17 Mar 2009 18:33:55 +0100
Message-Id: <1237311235-13623-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237311235-13623-4-git-send-email-jack@suse.cz>
References: <n>
 <1237311235-13623-1-git-send-email-jack@suse.cz>
 <1237311235-13623-2-git-send-email-jack@suse.cz>
 <1237311235-13623-3-git-send-email-jack@suse.cz>
 <1237311235-13623-4-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make submit_bh() warn about writing !uptodate buffers. Hopefully this
warns us about writing garbage (although bugs in write EIO handling
are going to trigger this as well as they already trigger the warning
in mark_buffer_dirty()).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 22c0144..985f617 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2997,6 +2997,8 @@ int submit_bh(int rw, struct buffer_head * bh)
 	BUG_ON(!buffer_locked(bh));
 	BUG_ON(!buffer_mapped(bh));
 	BUG_ON(!bh->b_end_io);
+	if (rw & WRITE)
+		WARN_ON_ONCE(!buffer_uptodate(bh));
 
 	/*
 	 * Mask in barrier bit for a write (could be either a WRITE or a
-- 
1.6.0.2

