Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbXLOGPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbXLOGPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXLOGPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:15:10 -0500
Received: from auth.gate-on.net ([210.197.72.170]:52537 "EHLO auth.gate-on.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbXLOGPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:15:08 -0500
X-Greylist: delayed 933 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Dec 2007 01:15:08 EST
Message-ID: <47636D45.6010006@nyanyan.to>
Date: Sat, 15 Dec 2007 14:59:33 +0900
From: Yuusei KUWANA <kuwana@nyanyan.to>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/cris/arch-v10/vmlinux.lds.S fix boot problem
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


arch/cris/arch-v10/vmlinux.lds.S
 fix boot problem
* too old initcall style. replace INITCALLS macro
* __init_begin, __init_end move for free_initmem()

Note: with this patch kernel boot and mount root,
but after init done,  kernel panic at do_signal() ...

ryu

Signed-off-by: Yuusei KUWANA <ryu@nyanyan.to>
---
 arch/cris/arch-v10/vmlinux.lds.S |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/cris/arch-v10/vmlinux.lds.S b/arch/cris/arch-v10/vmlinux.lds.S
index 9859d49..c5bab0e 100644
--- a/arch/cris/arch-v10/vmlinux.lds.S
+++ b/arch/cris/arch-v10/vmlinux.lds.S
@@ -53,26 +53,22 @@ SECTIONS
   	.data.init_task : { *(.data.init_task) }
 
   	. = ALIGN(8192);              /* Init code and data */
-  	__init_begin = .;
 	.init.text : { 
 		   _sinittext = .;
 		   *(.init.text)
 		   _einittext = .;
 	}
+  	__init_begin = .;
   	.init.data : { *(.init.data) }
+  	__init_end = .;
+
   	. = ALIGN(16);
   	__setup_start = .;
   	.init.setup : { *(.init.setup) }
   	__setup_end = .;
   	.initcall.init : {
 		__initcall_start = .;
-		*(.initcall1.init);
-		*(.initcall2.init);
-		*(.initcall3.init);
-		*(.initcall4.init);
-		*(.initcall5.init);
-		*(.initcall6.init);
-		*(.initcall7.init);
+			INITCALLS
 		__initcall_end = .;	
 	}
 
@@ -97,7 +93,6 @@ SECTIONS
 #endif
 	
 	__vmlinux_end = .;            /* last address of the physical file */
-  	__init_end = .;
 
 	__data_end = . ;              /* Move to _edata ? */
 	__bss_start = .;              /* BSS */
-- 
1.5.3


