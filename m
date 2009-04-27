Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZD0Xkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZD0Xkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZD0XkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:40:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57953 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbZD0XkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:40:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] FRV: Use __INIT macro instead of .text.init.
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tim Abbott <tabbott@mit.edu>,
       David Howells <dhowells@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 28 Apr 2009 00:37:58 +0100
Message-ID: <20090427233758.3246.99507.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090427233753.3246.96982.stgit@warthog.procyon.org.uk>
References: <20090427233753.3246.96982.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@MIT.EDU>

FRV is placing some code in the .text.init section but does not reference that
section in its linker scripts.

This change moves this code from the .text.init section to the .init.text
section, which is presumably where it belongs.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---

 arch/frv/kernel/head-mmu-fr451.S |    3 ++-
 arch/frv/kernel/head-uc-fr401.S  |    3 ++-
 arch/frv/kernel/head-uc-fr451.S  |    3 ++-
 arch/frv/kernel/head-uc-fr555.S  |    3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)


diff --git a/arch/frv/kernel/head-mmu-fr451.S b/arch/frv/kernel/head-mmu-fr451.S
index c8f210d..98f87d5 100644
--- a/arch/frv/kernel/head-mmu-fr451.S
+++ b/arch/frv/kernel/head-mmu-fr451.S
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/init.h>
 #include <linux/threads.h>
 #include <linux/linkage.h>
 #include <asm/ptrace.h>
@@ -31,7 +32,7 @@
 #define __400_LCR	0xfe000100
 #define __400_LSBR	0xfe000c00
 
-	.section	.text.init,"ax"
+	__INIT
 	.balign		4
 
 ###############################################################################
diff --git a/arch/frv/kernel/head-uc-fr401.S b/arch/frv/kernel/head-uc-fr401.S
index ee282be..438643c 100644
--- a/arch/frv/kernel/head-uc-fr401.S
+++ b/arch/frv/kernel/head-uc-fr401.S
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/init.h>
 #include <linux/threads.h>
 #include <linux/linkage.h>
 #include <asm/ptrace.h>
@@ -30,7 +31,7 @@
 #define __400_LCR	0xfe000100
 #define __400_LSBR	0xfe000c00
 
-	.section	.text.init,"ax"
+	__INIT
 	.balign		4
 
 ###############################################################################
diff --git a/arch/frv/kernel/head-uc-fr451.S b/arch/frv/kernel/head-uc-fr451.S
index b10d9c8..b2a76c4 100644
--- a/arch/frv/kernel/head-uc-fr451.S
+++ b/arch/frv/kernel/head-uc-fr451.S
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/init.h>
 #include <linux/threads.h>
 #include <linux/linkage.h>
 #include <asm/ptrace.h>
@@ -30,7 +31,7 @@
 #define __400_LCR	0xfe000100
 #define __400_LSBR	0xfe000c00
 
-	.section	.text.init,"ax"
+	__INIT
 	.balign		4
 
 ###############################################################################
diff --git a/arch/frv/kernel/head-uc-fr555.S b/arch/frv/kernel/head-uc-fr555.S
index 39937c1..5497aaf 100644
--- a/arch/frv/kernel/head-uc-fr555.S
+++ b/arch/frv/kernel/head-uc-fr555.S
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/init.h>
 #include <linux/threads.h>
 #include <linux/linkage.h>
 #include <asm/ptrace.h>
@@ -29,7 +30,7 @@
 #define __551_LCR	0xfeff1100
 #define __551_LSBR	0xfeff1c00
 
-	.section	.text.init,"ax"
+	__INIT
 	.balign		4
 
 ###############################################################################

