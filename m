Return-Path: <linux-kernel-owner+w=401wt.eu-S1761161AbXGFOAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761161AbXGFOAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXGFOAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:00:09 -0400
Received: from mail.macqel.be ([194.78.208.39]:12551 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbXGFOAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:00:07 -0400
Date: Fri, 6 Jul 2007 16:00:02 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] block : make partitions_op & diskstats_op const
Message-ID: <20070706140002.GA13275@muff.macqel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Make partitions_op & diskstats_op const

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r 6c0a10cc415a block/genhd.c
--- a/block/genhd.c	Thu Jul  5 16:10:16 2007 -0700
+++ b/block/genhd.c	Fri Jul  6 15:57:07 2007 +0200
@@ -328,7 +328,7 @@ static int show_partition(struct seq_fil
 	return 0;
 }
 
-struct seq_operations partitions_op = {
+const struct seq_operations partitions_op = {
 	.start =part_start,
 	.next =	part_next,
 	.stop =	part_stop,
@@ -689,7 +689,7 @@ static int diskstats_show(struct seq_fil
 	return 0;
 }
 
-struct seq_operations diskstats_op = {
+const struct seq_operations diskstats_op = {
 	.start	= diskstats_start,
 	.next	= diskstats_next,
 	.stop	= diskstats_stop,
diff -r 6c0a10cc415a fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c	Thu Jul  5 16:10:16 2007 -0700
+++ b/fs/proc/proc_misc.c	Fri Jul  6 15:57:07 2007 +0200
@@ -357,7 +357,7 @@ static int stram_read_proc(char *page, c
 #endif
 
 #ifdef CONFIG_BLOCK
-extern struct seq_operations partitions_op;
+extern const struct seq_operations partitions_op;
 static int partitions_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &partitions_op);
@@ -369,7 +369,7 @@ static const struct file_operations proc
 	.release	= seq_release,
 };
 
-extern struct seq_operations diskstats_op;
+extern const struct seq_operations diskstats_op;
 static int diskstats_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &diskstats_op);
