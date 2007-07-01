Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbXGAWPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbXGAWPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 18:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXGAWOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 18:14:54 -0400
Received: from smtp113.plus.mail.re1.yahoo.com ([69.147.102.76]:30208 "HELO
	smtp113.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752844AbXGAWOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 18:14:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=3WZ6xblcTmZ5Bnj9KrqnZmWK/wQebVZhK0z0Y2c8MI+eXPfXH+8+FvXkYjkChlYf5PiPWoLEOp0dnyva+y5g1s/M8+vUBb8h/w7klZ2dkY5lbXM5ylQ6k1OUVUxIRoyGhxrJtw/BzRWMVzBuOgxvUKRzxzX+xeQMkfuHnsjfslw=  ;
X-YMail-OSG: L0VsNH4VM1l_nSOa70iaBJTIeJMiY0gh7ozCk2RL9bRbqyD96wKXKhLWOGPYLjwNYcS7JqcSkQ--
Date: Mon, 2 Jul 2007 00:11:11 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fix error handling in ext3_create_journal
Message-ID: <20070701221111.GA8627@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


---
From: Borislav Petkov <bbpetkov@yahoo.de>

Fix error handling in ext3_create_journal according to kernel conventions.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
--

Index: linux-2.6.22-rc6/fs/ext3/super.c
===================================================================
--- linux-2.6.22-rc6/fs/ext3/super.c.orig	2007-07-01 21:12:51.000000000 +0200
+++ linux-2.6.22-rc6/fs/ext3/super.c	2007-07-01 21:14:32.000000000 +0200
@@ -2075,6 +2075,7 @@
 			       unsigned int journal_inum)
 {
 	journal_t *journal;
+	int err;
 
 	if (sb->s_flags & MS_RDONLY) {
 		printk(KERN_ERR "EXT3-fs: readonly filesystem when trying to "
@@ -2082,13 +2083,15 @@
 		return -EROFS;
 	}
 
-	if (!(journal = ext3_get_journal(sb, journal_inum)))
+	journal = ext3_get_journal(sb, journal_inum);
+	if (!journal)
 		return -EINVAL;
 
 	printk(KERN_INFO "EXT3-fs: creating new journal on inode %u\n",
 	       journal_inum);
 
-	if (journal_create(journal)) {
+	err = journal_create(journal);
+	if (err) {
 		printk(KERN_ERR "EXT3-fs: error creating journal.\n");
 		journal_destroy(journal);
 		return -EIO;
-- 
Regards/Gruﬂ,
    Boris.
