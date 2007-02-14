Return-Path: <linux-kernel-owner+w=401wt.eu-S1751142AbXBNHTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbXBNHTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 02:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbXBNHTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 02:19:21 -0500
Received: from koto.vergenet.net ([210.128.90.7]:33707 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbXBNHTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 02:19:19 -0500
Date: Wed, 14 Feb 2007 14:35:55 +0900
From: Simon Horman <horms@verge.net.au>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] VFS: initlalise found in fs/block_dev.c:bd_claim_by_kobject()
Message-ID: <20070214053552.GA8950@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes the following warning, which
by my reckoning is valid, though perhaps not
something that happens in practice.

fs/block_dev.c: In function `bd_claim_by_disk':
fs/block_dev.c:953: warning: 'found' might be used uninitialized in this
function

Patch is against the current Linus tree,
33e563c1190c26b6bf61990c505cdcb5cdbba7e4. 2.6.20+

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2007-02-14 13:31:48.000000000 +0900
+++ linux-2.6/fs/block_dev.c	2007-02-14 13:32:04.000000000 +0900
@@ -950,7 +950,7 @@
 				struct kobject *kobj)
 {
 	int res;
-	struct bd_holder *bo, *found;
+	struct bd_holder *bo, *found = NULL;
 
 	if (!kobj)
 		return -EINVAL;
