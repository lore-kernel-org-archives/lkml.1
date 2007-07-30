Return-Path: <linux-kernel-owner+w=401wt.eu-S939283AbXG3QQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939283AbXG3QQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934069AbXG3QOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:11 -0400
Received: from mail.suse.de ([195.135.220.2]:40549 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764775AbXG3QOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:05 -0400
Message-Id: <20070730161323.987896048@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:32 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 09/26] linux/stat.h: Add the filetype white-out
Content-Disposition: inline; filename=um/stat-add-S_IFWHT.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A white-out stops the VFS from further lookups of the white-out's name and
returns -ENOENT. This is the same behaviour as if the filename isn't
found. This can be used in combination with union mounts to virtually
delete (white-out) files by creating a file of this file type.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 include/linux/stat.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -10,6 +10,7 @@
 #if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
 
 #define S_IFMT  00170000
+#define S_IFWHT  0160000	/* whiteout */
 #define S_IFSOCK 0140000
 #define S_IFLNK	 0120000
 #define S_IFREG  0100000
@@ -28,6 +29,7 @@
 #define S_ISBLK(m)	(((m) & S_IFMT) == S_IFBLK)
 #define S_ISFIFO(m)	(((m) & S_IFMT) == S_IFIFO)
 #define S_ISSOCK(m)	(((m) & S_IFMT) == S_IFSOCK)
+#define S_ISWHT(m)	(((m) & S_IFMT) == S_IFWHT)
 
 #define S_IRWXU 00700
 #define S_IRUSR 00400

-- 

