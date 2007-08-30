Return-Path: <linux-kernel-owner+w=401wt.eu-S1761763AbXH3PCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761763AbXH3PCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760215AbXH3PCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:02:00 -0400
Received: from ns1.suse.de ([195.135.220.2]:56655 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181AbXH3PB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:01:59 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: David Howells <dhowells@redhat.com>
Subject: [FIX] mntput called before dput in afs
Date: Thu, 30 Aug 2007 17:01:36 +0200
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
References: <20070808171622.632749741@suse.de> <20070810143846.930027497@suse.de> <20070829190823.GB28028@infradead.org>
In-Reply-To: <20070829190823.GB28028@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301701.36533.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

dput must be called before mntput here. Please consider for 2.6.24 and stable.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/afs/mntpt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -235,8 +235,8 @@ static void *afs_mntpt_follow_link(struc
 	err = do_add_mount(newmnt, nd, MNT_SHRINKABLE, &afs_vfsmounts);
 	switch (err) {
 	case 0:
-		mntput(nd->mnt);
 		dput(nd->dentry);
+		mntput(nd->mnt);
 		nd->mnt = newmnt;
 		nd->dentry = dget(newmnt->mnt_root);
 		schedule_delayed_work(&afs_mntpt_expiry_timer,
