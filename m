Return-Path: <linux-kernel-owner+w=401wt.eu-S1759060AbXGaKUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060AbXGaKUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbXGaKUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:20:39 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:10494 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbXGaKUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:20:38 -0400
X-IronPort-AV: i="4.19,203,1183348800"; 
   d="scan'208"; a="46973901:sNHT24091501"
Subject: [PATCH] Blackfin arch: after removing fs.h from mm.h, fix the
	broken on Blackfin arch
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 31 Jul 2007 18:25:29 +0800
Message-Id: <1185877529.32124.2.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 31 Jul 2007 10:20:34.0598 (UTC) FILETIME=[6E660460:01C7D35C]
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
1.5.2.2

