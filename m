Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYKSVZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYKSVZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYKSVXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:23:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57100 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYKSVXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:23:36 -0500
Message-Id: <20081119212334.535779903@goodmis.org>
References: <20081119212204.318400312@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Nov 2008 16:22:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 8/9] powerpc/ppc32: ftrace, enabled dynamic ftrace
Content-Disposition: inline; filename=0008-powerpc-ppc32-ftrace-enabled-dynamic-ftrace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Port 32 bit PowerPC dynamic ftrace

This patch adds the necessary hooks to get PPC32 dynamic ftrace working.
It does not handle modules. They are ignored by this patch.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/Kconfig    |    2 +-
 scripts/recordmcount.pl |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9675e95..d64b629 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -108,7 +108,7 @@ config ARCH_NO_VIRT_TO_BUS
 config PPC
 	bool
 	default y
-	select HAVE_FTRACE_MCOUNT_RECORD if PPC64
+	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
 	select ARCH_WANT_OPTIONAL_GPIOLIB
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 7acbe17..48609e9 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -178,7 +178,12 @@ if ($arch eq "x86_64") {
     $section_regex = "Disassembly of section\\s+(\\S+):";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(\\.?.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s\\.?_mcount\$";
-    $type = ".quad";
+    if ($bits == 64) {
+	$type = ".quad";
+    } else {
+	$type = ".long";
+    }
+
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
-- 
1.5.6.5

-- 
