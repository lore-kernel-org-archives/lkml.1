Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbXA3Wlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbXA3Wlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXA3Wlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:41:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:64471 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbXA3Wli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:41:38 -0500
Date: Tue, 30 Jan 2007 23:40:35 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: akpm@osdl.org, Jeff Layton <jlayton@redhat.com>, dev@sw.ru,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       torvalds@osdl.org
Subject: [PATCH] pipefs unique inode numbers
Message-ID: <Pine.LNX.4.58.0701302314210.2203@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX1/HqB2Rfur3GFQQtrl2Ipd0zXgpESjD0xGspdvwQ0f9t80kWfMp1vBlCjRZfgV6mHzEHQwVzDxGsuJhiyPZ3nDlOh3+reO4RUhPcnCfJpNaEA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

change pipefs to use a unique inode number equal to the memory
address unless it would be truncated.

Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
---
Tested on i386.

--- 2.6.19/fs/pipe.c.ori	2007-01-30 22:02:46.000000000 +0100
+++ 2.6.19/fs/pipe.c	2007-01-30 23:22:27.000000000 +0100
@@ -864,6 +864,10 @@ static struct inode * get_pipe_inode(voi
 	inode->i_uid = current->fsuid;
 	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	/* The address of *inode is unique, so we'll get an unique inode number.
+	 * Off cause this will not work for 32 bit inodes on 64 bit systems. */
+	if (sizeof(inode->i_ino) >= sizeof(struct inode*))
+		inode->i_ino = (unsigned int) inode;
 
 	return inode;
 
