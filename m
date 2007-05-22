Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbXEVEe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbXEVEe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 00:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbXEVEeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 00:34:50 -0400
Received: from havoc.gtf.org ([69.61.125.42]:45874 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbXEVEet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 00:34:49 -0400
Date: Tue, 22 May 2007 00:34:49 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] smbfs: fix header_check (and build)
Message-ID: <20070522043448.GA6192@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The build dies in the header_check portion:
/garz/repo/linux-2.6/usr/include/linux/smb_fs.h requires linux/jiffies.h, which does not exist in exported headers
make[3]: *** [/garz/repo/linux-2.6/usr/include/linux/.check.smb_fs.h] Error 1

The solution is to move the jiffies.h include inside __KERNEL__.

Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/include/linux/smb_fs.h b/include/linux/smb_fs.h
index 6b51a48..d5212f0 100644
--- a/include/linux/smb_fs.h
+++ b/include/linux/smb_fs.h
@@ -9,7 +9,6 @@
 #ifndef _LINUX_SMB_FS_H
 #define _LINUX_SMB_FS_H
 
-#include <linux/jiffies.h>
 #include <linux/smb.h>
 
 /*
@@ -26,6 +25,7 @@
 #include <linux/smb_fs_i.h>
 #include <linux/smb_fs_sb.h>
 
+#include <linux/jiffies.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
