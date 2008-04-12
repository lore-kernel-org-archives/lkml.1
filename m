Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbYDLI26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbYDLI26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 04:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYDLI2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 04:28:48 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:42078 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754029AbYDLI2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 04:28:48 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] x86: fix exec mappings comments
Date: Sat, 12 Apr 2008 10:28:25 +0200
Message-Id: <1207988905-17806-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- noexec32 is on by default for years already
- add noexec32 to kernel-parameters and fix noexec type in there

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 Documentation/kernel-parameters.txt |   10 +++++++++-
 arch/x86/kernel/setup64.c           |    4 ++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a52524c..b0f7c13 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1285,8 +1285,16 @@ and is between 256 and 4096 characters. It is defined in the file
 	noexec		[IA-64]
 
 	noexec		[X86-32,X86-64]
+			On X86-32 available only on PAE configured kernels.
 			noexec=on: enable non-executable mappings (default)
-			noexec=off: disable nn-executable mappings
+			noexec=off: disable non-executable mappings
+
+	noexec32	[X86-64]
+			This affects only 32-bit executables.
+			noexec32=on: enable non-executable mappings (default)
+				read doesn't imply executable mappings
+			noexec32=off: disable non-executable mappings
+				read implies executable mappings
 
 	nofxsr		[BUGS=X86-32] Disables x86 floating point extended
 			register save and restore. The kernel will only save
diff --git a/arch/x86/kernel/setup64.c b/arch/x86/kernel/setup64.c
index 9042fb0..aee0e82 100644
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -74,8 +74,8 @@ int force_personality32 = 0;
 Control non executable heap for 32bit processes.
 To control the stack too use noexec=off
 
-on	PROT_READ does not imply PROT_EXEC for 32bit processes
-off	PROT_READ implies PROT_EXEC (default)
+on	PROT_READ does not imply PROT_EXEC for 32bit processes (default)
+off	PROT_READ implies PROT_EXEC
 */
 static int __init nonx32_setup(char *str)
 {
-- 
1.5.4.5

