Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYAXTjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYAXTjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYAXTfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:11 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46550 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbYAXTei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:38 -0500
Message-Id: <20080124193434.384314156@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:54 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 13/26] mount options: fix fat
Content-Disposition: inline; filename=fat_opts.patch
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add flush option to /proc/mounts for msdos and vfat filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fat/inode.c
===================================================================
--- linux.orig/fs/fat/inode.c	2008-01-17 19:00:55.000000000 +0100
+++ linux/fs/fat/inode.c	2008-01-21 19:00:40.000000000 +0100
@@ -837,6 +837,8 @@ static int fat_show_options(struct seq_f
 		if (!opts->numtail)
 			seq_puts(m, ",nonumtail");
 	}
+	if (sbi->options.flush)
+		seq_puts(m, ",flush");
 
 	return 0;
 }

--
