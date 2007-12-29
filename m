Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbXL2WAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbXL2WAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 17:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbXL2WAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 17:00:22 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:58775 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975AbXL2WAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 17:00:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAGpSdkdMROHU/2dsb2JhbACBV6gx
Date: Sat, 29 Dec 2007 17:00:18 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Adrian Bunk <adrian.bunk@movial.fi>, rmk@arm.linux.org.uk,
       phil.el@wanadoo.fr, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] Fix ARMv6 OProfile support
Message-ID: <20071229220018.GA25255@Krystal>
References: <20071228185636.GA4738@stusta.de> <20071229160556.GA12262@Krystal> <20071229100618.304433a7.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071229100618.304433a7.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:59:50 up 56 days,  3:05,  3 users,  load average: 0.79, 0.65,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restores the ARMv6 OProfile support that was killed by
commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.

It puts the config options in arch/arm/Kconfig.

Changelog :
Use def_bool.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Adrian Bunk <adrian.bunk@movial.fi>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: rmk@arm.linux.org.uk
CC: phil.el@wanadoo.fr
CC: oprofile-list@lists.sourceforge.net
---
 arch/arm/Kconfig |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-12-29 16:58:32.000000000 -0500
+++ linux-2.6-lttng/arch/arm/Kconfig	2007-12-29 16:59:25.000000000 -0500
@@ -130,6 +130,23 @@ config FIQ
 config ARCH_MTD_XIP
 	bool
 
+if OPROFILE
+
+config OPROFILE_ARMV6
+	def_bool y
+	depends on CPU_V6 && !SMP
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_MPCORE
+	def_bool y
+	depends on CPU_V6 && SMP
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_ARM11_CORE
+	bool
+
+endif
+
 config VECTORS_BASE
 	hex
 	default 0xffff0000 if MMU || CPU_HIGH_VECTOR

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
