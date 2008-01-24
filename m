Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbYAXTiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbYAXTiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYAXTfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:05 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46546 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbYAXTeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:36 -0500
Message-Id: <20080124193432.492168716@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:53 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 12/26] mount options: fix ext4
Content-Disposition: inline; filename=ext4_opts.patch
Cc: "Theodore Ts'o" <tytso@MIT.EDU>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add stripe= option to /proc/mounts for ext4 filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/ext4/super.c
===================================================================
--- linux.orig/fs/ext4/super.c	2008-01-23 12:57:07.000000000 +0100
+++ linux/fs/ext4/super.c	2008-01-23 21:43:51.000000000 +0100
@@ -742,7 +742,8 @@ static int ext4_show_options(struct seq_
 		seq_puts(seq, ",nomballoc");
 	if (!test_opt(sb, DELALLOC))
 		seq_puts(seq, ",nodelalloc");
-
+	if (sbi->s_stripe)
+		seq_printf(seq, ",stripe=%lu", sbi->s_stripe);
 
 	/*
 	 * journal mode get enabled in different ways

--
