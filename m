Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYAXThg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYAXThg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbYAXTfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:01 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46542 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120AbYAXTef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:35 -0500
Message-Id: <20080124193430.818971789@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:52 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 11/26] mount options: fix ext2
Content-Disposition: inline; filename=ext2_opts.patch
Cc: "Theodore Ts'o" <tytso@MIT.EDU>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add noreservation option to /proc/mounts for ext2 filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/ext2/super.c
===================================================================
--- linux.orig/fs/ext2/super.c	2008-01-17 19:00:55.000000000 +0100
+++ linux/fs/ext2/super.c	2008-01-23 21:38:08.000000000 +0100
@@ -285,6 +285,9 @@ static int ext2_show_options(struct seq_
 		seq_puts(seq, ",xip");
 #endif
 
+	if (!test_opt(sb, RESERVATION))
+		seq_puts(seq, ",noreservation");
+
 	return 0;
 }
 

--
