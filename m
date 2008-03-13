Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbYCMVaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbYCMVaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbYCMV2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:28:08 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51628 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbYCMV1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:27:53 -0400
Message-Id: <20080313212732.390688144@szeredi.hu>
References: <20080313212641.989467982@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 13 Mar 2008 22:26:42 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/6] vfs: mountinfo -mm fix
Content-Disposition: inline; filename=mountinfo_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The read-only flag showing got broken by the ro-bind patches going in
and out of -mm.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-03-13 20:45:15.000000000 +0100
+++ linux/fs/namespace.c	2008-03-13 20:45:49.000000000 +0100
@@ -789,9 +789,9 @@ static int show_mountinfo(struct seq_fil
 	seq_dentry(m, mnt->mnt_root, " \t\n\\");
 	seq_putc(m, ' ');
 	seq_path(m, &mnt_path, " \t\n\\");
+	seq_puts(m, mnt->mnt_flags & MNT_READONLY ? " ro" : " rw");
 	show_mnt_opts(m, mnt);
-	seq_putc(m, ' ');
-	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
+	seq_puts(m, sb->s_flags & MS_RDONLY ? " ro" : " rw");
 	show_sb_opts(m, sb);
 	if (sb->s_op->show_options)
 		err = sb->s_op->show_options(m, mnt);

--
