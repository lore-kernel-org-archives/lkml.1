Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYGYOww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYGYOww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYGYOwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:52:43 -0400
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:39781 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYGYOwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:52:42 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2008 10:52:42 EDT
X-IronPort-AV: E=Sophos;i="4.31,253,1215385200"; 
   d="scan'208";a="14935292"
Date: Fri, 25 Jul 2008 15:42:54 +0100
From: Mike Crowe <mac@mcrowe.com>
To: zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] HFSPLUS: Quieten down mounting hfsplus journaled fs read only
Message-ID: <20080725144254.GA29162@mcrowe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether the file system was to be mounted read only anyway
before warning about changing the mount to read only.

Signed-off-by: Mike Crowe <mac@mcrowe.com>
---
 fs/hfsplus/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index ce97a54..a99c3ce 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -356,7 +356,7 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 	} else if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_SOFTLOCK)) {
 		printk(KERN_WARNING "hfs: Filesystem is marked locked, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
-	} else if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) {
+	} else if ((vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) && !(sb->s_flags & MS_RDONLY)) {
 		printk(KERN_WARNING "hfs: write access to a journaled filesystem is not supported, "
 		       "use the force option at your own risk, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
-- 
1.5.6

