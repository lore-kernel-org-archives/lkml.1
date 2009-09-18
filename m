Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZIRUfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZIRUfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758219AbZIRUfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:35:42 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63009 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758431AbZIRUfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:35:23 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH v2 4/6] m32r: Remove unused .altinstructions and .exit.* code from linker script.
Date: Fri, 18 Sep 2009 16:32:47 -0400
Message-Id: <1253305969-6948-5-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253305969-6948-1-git-send-email-tabbott@ksplice.com>
References: <1253305969-6948-1-git-send-email-tabbott@ksplice.com>
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

