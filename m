Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbZIQBdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbZIQBdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 21:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758756AbZIQBda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 21:33:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33706 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161AbZIQBd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 21:33:29 -0400
Date: Thu, 17 Sep 2009 11:33:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Nelson Elhage <nelhage@ksplice.com>
Subject: linux-next: manual merge of the ia64 tree with Linus' tree
Message-Id: <20090917113330.34185775.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Today's linux-next merge of the ia64 tree got a conflict in
arch/ia64/kernel/vmlinux.lds.S between commit
023bf6f1b8bf58dc4da7f0dc1cf4787b0d5297c1 ("linker script: unify usage of
discard definition") from Linus' tree and commit
6ae86350857bf3e862f8dcd10039ccb45e056f85 ("[IA64] Clean up linker script
using standard macros") from the ia64 tree.

I fixed it up (I think - see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/ia64/kernel/vmlinux.lds.S
index eb4214d,f69f411..0000000
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@@ -284,39 -228,8 +228,10 @@@ SECTION
    _end = .;
  
    code : { } :code
-   /* Stabs debugging sections.  */
-   .stab 0 : { *(.stab) }
-   .stabstr 0 : { *(.stabstr) }
-   .stab.excl 0 : { *(.stab.excl) }
-   .stab.exclstr 0 : { *(.stab.exclstr) }
-   .stab.index 0 : { *(.stab.index) }
-   .stab.indexstr 0 : { *(.stab.indexstr) }
-   /* DWARF debug sections.
-      Symbols in the DWARF debugging sections are relative to the beginning
-      of the section so we begin them at 0.  */
-   /* DWARF 1 */
-   .debug          0 : { *(.debug) }
-   .line           0 : { *(.line) }
-   /* GNU DWARF 1 extensions */
-   .debug_srcinfo  0 : { *(.debug_srcinfo) }
-   .debug_sfnames  0 : { *(.debug_sfnames) }
-   /* DWARF 1.1 and DWARF 2 */
-   .debug_aranges  0 : { *(.debug_aranges) }
-   .debug_pubnames 0 : { *(.debug_pubnames) }
-   /* DWARF 2 */
-   .debug_info     0 : { *(.debug_info) }
-   .debug_abbrev   0 : { *(.debug_abbrev) }
-   .debug_line     0 : { *(.debug_line) }
-   .debug_frame    0 : { *(.debug_frame) }
-   .debug_str      0 : { *(.debug_str) }
-   .debug_loc      0 : { *(.debug_loc) }
-   .debug_macinfo  0 : { *(.debug_macinfo) }
-   /* SGI/MIPS DWARF 2 extensions */
-   .debug_weaknames 0 : { *(.debug_weaknames) }
-   .debug_funcnames 0 : { *(.debug_funcnames) }
-   .debug_typenames 0 : { *(.debug_typenames) }
-   .debug_varnames  0 : { *(.debug_varnames) }
+ 
+   STABS_DEBUG
+   DWARF_DEBUG
 -  /DISCARD/ : { *(.note) }
 +
 +  /* Default discards */
 +  DISCARDS
  }
