Return-Path: <linux-kernel-owner+w=401wt.eu-S965481AbXCFSHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965481AbXCFSHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965975AbXCFSGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:06:45 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:39621 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965469AbXCFSGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:06:20 -0500
Message-Id: <20070306180557.611121214@szeredi.hu>
References: <20070306180443.669036741@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 Mar 2007 19:04:51 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 8/8] consolidate generic_writepages and mpage_writepages fix
Content-Disposition: inline; filename=writepages_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Fix NULL pointer dereference in __mpage_writepage.  This probably
doesn't matter in practice, but this is the original behavior.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/mpage.c
===================================================================
--- linux.orig/fs/mpage.c	2007-03-06 17:30:09.000000000 +0100
+++ linux/fs/mpage.c	2007-03-06 17:30:33.000000000 +0100
@@ -662,7 +662,7 @@ confused:
 	if (bio)
 		bio = mpage_bio_submit(WRITE, bio);
 
-	if (mpd->use_writepage) {
+	if (mpd->use_writepage && mapping->a_ops->writepage) {
 		ret = mapping->a_ops->writepage(page, wbc);
 	} else {
 		ret = -EAGAIN;

--
