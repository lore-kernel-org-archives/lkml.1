Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbZDDIqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbZDDIqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 04:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbZDDIq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 04:46:28 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:46543 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZDDIq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 04:46:27 -0400
Message-ID: <49D71E5D.6010203@larces.uece.br>
Date: Sat, 04 Apr 2009 05:46:21 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       x86 Maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/6] x86: unify power/cpu_(32|64) global variables
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: unify power/cpu_(32|64) global variables

Aiming total unification of cpu_32.c and cpu_64.c, in this step
we do unify the global variables and existing forward declarations
for such files.

Signed-off-by: Sergio Luis <sergio@larces.uece.br>
Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>
---
 arch/x86/power/cpu_32.c |    7 +++++++
 arch/x86/power/cpu_64.c |   10 ++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index e9ceaa0..e4bdc2a 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -17,12 +17,19 @@
 #include <asm/mce.h>
 #include <asm/xcr.h>
 
+#ifdef CONFIG_X86_32
 static struct saved_context saved_context;
 
 unsigned long saved_context_ebx;
 unsigned long saved_context_esp, saved_context_ebp;
 unsigned long saved_context_esi, saved_context_edi;
 unsigned long saved_context_eflags;
+#else
+/* CONFIG_X86_64 */
+static void fix_processor_context(void);
+
+struct saved_context saved_context;
+#endif
 
 static void __save_processor_state(struct saved_context *ctxt)
 {
diff --git a/arch/x86/power/cpu_64.c b/arch/x86/power/cpu_64.c
index d1cf7ae..1ee153e 100644
--- a/arch/x86/power/cpu_64.c
+++ b/arch/x86/power/cpu_64.c
@@ -18,9 +18,19 @@
 #include <asm/mce.h>
 #include <asm/xcr.h>
 
+#ifdef CONFIG_X86_32
+static struct saved_context saved_context;
+
+unsigned long saved_context_ebx;
+unsigned long saved_context_esp, saved_context_ebp;
+unsigned long saved_context_esi, saved_context_edi;
+unsigned long saved_context_eflags;
+#else
+/* CONFIG_X86_64 */
 static void fix_processor_context(void);
 
 struct saved_context saved_context;
+#endif
 
 /**
  *	__save_processor_state - save CPU registers before creating a
