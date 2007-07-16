Return-Path: <linux-kernel-owner+w=401wt.eu-S1764036AbXGPFeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764036AbXGPFeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbXGPFeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:34:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50243 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751752AbXGPFeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:34:10 -0400
Date: Mon, 16 Jul 2007 15:33:40 +1000
From: David Chinner <dgc@sgi.com>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu,
       cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com,
       michael.kerrisk@gmx.net, tony.luck@intel.com
Subject: [PATCH] ia64 fallocate system call
Message-ID: <20070716053340.GM12413810@sgi.com>
References: <20070713184125.GA12156@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713184125.GA12156@amitarora.in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sys_fallocate for ia64. This uses the empty slot originally
reserved for move_pages.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 arch/ia64/kernel/entry.S  |    2 +-
 include/asm-ia64/unistd.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/arch/ia64/kernel/entry.S
===================================================================
--- 2.6.x-xfs-new.orig/arch/ia64/kernel/entry.S	2007-07-16 14:18:51.432168485 +1000
+++ 2.6.x-xfs-new/arch/ia64/kernel/entry.S	2007-07-16 14:22:08.582454284 +1000
@@ -1581,7 +1581,7 @@ sys_call_table:
 	data8 sys_sync_file_range		// 1300
 	data8 sys_tee
 	data8 sys_vmsplice
-	data8 sys_ni_syscall			// reserved for move_pages
+	data8 sys_fallocate
 	data8 sys_getcpu
 	data8 sys_epoll_pwait			// 1305
 	data8 sys_utimensat
Index: 2.6.x-xfs-new/include/asm-ia64/unistd.h
===================================================================
--- 2.6.x-xfs-new.orig/include/asm-ia64/unistd.h	2007-06-08 21:36:31.000000000 +1000
+++ 2.6.x-xfs-new/include/asm-ia64/unistd.h	2007-07-16 14:22:41.166204402 +1000
@@ -292,7 +292,7 @@
 #define __NR_sync_file_range		1300
 #define __NR_tee			1301
 #define __NR_vmsplice			1302
-/* 1303 reserved for move_pages */
+#define __NR_fallocate			1303
 #define __NR_getcpu			1304
 #define __NR_epoll_pwait		1305
 #define __NR_utimensat			1306
