Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZDSSmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZDSSmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 14:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbZDSSmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 14:42:39 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:48172 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZDSSmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 14:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=xlO3EPFKnviTPpumPTrSmnPn97jyTpleyMwAlGQ8LtBVRxuGurr2PLBZbXtmlpV0Ly
         I4bkj2GYfTh8DJbfyqifb6iEYDzYKY0FK7YNeage9DjmgYq0kCKO55721ZndPoORDvw4
         Au3pAl4U/JI9W4cHg4EdP4EnwISbaYXy8lhNY=
Message-ID: <49EB7087.70302@gmail.com>
Date: Sun, 19 Apr 2009 20:42:15 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs: add roundup_to_blocksize and bytes_to_blocks helper functions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bytes_to_blocks is open coded in more than 30 places
roundup_to_blocksize is open coded in more than 15 places

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 include/linux/fs.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index e766be0..1b4e5b6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2451,5 +2451,17 @@ int proc_nr_files(struct ctl_table *table, int write, struct file *filp,
 
 int get_filesystem_list(char * buf);
 
+static inline
+unsigned long long roundup_to_blocksize(unsigned long long bytes, struct super_block *sb)
+{
+	return (bytes + sb->s_blocksize - 1) & ~(sb->s_blocksize - 1);
+}
+
+static inline
+blkcnt_t bytes_to_blocks(unsigned long long bytes, struct super_block *sb)
+{
+	return (bytes + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
+}
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
-- 
1.6.0.6

