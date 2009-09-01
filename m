Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbZIAD0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbZIAD0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 23:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZIAD0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 23:26:24 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:30569
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbZIAD0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 23:26:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAK8wnEp8qSQS/2dsb2JhbADZOYQaBYFVYQ
X-IronPort-AV: E=Sophos;i="4.44,309,1249228800"; 
   d="scan'208";a="576268707"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH] autofs4 - fix missed case when changing to use struct path
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, aaron@merfinllc.com,
       stefan@farestam.net
Date: Tue, 01 Sep 2009 11:26:22 +0800
Message-ID: <20090901032622.27252.19646.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the recent change by Al Viro that changes verious subsystems
to use "struct path" one case was missed in the autofs4 module
which causes mounts to no longer expire.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/expire.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index aa39ae8..3da18d4 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -77,7 +77,7 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 	}
 
 	/* Update the expiry counter if fs is busy */
-	if (!may_umount_tree(mnt)) {
+	if (!may_umount_tree(path.mnt)) {
 		struct autofs_info *ino = autofs4_dentry_ino(top);
 		ino->last_used = jiffies;
 		goto done;

