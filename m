Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbYFXJTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbYFXJTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYFXJTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:19:13 -0400
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:2818 "EHLO
	anchor-post-35.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbYFXJTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:19:12 -0400
Subject: [PATCH] file lock: reorder struct file_lock to save space on 64
	bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: matthew@wil.cx
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 10:18:24 +0100
Message-Id: <1214299104.3815.5.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reduce sizeof struct file_lock by 8 on 64 bit builds allowing +1 objects
per slab in the file_lock_cache
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---

patch against 2.6.26-rc7
successfully running on AMD64 desktop.

Richard
 


diff --git a/include/linux/fs.h b/include/linux/fs.h
index d490779..a0735d7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -919,12 +919,12 @@ struct file_lock {
 	struct list_head fl_link;	/* doubly linked list of all locks */
 	struct list_head fl_block;	/* circular list of blocked processes */
 	fl_owner_t fl_owner;
+	unsigned char fl_flags;
+	unsigned char fl_type;
 	unsigned int fl_pid;
 	struct pid *fl_nspid;
 	wait_queue_head_t fl_wait;
 	struct file *fl_file;
-	unsigned char fl_flags;
-	unsigned char fl_type;
 	loff_t fl_start;
 	loff_t fl_end;
 


