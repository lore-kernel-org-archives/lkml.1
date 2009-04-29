Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZD2JHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZD2JHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZD2JFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:05:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:60462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbZD2JFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:05:39 -0400
Date: Wed, 29 Apr 2009 09:04:25 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240991249-27117-6-git-send-email-sam@ravnborg.org>
References: <1240991249-27117-6-git-send-email-sam@ravnborg.org>
Subject: [tip:x86/kbuild] x86, vmlinux.lds: unify exception table
Message-ID: <tip-448bc3ab0d03e77fee8e4264de0d001fc87bc164@git.kernel.org>
Git-Commit-ID: 448bc3ab0d03e77fee8e4264de0d001fc87bc164
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 09:04:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  448bc3ab0d03e77fee8e4264de0d001fc87bc164
Gitweb:     http://git.kernel.org/tip/448bc3ab0d03e77fee8e4264de0d001fc87bc164
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Wed, 29 Apr 2009 09:47:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 10:20:31 +0200

x86, vmlinux.lds: unify exception table

[ Impact: cleanup ]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1240991249-27117-6-git-send-email-sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux.lds.S    |   10 ++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |   10 ----------
 arch/x86/kernel/vmlinux_64.lds.S |   10 ----------
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index a7c88bb..67164f6 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -94,6 +94,16 @@ SECTIONS
 
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
