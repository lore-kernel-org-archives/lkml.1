Return-Path: <linux-kernel-owner+w=401wt.eu-S936737AbYEURqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936737AbYEURqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936200AbYEURos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:44:48 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53725 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936581AbYEURor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:44:47 -0400
Date: Wed, 21 May 2008 20:42:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] don't offer BINFMT_FLAT on frv
Message-ID: <20080521174231.GH15355@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error:

<--  snip  -->

...
  CC      fs/binfmt_flat.o
In file included from 
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:36:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/flat.h:14:22: error: asm/flat.h: No such file or directory
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c: In function 'create_flat_tables':
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:124: error: implicit declaration of function 'flat_stack_align'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:125: error: implicit declaration of function 'flat_argvp_envp_on_stack'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c: In function 'calc_reloc':
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:347: error: implicit declaration of function 'flat_reloc_valid'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c: In function 'load_flat_file':
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:479: error: implicit declaration of function 'flat_old_ram_flag'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:755: error: implicit declaration of function 'flat_set_persistent'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:757: error: implicit declaration of function 'flat_get_relocate_addr'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:765: error: implicit declaration of function 'flat_get_addr_from_rp'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:781: error: implicit declaration of function 'flat_put_addr_at_rp'
make[2]: *** [fs/binfmt_flat.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
e387adf070a8d7522148b3a7ef477340a1162e88 diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 55e8ee1..3263084 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -42,7 +42,7 @@ config BINFMT_ELF_FDPIC
 
 config BINFMT_FLAT
 	bool "Kernel support for flat binaries"
-	depends on !MMU
+	depends on !MMU && (!FRV || BROKEN)
 	help
 	  Support uClinux FLAT format binaries.
 

