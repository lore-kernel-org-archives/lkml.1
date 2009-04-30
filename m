Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbZD3X6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbZD3X6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764249AbZD3XyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:54:21 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60522 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763084AbZD3XyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:54:19 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 4/4] mips: use .text, not .text.start, for lasat boot loader.
Date: Thu, 30 Apr 2009 19:53:30 -0400
Message-Id: <1241135610-9012-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135610-9012-4-git-send-email-tabbott@mit.edu>
References: <1241135610-9012-1-git-send-email-tabbott@mit.edu>
 <1241135610-9012-2-git-send-email-tabbott@mit.edu>
 <1241135610-9012-3-git-send-email-tabbott@mit.edu>
 <1241135610-9012-4-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There doesn't seem to be a reason to use a special section here, so
just use the normal .text.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/lasat/image/head.S           |    2 +-
 arch/mips/lasat/image/romscript.normal |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/lasat/image/head.S b/arch/mips/lasat/image/head.S
index efb95f2..c699363 100644
--- a/arch/mips/lasat/image/head.S
+++ b/arch/mips/lasat/image/head.S
@@ -1,7 +1,7 @@
 #include <asm/lasat/head.h>
 
 	.text
-	.section .text.start, "ax"
+	.section .text, "ax"
 	.set noreorder
 	.set mips3
 
diff --git a/arch/mips/lasat/image/romscript.normal b/arch/mips/lasat/image/romscript.normal
index 988f8ad..f470353 100644
--- a/arch/mips/lasat/image/romscript.normal
+++ b/arch/mips/lasat/image/romscript.normal
@@ -4,7 +4,7 @@ SECTIONS
 {
   .text :
   {
-    *(.text.start)
+    *(.text)
   }
 
   /* Data in ROM */
-- 
1.6.2.1

