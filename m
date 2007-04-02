Return-Path: <linux-kernel-owner+w=401wt.eu-S965908AbXDBVJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965908AbXDBVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965913AbXDBVJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:09:28 -0400
Received: from smtp.movial.fi ([62.236.91.34]:55531 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965908AbXDBVJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:09:27 -0400
X-Greylist: delayed 1291 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 17:09:27 EDT
Date: Mon, 2 Apr 2007 23:47:54 +0300
From: Timo Savola <tsavola@movial.fi>
To: miklos@szeredi.hu
Cc: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net
Subject: [PATCH] FUSE: Validate rootmode mount option
Message-ID: <20070402204749.GA11774@movial.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If rootmode doesn't include any file type bits, we hit the BUG() in
fuse_init_inode.  Now EINVAL is returned.

Signed-off-by: Timo Savola <tsavola@movial.fi>
---
 fs/fuse/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 5ab8e50..503c9cd 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -330,6 +330,8 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 		case OPT_ROOTMODE:
 			if (match_octal(&args[0], &value))
 				return 0;
+			if ((value & S_IFMT) == 0)
+				return 0;
 			d->rootmode = value;
 			d->rootmode_present = 1;
 			break;
-- 
1.4.4.4

