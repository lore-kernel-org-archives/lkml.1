Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYBHVlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYBHVlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYBHVlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:41:00 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:45439 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbYBHVk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:40:59 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] tty: BKL pushdown fix1
Date: Fri,  8 Feb 2008 22:40:56 +0100
Message-Id: <1202506856-3403-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <47ACCBD4.1000502@gmail.com>
References: <47ACCBD4.1000502@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 fs/compat_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index c6e72ae..9663e87 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1046,7 +1046,7 @@ static int vt_check(struct file *file)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct vc_data *vc;
 	
-	if (file->f_op->ioctl != tty_ioctl)
+	if (file->f_op->unlocked_ioctl != tty_ioctl)
 		return -EINVAL;
 	                
 	tty = (struct tty_struct *)file->private_data;
-- 
1.5.3.8

