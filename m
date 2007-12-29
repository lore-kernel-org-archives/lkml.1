Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbXL2QOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbXL2QOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 11:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXL2QOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 11:14:24 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:37664 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832AbXL2QOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 11:14:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAJEBdkdMROHU/2dsb2JhbACBV6oO
Date: Sat, 29 Dec 2007 11:09:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       paulus@samba.org, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6.24 patch] Fix Cell OProfile support
Message-ID: <20071229160921.GB12262@Krystal>
References: <20071228185649.GC4738@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071228185649.GC4738@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:08:39 up 55 days, 21:14,  4 users,  load average: 0.43, 0.62,
	0.60
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restores the Cell OProfile support that was killed by
commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.

It puts it in arch/powerpc/Kconfig. Since I don't see any good reason to leave
this as a supplementary user-selectable option, it is now automatically enabled
whenever SPU_FS and OPROFILE are enabled.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Adrian Bunk <adrian.bunk@movial.fi>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: phil.el@wanadoo.fr
CC: paulus@samba.org
CC: linuxppc-dev@ozlabs.org
CC: oprofile-list@lists.sourceforge.net
---
 arch/powerpc/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-12-28 17:00:24.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-12-28 17:00:39.000000000 -0500
@@ -163,6 +163,10 @@ config PPC_OF_PLATFORM_PCI
 	depends on PPC64 # not supported on 32 bits yet
 	default n
 
+config OPROFILE_CELL
+	def_bool y
+	depends on (SPU_FS = y && OPROFILE = m) || (SPU_FS = y && OPROFILE = y)
+
 source "init/Kconfig"
 
 source "arch/powerpc/platforms/Kconfig"

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
