Return-Path: <linux-kernel-owner+w=401wt.eu-S1751131AbXBWAkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbXBWAkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 19:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXBWAkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 19:40:21 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40273 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbXBWAkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 19:40:19 -0500
Date: Thu, 22 Feb 2007 18:40:17 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] eCryptfs: no path_release() after path_lookup() error
Message-ID: <20070223004017.GB22628@us.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070223003803.GA22599@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223003803.GA22599@us.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitriy Monakhov wrote:
> if path_lookup() return non zero code we don't have to worry about
> 'nd' parameter, but ecryptfs_read_super does path_release(&nd) after
> path_lookup has failed, and dentry counter becomes negative

Do not do a path_release after a path_lookup error.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 80044d1..812427e 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -487,7 +487,7 @@ static int ecryptfs_read_super(struct super_block *sb, const char *dev_name)
 	rc = path_lookup(dev_name, LOOKUP_FOLLOW, &nd);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "path_lookup() failed\n");
-		goto out_free;
+		goto out;
 	}
 	lower_root = nd.dentry;
 	if (!lower_root->d_inode) {
-- 
1.4.4.4

