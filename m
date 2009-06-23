Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbZFWBzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbZFWBzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 21:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZFWBzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 21:55:07 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57834 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZFWBzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 21:55:06 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 1/2] Blackfin: hook up new perf_counter_open syscall
Date: Mon, 22 Jun 2009 21:54:45 -0400
Message-Id: <1245722086-13340-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/unistd.h |    3 ++-
 arch/blackfin/mach-common/entry.S  |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/include/asm/unistd.h b/arch/blackfin/include/asm/unistd.h
index da35133..c8e7ee4 100644
--- a/arch/blackfin/include/asm/unistd.h
+++ b/arch/blackfin/include/asm/unistd.h
@@ -381,8 +381,9 @@
 #define __NR_preadv		366
 #define __NR_pwritev		367
 #define __NR_rt_tgsigqueueinfo	368
+#define __NR_perf_counter_open	369
 
-#define __NR_syscall		369
+#define __NR_syscall		370
 #define NR_syscalls		__NR_syscall
 
 /* Old optional stuff no one actually uses */
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 31fa313..5a4e7c7 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1609,6 +1609,7 @@ ENTRY(_sys_call_table)
 	.long _sys_preadv
 	.long _sys_pwritev
 	.long _sys_rt_tgsigqueueinfo
+	.long _sys_perf_counter_open
 
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
-- 
1.6.3.1

