Return-Path: <linux-kernel-owner+w=401wt.eu-S936835AbXHHDkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936835AbXHHDkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936023AbXHHDg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:36:28 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:45539 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934265AbXHHDfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:35:51 -0400
X-IronPort-AV: i="4.19,233,1183348800"; 
   d="scan'208"; a="36639269:sNHT1102661140"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: dbrownell@users.sourceforge.net, Bryan Wu <bryan.wu@analog.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 11/12] Blackfin arch: after removing fs.h from mm.h, fix the broken on Blackfin arch.
Date: Wed,  8 Aug 2007 11:35:36 +0800
Message-Id: <1186544141236-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11865441373719-git-send-email-bryan.wu@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/init_task.c |    1 +
 arch/blackfin/kernel/process.c   |    2 ++
 arch/blackfin/kernel/sys_bfin.c  |    1 +
 arch/blackfin/kernel/traps.c     |    1 +
 4 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/init_task.c b/arch/blackfin/kernel/init_task.c
index b45188f..673c860 100644
--- a/arch/blackfin/kernel/init_task.c
+++ b/arch/blackfin/kernel/init_task.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
+#include <linux/fs.h>
 
 static struct fs_struct init_fs = INIT_FS;
 static struct files_struct init_files = INIT_FILES;
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 5a51dd6..6a7aefe 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -33,6 +33,8 @@
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/err.h>
 
 #include <asm/blackfin.h>
 #include <asm/fixed_code.h>
diff --git a/arch/blackfin/kernel/sys_bfin.c b/arch/blackfin/kernel/sys_bfin.c
index f5e1ae3..abcd148 100644
--- a/arch/blackfin/kernel/sys_bfin.c
+++ b/arch/blackfin/kernel/sys_bfin.c
@@ -37,6 +37,7 @@
 #include <linux/syscalls.h>
 #include <linux/mman.h>
 #include <linux/file.h>
+#include <linux/fs.h>
 #include <linux/uaccess.h>
 #include <linux/ipc.h>
 #include <linux/unistd.h>
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 8766bd6..792a841 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
+#include <linux/fs.h>
 #include <asm/traps.h>
 #include <asm/cacheflush.h>
 #include <asm/blackfin.h>
-- 
1.5.2
