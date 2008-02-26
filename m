Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYBZEb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYBZEb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 23:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYBZEbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 23:31:46 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59594 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbYBZEbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 23:31:45 -0500
X-Sasl-enc: kcBIs0RM2xsYHB3s4MxZchZaSHlXIE8ZZK+EIgDz15D4 1204000303
Date: Tue, 26 Feb 2008 13:29:07 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/4] autofs4 - add mount option to display mount device
In-Reply-To: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
Message-ID: <Pine.LNX.4.64.0802261219500.8490@raven.themaw.net>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Patch to add a display mount option to show the device number
of the autofs mount super block.

Signed-off-by: Ian Kent < raven@themaw.net>

Ian

---
diff -up linux-2.6.25-rc2-mm1/fs/autofs4/inode.c.add-mount-device-display-option linux-2.6.25-rc2-mm1/fs/autofs4/inode.c
--- linux-2.6.25-rc2-mm1/fs/autofs4/inode.c.add-mount-device-display-option	2008-02-20 13:01:06.000000000 +0900
+++ linux-2.6.25-rc2-mm1/fs/autofs4/inode.c	2008-02-20 13:03:45.000000000 +0900
@@ -190,6 +190,7 @@ static int autofs4_show_options(struct s
 	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
 	seq_printf(m, ",minproto=%d", sbi->min_proto);
 	seq_printf(m, ",maxproto=%d", sbi->max_proto);
+	seq_printf(m, ",dev=%d", autofs4_get_dev(sbi));
 
 	if (sbi->type & AUTOFS_TYPE_OFFSET)
 		seq_printf(m, ",offset");
@@ -332,7 +333,7 @@ int autofs4_fill_super(struct super_bloc
 	sbi->sb = s;
 	sbi->version = 0;
 	sbi->sub_version = 0;
-	sbi->type = 0;
+	sbi->type = AUTOFS_TYPE_INDIRECT;
 	sbi->min_proto = 0;
 	sbi->max_proto = 0;
 	mutex_init(&sbi->wq_mutex);
 
