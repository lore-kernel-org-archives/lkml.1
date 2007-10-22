Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbXJVPh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbXJVPh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 11:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbXJVPhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 11:37:15 -0400
Received: from xenotime.net ([66.160.160.81]:45457 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752638AbXJVPhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 11:37:13 -0400
Date: Mon, 22 Oct 2007 08:37:08 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: James.Bottomley@HansenPartnership.com
Subject: [PATCH] voyager: use struct instead of PARAM
Message-Id: <20071022083708.54669a86.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Use struct boot_params instead of PARAM + 0xoffsets.
Fixes one of many Voyager build problems.

arch/x86/kernel/setup_32.c:543: error: 'PARAM' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/asm-x86/mach-voyager/setup_arch.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2623-g14-x32.orig/include/asm-x86/mach-voyager/setup_arch.h
+++ linux-2623-g14-x32/include/asm-x86/mach-voyager/setup_arch.h
@@ -1,5 +1,7 @@
 #include <asm/voyager.h>
-#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *)(PARAM+0x40))
+#include <asm/setup_32.h>
+#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *) \
+			(&boot_params.apm_bios_info))
 
 /* Hook to call BIOS initialisation function */
 
