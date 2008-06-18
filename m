Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYFRKcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYFRKcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYFRKce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:32:34 -0400
Received: from ping.pong.ch ([212.103.71.101]:52373 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbYFRKcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:32:32 -0400
X-Greylist: delayed 1106 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 06:32:32 EDT
Date: Wed, 18 Jun 2008 12:14:02 +0200
From: Gaudenz Steinlin <gaudenz@debian.org>
To: linux-kernel@vger.kernel.org
Cc: 486798@bugs.debian.org, josejx@gentoo.org
Subject: [PATCH] restore export of handle_mm_fault for Mac on Linux
Message-ID: <20080618101402.GF15718@soziologie.ch>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi

The kernel modules for Mac on Linux (MOL) need handle_mm_fault. 
MOL is a GPL licensed virtual machine to run MacOS(X) on PPC Linux.

The export for handle_mm_fault was removed with commit
41f9dc5c871600f53c8912b2975971d2a11c1c25. 

Previously the export has been present since handle_mm_fault was
converted from an inline function to a non-inline one. See the thread
starting at http://marc.info/?l=linux-kernel&m=112327941709177&w=2 for
the initial discussion.

With commit 67207b9664a8d603138ef1556141e6d0a102bea7 the export was
moved from arch/ppc/kernel/ppc_ksyms.c to mm/memory.c. In this patch the
explanatory comment /* For MOL */ got lost. Thus to export was not moved
back to it's original place when it was no longer needed for spufs.

The attached patch restores the symbol export (GPL only) in it's
original place. Please consider applying it because this fixes a
regression for MOL.

Thanks

Gaudenz

P.S.: Please CC me and the corresponding Debian bug report on any
replies.

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~

--pvezYHf7grwyp3Bc
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="mol-mm.patch"

diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index c6b1aa3..455fb38 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -189,6 +189,7 @@ EXPORT_SYMBOL(set_context);
 extern long mol_trampoline;
 EXPORT_SYMBOL(mol_trampoline); /* For MOL */
 EXPORT_SYMBOL(flush_hash_pages); /* For MOL */
+EXPORT_SYMBOL(handle_mm_fault); /* For MOL */
 #ifdef CONFIG_SMP
 extern int mmu_hash_lock;
 EXPORT_SYMBOL(mmu_hash_lock); /* For MOL */

--pvezYHf7grwyp3Bc--
