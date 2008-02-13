Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbYBMVPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbYBMVPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYBMVPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:15:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:43556 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYBMVPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:15:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=STJi6p60jd7Ro2kYhMBQwcSQt9dzwbYpqp6Qh/EL0PWA3L9BmbieXHQgUFhBewlqF82/uDnmVQn0QgjzLoF0FD7/XK00br42EpILEq3gMRFt2ZEHbxwx3DfdGOgkX0V1U0DsbmyaLJTDtJ5Raf5o8kidYxT2kf9DvmwqH1SweSs=
Subject: [PATCH] lguest: include function prototypes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 13:14:35 -0800
Message-Id: <1202937275.18204.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for sparse warning
arch/x86/lguest/boot.c:939:13: warning: symbol 'lguest_init' was not declared. Should it be static?

Added a declaration to asm-x86/lguest.h and moved the extern arrays there
as well.  As an alternative to including asm/lguest.h directly, an
include could be put in linux/lguest.h

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Rusty, just a suggestion.  If you'd like Ingo to take it in the x86
tree, please let him know.

 arch/x86/lguest/boot.c   |   10 +---------
 include/asm-x86/lguest.h |   11 +++++++++++
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 5afdde4..1e613fb 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -57,6 +57,7 @@
 #include <linux/lguest_launcher.h>
 #include <linux/virtio_console.h>
 #include <linux/pm.h>
+#include <asm/lguest.h>
 #include <asm/paravirt.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -75,15 +76,6 @@
  * behaving in simplified but equivalent ways.  In particular, the Guest is the
  * same kernel as the Host (or at least, built from the same source code). :*/
 
-/* Declarations for definitions in lguest_guest.S */
-extern char lguest_noirq_start[], lguest_noirq_end[];
-extern const char lgstart_cli[], lgend_cli[];
-extern const char lgstart_sti[], lgend_sti[];
-extern const char lgstart_popf[], lgend_popf[];
-extern const char lgstart_pushf[], lgend_pushf[];
-extern const char lgstart_iret[], lgend_iret[];
-extern void lguest_iret(void);
-
 struct lguest_data lguest_data = {
 	.hcall_status = { [0 ... LHCALL_RING_SIZE-1] = 0xFF },
 	.noirq_start = (u32)lguest_noirq_start,
diff --git a/include/asm-x86/lguest.h b/include/asm-x86/lguest.h
index 4d9367b..9b17571 100644
--- a/include/asm-x86/lguest.h
+++ b/include/asm-x86/lguest.h
@@ -23,6 +23,17 @@
 /* Found in switcher.S */
 extern unsigned long default_idt_entries[];
 
+/* Declarations for definitions in lguest_guest.S */
+extern char lguest_noirq_start[], lguest_noirq_end[];
+extern const char lgstart_cli[], lgend_cli[];
+extern const char lgstart_sti[], lgend_sti[];
+extern const char lgstart_popf[], lgend_popf[];
+extern const char lgstart_pushf[], lgend_pushf[];
+extern const char lgstart_iret[], lgend_iret[];
+
+extern void lguest_iret(void);
+extern void lguest_init(void);
+
 struct lguest_regs
 {
 	/* Manually saved part. */
-- 
1.5.4.1.1278.gc75be



