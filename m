Return-Path: <linux-kernel-owner+w=401wt.eu-S964780AbXBLHs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780AbXBLHs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933086AbXBLHqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:46:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:49612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084AbXBLHiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:02 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Rene Herman <rene.herman@gmail.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [13/39] i386: CONFIG_PHYSICAL_ALIGN limited to 4M?
Message-Id: <20070212073800.3D44313DD5@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rene Herman <rene.herman@gmail.com>
A while ago it was remarked on list here that keeping the kernel 4M 
aligned physically might be a performance win if the added 1M (it 
normally loads at 1M) meant it would fit on one 4M aligned hugepage 
instead of 2 and since that time I've been doing such.

In fact, while I was at it, I ran the kernel at 16M; while admittedly a 
bit of a non-issue, having never experienced ZONE_DMA shortage, I am an 
ISA user on a >16M machine so this seemed to make sense -- no kernel 
eating up "precious" ISA-DMAable memory.

Recently CONFIG_PHYSICAL_START was replaced by CONFIG_PHYSICAL_ALIGN 
(commit e69f202d0a1419219198566e1c22218a5c71a9a6) and while 4M alignment 
is still possible, that's also the strictest alignment allowed meaning I 
can't load my (non-relocatable) kernel at 16M anymore.

If I just apply the following and set it to 16M, things seem to be 
working for me. Was there an important reason to limit the alignment to 
4M, and if so, even on non relocatable kernels?

Rene.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
@@ -843,7 +843,7 @@ config RELOCATABLE
 config PHYSICAL_ALIGN
 	hex "Alignment value to which kernel should be aligned"
 	default "0x100000"
-	range 0x2000 0x400000
+	range 0x2000 0x1000000
 	help
 	  This value puts the alignment restrictions on physical address
  	  where kernel is loaded and run from. Kernel is compiled for an
