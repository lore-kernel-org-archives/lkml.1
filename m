Return-Path: <linux-kernel-owner+w=401wt.eu-S1763372AbXHJXD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763372AbXHJXD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 19:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXHJXDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 19:03:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbXHJXDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 19:03:48 -0400
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] powerfc fix for assembler -g
X-Fcc: ~/Mail/linus
X-Windows: the joke that kills.
Message-Id: <20070810230311.34CFFD0136@magilla.localdomain>
Date: Fri, 10 Aug 2007 16:03:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ppc64 does the unusual thing of using #include on a compiler-generated
assembly file (lparmap.s) from an assembly source file (head_64.S).
This runs afoul of my recent patch to pass -gdwarf2 to the assembler
under CONFIG_DEBUG_INFO.  This patch avoids the problem by disabling
DWARF generation (-g0) when producing lparmap.s.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index f39a72f..b0cb2e6 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -81,6 +81,7 @@ obj-y				+= iomap.o
 endif
 
 ifeq ($(CONFIG_PPC_ISERIES),y)
+CFLAGS_lparmap.s		+= -g0
 extra-y += lparmap.s
 $(obj)/head_64.o:	$(obj)/lparmap.s
 AFLAGS_head_64.o += -I$(obj)
