Return-Path: <linux-kernel-owner+w=401wt.eu-S937492AbXGNBfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937492AbXGNBfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765704AbXGNBaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:30:16 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38860 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764834AbXGNBaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:30:11 -0400
Message-Id: <20070714012904.448339795@polymtl.ca>
References: <20070714012752.912348630@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:27:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, paulus@samba.org,
       linuxppc-dev@ozlabs.org
Subject: [patch 2/3] Add missing DATA_DATA in powerpc
Content-Disposition: inline; filename=use-data-data-in-powerpc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:29:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Newer asm-generic/vmlinux.lds.h provides a DATA_DATA macro which defines the
content of what is normally referred to by *(.data). It permits adding more
"subsections" (declared by gcc with the section attribute or in assembly), which
will be linked in the .data section.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: paulus@samba.org
CC: linuxppc-dev@ozlabs.org
--
 arch/powerpc/kernel/vmlinux.lds.S |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/powerpc/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/vmlinux.lds.S	2007-07-11 11:55:48.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/kernel/vmlinux.lds.S	2007-07-11 15:48:42.000000000 -0400
@@ -174,7 +174,9 @@
 	}
 #else
 	.data : {
-		*(.data .data.rel* .toc1)
+		DATA_DATA
+		*(.data.rel*)
+		*(.toc1)
 		*(.branch_lt)
 	}
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
