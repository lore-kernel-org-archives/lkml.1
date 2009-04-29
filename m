Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbZD2Hra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbZD2Hra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbZD2Hp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:45:29 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57935 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbZD2HpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:45:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 06/13] x86, vmlinux.lds: unify exceptiontable
Date: Wed, 29 Apr 2009 09:47:22 +0200
Message-Id: <1240991249-27117-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20090429073510.GA26386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/vmlinux.lds.S    |   10 ++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |   10 ----------
 arch/x86/kernel/vmlinux_64.lds.S |   10 ----------
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 597e579..94b67bf 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -89,6 +89,16 @@ SECTIONS
 
 	NOTES :text :note
 
+	/* Exception table */
+	. = ALIGN(16);
+	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
+		__start___ex_table = .;
+		*(__ex_table)
+		__stop___ex_table = .;
+	} :text = 0x9090
+
+	RODATA
+
 
 #ifdef CONFIG_X86_32
 # include "vmlinux_32.lds.S"
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 8540092..920cc69 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -1,13 +1,3 @@
-	/* Exception table */
-	. = ALIGN(16);
-	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-		__start___ex_table = .;
-		 *(__ex_table)
-		__stop___ex_table = .;
-	} :text = 0x9090
-
-	RODATA
-
 	/* writeable */
 	. = ALIGN(PAGE_SIZE);
 	/* Data */
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index b5d4367..641f3f9 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -1,13 +1,3 @@
-	/* Exception table */
-	. = ALIGN(16);
-	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-		__start___ex_table = .;
-		 *(__ex_table)
-		__stop___ex_table = .;
-	} :text = 0x9090
-
-	RODATA
-
 	/* Align data segment to page size boundary */
 	. = ALIGN(PAGE_SIZE);
 	/* Data */
-- 
1.6.0.6

