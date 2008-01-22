Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbYAVDIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbYAVDIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbYAVDF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:05:28 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65333 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757514AbYAVDFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:05:24 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH 42/49] ext4: Enable the multiblock allocator by default
Date: Mon, 21 Jan 2008 22:02:21 -0500
Message-Id: <1200970948-17903-43-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-42-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
 <1200970948-17903-25-git-send-email-tytso@mit.edu>
 <1200970948-17903-26-git-send-email-tytso@mit.edu>
 <1200970948-17903-27-git-send-email-tytso@mit.edu>
 <1200970948-17903-28-git-send-email-tytso@mit.edu>
 <1200970948-17903-29-git-send-email-tytso@mit.edu>
 <1200970948-17903-30-git-send-email-tytso@mit.edu>
 <1200970948-17903-31-git-send-email-tytso@mit.edu>
 <1200970948-17903-32-git-send-email-tytso@mit.edu>
 <1200970948-17903-33-git-send-email-tytso@mit.edu>
 <1200970948-17903-34-git-send-email-tytso@mit.edu>
 <1200970948-17903-35-git-send-email-tytso@mit.edu>
 <1200970948-17903-36-git-send-email-tytso@mit.edu>
 <1200970948-17903-37-git-send-email-tytso@mit.edu>
 <1200970948-17903-38-git-send-email-tytso@mit.edu>
 <1200970948-17903-39-git-send-email-tytso@mit.edu>
 <1200970948-17903-40-git-send-email-tytso@mit.edu>
 <1200970948-17903-41-git-send-email-tytso@mit.edu>
 <1200970948-17903-42-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Enable the multiblock allocator by default.

Fix ext4_show_options() so if it is not enabled, the nomballoc option
included in /proc/mounts.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 136d095..91a11ec 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -736,6 +736,8 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",nobh");
 	if (!test_opt(sb, EXTENTS))
 		seq_puts(seq, ",noextents");
+	if (!test_opt(sb, MBALLOC))
+		seq_puts(seq, ",nomballoc");
 	if (test_opt(sb, I_VERSION))
 		seq_puts(seq, ",i_version");
 
@@ -1902,6 +1904,11 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	 * User -o noextents to turn it off
 	 */
 	set_opt(sbi->s_mount_opt, EXTENTS);
+	/*
+	 * turn on mballoc feature by default in ext4 filesystem
+	 * User -o nomballoc to turn it off
+	 */
+	set_opt(sbi->s_mount_opt, MBALLOC);
 
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
 			    NULL, 0))
-- 
1.5.4.rc3.31.g1271-dirty

