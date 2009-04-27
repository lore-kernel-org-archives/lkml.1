Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbZD0S1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbZD0S1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZD0S06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:26:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34128 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbZD0S06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:26:58 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] Blackfin: hook up preadv/pwritev syscalls
Date: Mon, 27 Apr 2009 14:26:56 -0400
Message-Id: <1240856816-19653-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090427081356.GA32167@lst.de>
References: <20090427081356.GA32167@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/unistd.h |    4 +++-
 arch/blackfin/mach-common/entry.S  |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/include/asm/unistd.h b/arch/blackfin/include/asm/unistd.h
index 1e57b63..cf5066d 100644
--- a/arch/blackfin/include/asm/unistd.h
+++ b/arch/blackfin/include/asm/unistd.h
@@ -378,8 +378,10 @@
 #define __NR_dup3		363
 #define __NR_pipe2		364
 #define __NR_inotify_init1	365
+#define __NR_preadv		366
+#define __NR_pwritev		367
 
-#define __NR_syscall		366
+#define __NR_syscall		368
 #define NR_syscalls		__NR_syscall
 
 /* Old optional stuff no one actually uses */
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 21e65a3..a063a43 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1581,6 +1581,8 @@ ENTRY(_sys_call_table)
 	.long _sys_dup3
 	.long _sys_pipe2
 	.long _sys_inotify_init1	/* 365 */
+	.long _sys_preadv
+	.long _sys_pwritev
 
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
-- 
1.6.2.3

