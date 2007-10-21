Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbXJUQ6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbXJUQ6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 12:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbXJUQ5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 12:57:54 -0400
Received: from pat.uio.no ([129.240.10.15]:49153 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbXJUQ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 12:57:53 -0400
Subject: Re: nfsv2 ref leak in 2.6.24?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: bfields@fieldses.org, nfs@lists.sourceforge.net, neilb@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200710202135.l9KLZJIB023526@agora.fsl.cs.sunysb.edu>
References: <200710202135.l9KLZJIB023526@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Sun, 21 Oct 2007 12:58:12 -0400
Message-Id: <1192985892.7505.32.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.082)
X-UiO-Scanned: FED97B950C9E8DD9D61BFCEE36391DA31ED47C41
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 541 total 4619802 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-10-20 at 17:35 -0400, Erez Zadok wrote:

> Trond, I verified that w/ the above patch the problem is w/ nfs: the client
> leaves .nfsXXX files behind for every file unlinked while open.  Let me know
> when you get a fix and I'll test it.

Doh... Another typo.

Trond
-------------------------- CUT HERE --------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sun, 21 Oct 2007 12:02:22 -0400
NFS: Fix a typo in nfs_call_unlink()

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/unlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index ce558c2..233ad38 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -171,7 +171,7 @@ static int nfs_call_unlink(struct dentry *dentry, struct nfs_unlinkdata *data)
 	if (parent == NULL)
 		goto out_free;
 	dir = parent->d_inode;
-	if (nfs_copy_dname(dentry, data) == 0)
+	if (nfs_copy_dname(dentry, data) != 0)
 		goto out_dput;
 	/* Non-exclusive lock protects against concurrent lookup() calls */
 	spin_lock(&dir->i_lock);


