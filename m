Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZGLVvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZGLVvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 17:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbZGLVvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 17:51:15 -0400
Received: from hall.aurel32.net ([88.191.82.174]:54207 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbZGLVvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 17:51:14 -0400
X-Greylist: delayed 2387 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jul 2009 17:51:14 EDT
Date: Sun, 12 Jul 2009 17:58:33 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "Neither asm/types.h nor linux/types.h is required
	for arch/ia64/include/asm/fpu.h"
Message-ID: <20090712155833.GB12923@volta.aurel32.net>
Mail-Followup-To: Aurelien Jarno <aurelien@aurel32.net>,
	Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
	linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Mailer: Mutt 1.5.18 (2008-05-17)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm/fpu.h uses the __IA64_UL macro which is declared in asm/types.h, so
this include is really required. Without it, GNU libc fails to build.

This reverts commit 2678c07b07ac2076675e5d57653bdf02e9af1950.
---
 arch/ia64/include/asm/fpu.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/fpu.h b/arch/ia64/include/asm/fpu.h
index 0c26157..b6395ad 100644
--- a/arch/ia64/include/asm/fpu.h
+++ b/arch/ia64/include/asm/fpu.h
@@ -6,6 +6,8 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>
  */
 
+#include <linux/types.h>
+
 /* floating point status register: */
 #define FPSR_TRAP_VD	(1 << 0)	/* invalid op trap disabled */
 #define FPSR_TRAP_DD	(1 << 1)	/* denormal trap disabled */
-- 
1.6.1.3

-- 
Aurelien Jarno	                        GPG: 1024D/F1BCDB73
aurelien@aurel32.net                 http://www.aurel32.net
