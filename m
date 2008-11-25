Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbYKYNMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbYKYNMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 08:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbYKYNMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 08:12:37 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:55806 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbYKYNMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 08:12:36 -0500
Date: Tue, 25 Nov 2008 14:12:32 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] arch/mips/alchemy: change strict_strtol to strict_strtoul
Message-ID: <Pine.LNX.4.64.0811251412010.11897@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Since memsize is unsigned, it would seem better to use strict_strtoul that
strict_strtol.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@s2@
long e;
position p;
@@

strict_strtol@p(...,&e)

@@
position p != s2.p;
type T;
T e;
@@

- strict_strtol@p
+ strict_strtoul
  (...,&e)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

 arch/mips/alchemy/db1x00/init.c  |    2 +-
 arch/mips/alchemy/mtx-1/init.c   |    2 +-
 arch/mips/alchemy/pb1000/init.c  |    2 +-
 arch/mips/alchemy/pb1100/init.c  |    2 +-
 arch/mips/alchemy/pb1200/init.c  |    2 +-
 arch/mips/alchemy/pb1500/init.c  |    2 +-
 arch/mips/alchemy/pb1550/init.c  |    2 +-
 arch/mips/alchemy/xxs1500/init.c |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff -u -p a/arch/mips/alchemy/db1x00/init.c b/arch/mips/alchemy/db1x00/init.c
--- a/arch/mips/alchemy/db1x00/init.c
+++ b/arch/mips/alchemy/db1x00/init.c
@@ -57,6 +57,6 @@ void __init prom_init(void)
 	if (!memsize_str)
 		memsize = 0x04000000;
 	else
-		strict_strtol(memsize_str, 0, &memsize);
+		strict_strtoul(memsize_str, 0, &memsize);
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
 }
diff -u -p a/arch/mips/alchemy/mtx-1/init.c b/arch/mips/alchemy/mtx-1/init.c
--- a/arch/mips/alchemy/mtx-1/init.c
+++ b/arch/mips/alchemy/mtx-1/init.c
@@ -55,6 +55,6 @@ void __init prom_init(void)
 	if (!memsize_str)
 		memsize = 0x04000000;
 	else
-		strict_strtol(memsize_str, 0, &memsize);
+		strict_strtoul(memsize_str, 0, &memsize);
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
 }
diff -u -p a/arch/mips/alchemy/pb1000/init.c b/arch/mips/alchemy/pb1000/init.c
--- a/arch/mips/alchemy/pb1000/init.c
+++ b/arch/mips/alchemy/pb1000/init.c
@@ -52,6 +52,6 @@ void __init prom_init(void)
 	if (!memsize_str)
 		memsize = 0x04000000;
 	else
-		strict_strtol(memsize_str, 0, &memsize);
+		strict_strtoul(memsize_str, 0, &memsize);
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
 }
diff -u -p a/arch/mips/alchemy/pb1100/init.c b/arch/mips/alchemy/pb1100/init.c
--- a/arch/mips/alchemy/pb1100/init.c
+++ b/arch/mips/alchemy/pb1100/init.c
@@ -54,7 +54,7 @@ void __init prom_init(void)
 	if (!memsize_str)
 		memsize = 0x04000000;
 	else
-		strict_strtol(memsize_str, 0, &memsize);
+		strict_strtoul(memsize_str, 0, &memsize);
 
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
 }
diff -u -p a/arch/mips/alchemy/pb1200/init.c b/arch/mips/alchemy/pb1200/init.c
--- a/arch/mips/alchemy/pb1200/init.c
+++ b/arch/mips/alchemy/pb1200/init.c
@@ -53,6 +53,6 @@ void __init prom_init(void)
 	if (!memsize_str)
 		memsize = 0x08000000;
 	else
-		strict_strtol(memsize_str, 0, &memsize);
+		strict_strtoul(memsize_str, 0, &memsize);
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
 }
diff -u -p a/arch/mips/alchemy/pb1500/init.c b/arch/mips/alchemy/pb1500/init.c
--- a/arch/mips/alchemy/pb1500/init.c
+++ b/arch/mips/alchemy/pb1500/init.c
@@ -53,6 +53,6 @@ void __init prom_init(void)
 	if (!memsize_str)
 		memsize = 0x04000000;
 	else
-		strict_strtol(memsize_str, 0, &memsize);
+		strict_strtoul(memsize_str, 0, &memsize);
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
 }
diff -u -p a/arch/mips/alchemy/pb1550/init.c b/arch/mips/alchemy/pb1550/init.c
--- a/arch/mips/alchemy/pb1550/init.c
+++ b/arch/mips/alchemy/pb1550/init.c
@@ -53,6 +53,6 @@ void __init prom_init(void)
 	if (!memsize_str)
 		memsize = 0x08000000;
 	else
-		strict_strtol(memsize_str, 0, &memsize);
+		strict_strtoul(memsize_str, 0, &memsize);
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
 }
diff -u -p a/arch/mips/alchemy/xxs1500/init.c b/arch/mips/alchemy/xxs1500/init.c
--- a/arch/mips/alchemy/xxs1500/init.c
+++ b/arch/mips/alchemy/xxs1500/init.c
@@ -53,6 +53,6 @@ void __init prom_init(void)
 	if (!memsize_str)
 		memsize = 0x04000000;
 	else
-		strict_strtol(memsize_str, 0, &memsize);
+		strict_strtoul(memsize_str, 0, &memsize);
 	add_memory_region(0, memsize, BOOT_MEM_RAM);
 }
