Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbXGAHgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbXGAHgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbXGAHgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:36:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51014 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbXGAHgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:36:03 -0400
Subject: [EXT4 set 1][PATCH 2/2] Enable extents by default for ext4dev
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Sun, 01 Jul 2007 03:36:01 -0400
Message-Id: <1183275361.4010.119.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Turn on extents feature by default in ext4 filesystem. User could use
-o noextents to turn it off.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.22-rc4/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 17:02:22.000000000 -0700
+++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 17:03:09.000000000 -0700
@@ -1546,6 +1546,12 @@
 
 	set_opt(sbi->s_mount_opt, RESERVATION);
 
+	/*
+	 * turn on extents feature by default in ext4 filesystem
+	 * User -o noextents to turn it off
+	 */
+	set_opt (sbi->s_mount_opt, EXTENTS);
+
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
 			    NULL, 0))
 		goto failed_mount;


