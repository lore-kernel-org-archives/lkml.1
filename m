Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbXLCWDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbXLCWDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXLCWC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:02:59 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:54899 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbXLCWC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:02:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HACkMVEdMROHU/2dsb2JhbACBWw
Date: Mon, 3 Dec 2007 17:02:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix AVR32 for instrumentation menu removal
Message-ID: <20071203220254.GA7149@Krystal>
References: <1196689618-17503-1-git-send-email-hskinnemoen@atmel.com> <1196689618-17503-2-git-send-email-hskinnemoen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1196689618-17503-2-git-send-email-hskinnemoen@atmel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:00:30 up 30 days,  3:05,  5 users,  load average: 0.18, 0.21,
	0.23
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting : Haavard Skinnemoen <hskinnemoen@atmel.com>

Mathieu, I want to get oprofile support queued up for 2.6.25, and
since I don't see any signs that the Kconfig.instrumentation removal
patches are going in any time soon, I'm going to turn things around
and apply these two patches to my tree.

This unfortunately means that your patch won't apply cleanly to -mm
anymore, but it'll hopefully be easy to fix. When you do, please add
ARCH_SUPPORTS_OPROFILE to arch/avr32/Kconfig as well.

Me:

This patch fixes the changes made by [PATCH 2/2] [AVR32] Oprofile support so the
instrumentation removal patch applies correctly.

Should be applied after "[PATCH 2/2] [AVR32] Oprofile support", but before the
instrumentation menu removal patches.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/Kconfig.instrumentation |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.orig/kernel/Kconfig.instrumentation	2007-12-03 16:52:42.000000000 -0500
+++ linux-2.6-lttng/kernel/Kconfig.instrumentation	2007-12-03 16:52:54.000000000 -0500
@@ -21,7 +21,7 @@ config PROFILING
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
 	depends on PROFILING
-	depends on ALPHA || ARM || AVR32 || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
+	depends on ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
