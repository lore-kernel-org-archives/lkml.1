Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbYFUMiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbYFUMiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 08:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYFUMh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 08:37:56 -0400
Received: from ixia01.ro.gtsce.net ([212.146.94.66]:4975 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750800AbYFUMhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 08:37:55 -0400
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: IXIA
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ramfs: enable splice write
Date: Sat, 21 Jun 2008 15:36:18 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CXPXIE18Zmpea2X"
Message-Id: <200806211536.18484.opurdila@ixiacom.com>
X-OriginalArrivalTime: 21 Jun 2008 12:39:04.0168 (UTC) FILETIME=[C9F44680:01C8D39B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_CXPXIE18Zmpea2X
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hi Andrew,

Any reason for which we don't enable splice write in ramfs? The following 
patch seems to make splice write work on my system (only tested the MMU 
path).

Thanks,
tavi

--Boundary-00=_CXPXIE18Zmpea2X
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

commit da8e2b1f4d096796a5e2f1b11d4a32a78eca0eae
Author: Octavian Purdila <opurdila@ixiacom.com>
Date:   Sat Jun 21 15:14:40 2008 +0300

    ramfs: enable splice write
    
    Signed-off-by: Octavian Purdila <opurdila@ixiacom.com>

diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
index 9590b90..78f613c 100644
--- a/fs/ramfs/file-mmu.c
+++ b/fs/ramfs/file-mmu.c
@@ -45,6 +45,7 @@ const struct file_operations ramfs_file_operations = {
 	.mmap		= generic_file_mmap,
 	.fsync		= simple_sync_file,
 	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
 	.llseek		= generic_file_llseek,
 };
 
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 0989bc2..52312ec 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -43,6 +43,7 @@ const struct file_operations ramfs_file_operations = {
 	.aio_write		= generic_file_aio_write,
 	.fsync			= simple_sync_file,
 	.splice_read		= generic_file_splice_read,
+	.splice_write		= generic_file_splice_write,
 	.llseek			= generic_file_llseek,
 };
 

--Boundary-00=_CXPXIE18Zmpea2X--
