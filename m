Return-Path: <linux-kernel-owner+w=401wt.eu-S1761112AbZD3Xrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761112AbZD3Xrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760055AbZD3XqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:46:21 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59251 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760147AbZD3XqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:46:20 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 2/2] h8300: use .head.text for compressed bootloader.
Date: Thu, 30 Apr 2009 19:46:15 -0400
Message-Id: <1241135175-8183-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135175-8183-2-git-send-email-tabbott@mit.edu>
References: <1241135175-8183-1-git-send-email-tabbott@mit.edu>
 <1241135175-8183-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/boot/compressed/head.S      |    3 ++-
 arch/h8300/boot/compressed/vmlinux.lds |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/h8300/boot/compressed/head.S b/arch/h8300/boot/compressed/head.S
index 985a81a..a821a1b 100644
--- a/arch/h8300/boot/compressed/head.S
+++ b/arch/h8300/boot/compressed/head.S
@@ -5,11 +5,12 @@
  */
 
 	.h8300h
+#include <linux/init.h>
 #include <linux/linkage.h>
 
 #define SRAM_START 0xff4000
 
-	.section	.text.startup
+	__HEAD
 	.global	startup
 startup:
 	mov.l	#SRAM_START+0x8000, sp
diff --git a/arch/h8300/boot/compressed/vmlinux.lds b/arch/h8300/boot/compressed/vmlinux.lds
index 65e2a0d..98a492e 100644
--- a/arch/h8300/boot/compressed/vmlinux.lds
+++ b/arch/h8300/boot/compressed/vmlinux.lds
@@ -4,7 +4,7 @@ SECTIONS
         {
         __stext = . ;
 	__text = .;
-	       *(.text.startup)
+	       *(.head.text)
 	       *(.text)
         __etext = . ;
         }
-- 
1.6.2.1

