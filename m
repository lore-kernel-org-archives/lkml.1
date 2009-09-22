Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbZIVOZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbZIVOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbZIVOZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:25:58 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58158 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755913AbZIVOZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:25:58 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 05/13] m32r: Remove unused .altinstructions and .exit.* code from linker script.
Date: Tue, 22 Sep 2009 10:22:19 -0400
Message-Id: <1253629347-23119-6-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
References: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that m32r copied the .altinstructions definition from x86
when the architecture was first merged into Linux.  m32r doesn't put
anything in .altinstructions, so this is just dead code.

The following block affecting .exit.text/.exit.data, which has a
comment also copied from x86, should also be deleted; the linker
script later discards the .exit.text and .exit.data sections.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/m32r/kernel/vmlinux.lds.S |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index de5e21c..a8aa4a8 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -91,15 +91,6 @@ SECTIONS
   .con_initcall.init : { *(.con_initcall.init) }
   __con_initcall_end = .;
   SECURITY_INIT
-  . = ALIGN(4);
-  __alt_instructions = .;
-  .altinstructions : { *(.altinstructions) }
-  __alt_instructions_end = .;
-  .altinstr_replacement : { *(.altinstr_replacement) }
-  /* .exit.text is discard at runtime, not link time, to deal with references
-     from .altinstructions and .eh_frame */
-  .exit.text : { EXIT_TEXT }
-  .exit.data : { EXIT_DATA }
 
 #ifdef CONFIG_BLK_DEV_INITRD
   . = ALIGN(4096);
-- 
1.6.3.3

