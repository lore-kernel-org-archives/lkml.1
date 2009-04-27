Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbZD0SMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbZD0SMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZD0SMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:12:09 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65358 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195AbZD0SMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:12:07 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>, David Howells <dhowells@redhat.com>
Subject: [PATCH 2/8] frv: Use __INIT macro instead of .text.init.
Date: Mon, 27 Apr 2009 14:02:21 -0400
Message-Id: <1240855347-19316-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240855347-19316-2-git-send-email-tabbott@mit.edu>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu>
 <1240855347-19316-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

frv is placing some code in the .text.init section but does not
reference that section in its linker scripts.

This change moves this code from the .text.init section to the
.init.text section, which is presumably where it belongs.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David Howells <dhowells@redhat.com>
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
-- 
1.6.2.1

