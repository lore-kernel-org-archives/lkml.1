Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbYJ0Egt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbYJ0Egt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 00:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbYJ0Egm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 00:36:42 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:17042
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbYJ0Egl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 00:36:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEviBEl8qQJT/2dsb2JhbAC/b4NP
X-IronPort-AV: E=Sophos;i="4.33,490,1220198400"; 
   d="scan'208";a="268494684"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH] autofs4 - fix var shadowed by local delaration
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 27 Oct 2008 13:36:36 +0900
Message-ID: <20081027043636.15523.95519.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A local definition of devid in autofs_dev_ioctl_ismountpoint() shadows
the fuction wide definition.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/dev-ioctl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index a040639..e19d584 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -597,17 +597,17 @@ static int autofs_dev_ioctl_ismountpoint(struct file *fp,
 			magic = nd.path.dentry->d_inode->i_sb->s_magic;
 		}
 	} else {
-		dev_t devid = new_encode_dev(sbi->sb->s_dev);
+		dev_t dev = autofs4_get_dev(sbi);
 
 		err = path_lookup(path, LOOKUP_PARENT, &nd);
 		if (err)
 			goto out;
 
-		err = autofs_dev_ioctl_find_super(&nd, devid);
+		err = autofs_dev_ioctl_find_super(&nd, dev);
 		if (err)
 			goto out_release;
 
-		devid = autofs4_get_dev(sbi);
+		devid = dev;
 
 		err = have_submounts(nd.path.dentry);
 

