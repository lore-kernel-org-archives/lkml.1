Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbZEMSwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbZEMSwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760507AbZEMSwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:52:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:54708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760449AbZEMSwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:52:10 -0400
Subject: [RFC][PATCH -tip] x86: audit.c remove unnecessary global arrays
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 May 2009 00:21:34 +0530
Message-Id: <1242240694.3364.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ia32_dir_class[], ia32_write_class[], ia32_read_class[], ia32_chattr_class[]
and ia32_signal_class[] are used only by arch/x86/kernel/audit_64.c
which can be replace by local variables:

dir_class[], write_class[], read_class[], chattr_class[] and signal_class[]

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/ia32/audit.c      |   25 -------------------------
 arch/x86/kernel/audit_64.c |   15 +++++----------
 2 files changed, 5 insertions(+), 35 deletions(-)

diff --git a/arch/x86/ia32/audit.c b/arch/x86/ia32/audit.c
index 5d7b381..ee8ce50 100644
--- a/arch/x86/ia32/audit.c
+++ b/arch/x86/ia32/audit.c
@@ -1,30 +1,5 @@
 #include <asm/unistd_32.h>
 
-unsigned ia32_dir_class[] = {
-#include <asm-generic/audit_dir_write.h>
-~0U
-};
-
-unsigned ia32_chattr_class[] = {
-#include <asm-generic/audit_change_attr.h>
-~0U
-};
-
-unsigned ia32_write_class[] = {
-#include <asm-generic/audit_write.h>
-~0U
-};
-
-unsigned ia32_read_class[] = {
-#include <asm-generic/audit_read.h>
-~0U
-};
-
-unsigned ia32_signal_class[] = {
-#include <asm-generic/audit_signal.h>
-~0U
-};
-
 int ia32_classify_syscall(unsigned syscall)
 {
 	switch (syscall) {
diff --git a/arch/x86/kernel/audit_64.c b/arch/x86/kernel/audit_64.c
index 06d3e5a..aede8d2 100644
--- a/arch/x86/kernel/audit_64.c
+++ b/arch/x86/kernel/audit_64.c
@@ -59,16 +59,11 @@ int audit_classify_syscall(int abi, unsigned syscall)
 static int __init audit_classes_init(void)
 {
 #ifdef CONFIG_IA32_EMULATION
-	extern __u32 ia32_dir_class[];
-	extern __u32 ia32_write_class[];
-	extern __u32 ia32_read_class[];
-	extern __u32 ia32_chattr_class[];
-	extern __u32 ia32_signal_class[];
-	audit_register_class(AUDIT_CLASS_WRITE_32, ia32_write_class);
-	audit_register_class(AUDIT_CLASS_READ_32, ia32_read_class);
-	audit_register_class(AUDIT_CLASS_DIR_WRITE_32, ia32_dir_class);
-	audit_register_class(AUDIT_CLASS_CHATTR_32, ia32_chattr_class);
-	audit_register_class(AUDIT_CLASS_SIGNAL_32, ia32_signal_class);
+	audit_register_class(AUDIT_CLASS_WRITE_32, write_class);
+	audit_register_class(AUDIT_CLASS_READ_32, read_class);
+	audit_register_class(AUDIT_CLASS_DIR_WRITE_32, dir_class);
+	audit_register_class(AUDIT_CLASS_CHATTR_32, chattr_class);
+	audit_register_class(AUDIT_CLASS_SIGNAL_32, signal_class);
 #endif
 	audit_register_class(AUDIT_CLASS_WRITE, write_class);
 	audit_register_class(AUDIT_CLASS_READ, read_class);
-- 
1.6.0.6



