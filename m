Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbXDASP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbXDASP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933783AbXDASP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:15:27 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:39394 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933760AbXDASPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:15:25 -0400
Date: Sun, 1 Apr 2007 20:15:09 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH 06/16] isofs-add-write-bit.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012005500.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add %S_IWUGO bit for isofs. Makes it easier to poke on files after
they have been copied from an ISO-9660 filesystem because they are
ofte copied in `cp -p` or perhaps `rsync -p` mode.
They are still not writable though, and isofs will continue to
correctly return -EROFS for writes.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

 inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc5/fs/isofs/inode.c
===================================================================
--- linux-2.6.21-rc5.orig/fs/isofs/inode.c
+++ linux-2.6.21-rc5/fs/isofs/inode.c
@@ -362,7 +362,7 @@ static int parse_options(char *options, 
 	popt->check = 'u';		/* unset */
 	popt->nocompress = 0;
 	popt->blocksize = 1024;
-	popt->mode = S_IRUGO | S_IXUGO; /* r-x for all.  The disc could
+	popt->mode = S_IRUGO | S_IWUSR | S_IXUGO; /* rwx for all.  The disc could
 					   be shared with DOS machines so
 					   virtually anything could be
 					   a valid executable. */
@@ -1221,7 +1221,7 @@ static void isofs_read_inode(struct inod
 	ei->i_file_format = isofs_file_normal;
 
 	if (de->flags[-high_sierra] & 2) {
-		inode->i_mode = S_IRUGO | S_IXUGO | S_IFDIR;
+		inode->i_mode = S_IRUGO | S_IWUSR | S_IXUGO | S_IFDIR;
 		inode->i_nlink = 1; /* Set to 1.  We know there are 2, but
 				       the find utility tries to optimize
 				       if it is 2, and it screws up.  It is
#<EOF>

