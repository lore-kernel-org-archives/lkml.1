Return-Path: <linux-kernel-owner+w=401wt.eu-S1762536AbZBECHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762536AbZBECHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZBECHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:07:15 -0500
Received: from smtp-out.google.com ([216.239.45.13]:63364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZBECHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:07:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:content-type;
	b=RS1knS/dSHn8D922Nah1ATtxogEKEqOKfLkFbJ8MMYRY73pTj8XJNIpd3ehL8EbIj
	0bqsRMZzYrYBpTMrJPgDQ==
Date: Wed, 4 Feb 2009 18:06:11 -0800 (PST)
From: Paul Turner <pjt@google.com>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, ebierderm@xmission.com
Subject: [PATCH] Separate FMODE_PREAD/FMODE_PWRITE into separate flags
Message-ID: <Pine.LNX.4.64.0902041736080.15728@kitami.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate FMODE_PREAD and FMODE_PWRITE into separate flags to reflect the
reality that the read and write paths may have independent restrictions.

A git grep verifies that these flags are always cleared together so this new
behavior will only apply to interfaces that change to clear flags individually.

Signed-off-by: Paul Turner <pjt@google.com>
---
 include/linux/fs.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6022f44..d6a51d9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -60,18 +60,19 @@ struct inodes_stat_t {
 #define FMODE_WRITE		((__force fmode_t)2)
 /* file is seekable */
 #define FMODE_LSEEK		((__force fmode_t)4)
-/* file can be accessed using pread/pwrite */
+/* file can be accessed using pread */
 #define FMODE_PREAD		((__force fmode_t)8)
-#define FMODE_PWRITE		FMODE_PREAD	/* These go hand in hand */
+/* file can be accessed using pwrite */
+#define FMODE_PWRITE		((__force fmode_t)16)
 /* File is opened for execution with sys_execve / sys_uselib */
-#define FMODE_EXEC		((__force fmode_t)16)
+#define FMODE_EXEC		((__force fmode_t)32)
 /* File is opened with O_NDELAY (only set for block devices) */
-#define FMODE_NDELAY		((__force fmode_t)32)
+#define FMODE_NDELAY		((__force fmode_t)64)
 /* File is opened with O_EXCL (only set for block devices) */
-#define FMODE_EXCL		((__force fmode_t)64)
+#define FMODE_EXCL		((__force fmode_t)128)
 /* File is opened using open(.., 3, ..) and is writeable only for ioctls
    (specialy hack for floppy.c) */
-#define FMODE_WRITE_IOCTL	((__force fmode_t)128)
+#define FMODE_WRITE_IOCTL	((__force fmode_t)256)
 
 /*
  * Don't update ctime and mtime.
-- 
1.5.4.5

