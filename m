Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbZJROlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbZJROlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 10:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbZJROls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 10:41:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbZJROls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 10:41:48 -0400
Date: Sun, 18 Oct 2009 16:41:20 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Remove smp_lock.h from files that no longer contain the
 BKL
Message-ID: <alpine.LFD.2.00.0910181638220.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@Thomas: This patch assumes you already applied the series of 6 patches I 
sent you that remove the BKL from sys_execve on various architectures.

If you prefer, I can fold these changes back into those patches, else, 
just apply this one after those.

Thanks

>From 1d77565dfbf9cb82094c71100fd407512f41eec1 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 16:26:48 +0200
Subject: [PATCH] Remove smp_lock.h from files that no longer contain the BKL

The following files no longer require smp_lock.h after I removed
the BKL from their sys_execve functions.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/blackfin/kernel/process.c  |    1 -
 arch/frv/kernel/process.c       |    1 -
 arch/h8300/kernel/process.c     |    1 -
 arch/m68k/kernel/process.c      |    1 -
 arch/m68knommu/kernel/process.c |    1 -
 arch/mn10300/kernel/process.c   |    1 -
 6 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 7d9c975..0610974 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/unistd.h>
 #include <linux/user.h>
 #include <linux/uaccess.h>
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 21d0fd1..4a8d606 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index bd883fa..c6cc723 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -28,7 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 0529659..74724b0 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -17,7 +17,6 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
index 5c9ecd4..ab89243 100644
--- a/arch/m68knommu/kernel/process.c
+++ b/arch/m68knommu/kernel/process.c
@@ -19,7 +19,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index ec8a21d..513ef72 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -14,7 +14,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
-- 
1.6.0.6

