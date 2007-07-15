Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbXGOS6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbXGOS6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 14:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbXGOS6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 14:58:16 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:41651
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751483AbXGOS6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 14:58:16 -0400
Date: Sun, 15 Jul 2007 20:59:44 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: PATCH [1/5] fs/file_table.c: use list_for_each_entry() instead of list_for_each()
Message-ID: <20070715185944.GF4034@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070715185409.GE4034@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715185409.GE4034@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fs/file_table.c: use list_for_each_entry() instead of list_for_each()
in fs_may_remount_ro()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/fs/file_table.c b/fs/file_table.c
index d17fd69..3ddd993 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -264,12 +264,11 @@ void file_kill(struct file *file)
 
 int fs_may_remount_ro(struct super_block *sb)
 {
-	struct list_head *p;
+	struct file *file;
 
 	/* Check that no files are currently opened for writing. */
 	file_list_lock();
-	list_for_each(p, &sb->s_files) {
-		struct file *file = list_entry(p, struct file, f_u.fu_list);
+	list_for_each_entry(file, &sb->s_files, f_u.fu_list) {
 		struct inode *inode = file->f_path.dentry->d_inode;
 
 		/* File with pending delete? */

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      The assumption that what currently exists must necessarily
        exist is the acid that corrodes all visionary thinking
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
