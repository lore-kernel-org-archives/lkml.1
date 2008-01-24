Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYAXTnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYAXTnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbYAXTfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:46 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46572 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377AbYAXTeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:50 -0500
Message-Id: <20080124193445.807705054@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:34:00 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 19/26] mount options: fix jfs
Content-Disposition: inline; filename=jfs_opts.patch
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add iocharset= and errors= options to /proc/mounts for jfs
filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/jfs/super.c
===================================================================
--- linux.orig/fs/jfs/super.c	2008-01-17 19:00:55.000000000 +0100
+++ linux/fs/jfs/super.c	2008-01-21 19:39:30.000000000 +0100
@@ -602,6 +602,12 @@ static int jfs_show_options(struct seq_f
 		seq_printf(seq, ",umask=%03o", sbi->umask);
 	if (sbi->flag & JFS_NOINTEGRITY)
 		seq_puts(seq, ",nointegrity");
+	if (sbi->nls_tab)
+		seq_printf(seq, ",iocharset=%s", sbi->nls_tab->charset);
+	if (sbi->flag & JFS_ERR_CONTINUE)
+		seq_printf(seq, ",errors=continue");
+	if (sbi->flag & JFS_ERR_PANIC)
+		seq_printf(seq, ",errors=panic");
 
 #ifdef CONFIG_QUOTA
 	if (sbi->flag & JFS_USRQUOTA)

--
