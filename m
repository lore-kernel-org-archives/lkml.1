Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZK3JhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZK3JhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZK3JhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:37:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbZK3JhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:37:09 -0500
Date: Mon, 30 Nov 2009 04:36:30 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
       Christoph Hellwig <hch@lst.de>, Amerigo Wang <amwang@redhat.com>,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Message-Id: <20091130093929.4559.4449.sendpatchset@localhost.localdomain>
Subject: [Patch] fs: move a definition out of switch block
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's not a good practice to leave a definition between
'switch' and the its first label.

Move it out of the switch block.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>

---
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 2cf93ec..23b0238 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -514,12 +514,12 @@ static void send_sigio_to_task(struct task_struct *p,
 	 * sure we read it once and use the same value throughout.
 	 */
 	int signum = ACCESS_ONCE(fown->signum);
+	siginfo_t si;
 
 	if (!sigio_perm(p, fown, signum))
 		return;
 
 	switch (signum) {
-		siginfo_t si;
 		default:
 			/* Queue a rt signal with the appropriate fd as its
 			   value.  We use SI_SIGIO as the source, not 
