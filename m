Return-Path: <linux-kernel-owner+w=401wt.eu-S1761645AbZBMO6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761645AbZBMO6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbZBMO56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:57:58 -0500
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:13483
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752138AbZBMO55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:57:57 -0500
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 09:57:57 EST
X-BigFish: VPS1(zzzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KF0EW6-02-JAM-01
Date: Fri, 13 Feb 2009 15:57:35 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] x86: memtest: add additional (silly) test patterns
Message-ID: <20090213145735.GE13000@alberich.amd.com>
References: <20090213144600.GA6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090213144600.GA6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Feb 2009 14:57:46.0024 (UTC) FILETIME=[6E117A80:01C98DEB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/memtest.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 54c143b..e3e986d 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -9,15 +9,25 @@
 
 #include <asm/e820.h>
 
+#ifdef CONFIG_X86_64
+#define _regular_pattern(p) 0x##p##p##p##p##p##p##p##p##UL
+#else
+#define _regular_pattern(p) 0x##p##p##p##p##UL
+#endif
+
 static unsigned long patterns[] = {
-	0UL,
-	-1UL,
+	_regular_pattern(00),_regular_pattern(ff),
+	_regular_pattern(55),_regular_pattern(aa),
+	_regular_pattern(11),_regular_pattern(22),
+	_regular_pattern(44),_regular_pattern(88),
+	_regular_pattern(33),_regular_pattern(66),
+	_regular_pattern(99),_regular_pattern(cc),
+	_regular_pattern(77),_regular_pattern(bb),
+	_regular_pattern(dd),_regular_pattern(ee),
 #ifdef CONFIG_X86_64
-	0x5555555555555555UL,
-	0xaaaaaaaaaaaaaaaaUL,
+	0x7a6c7258554e494cUL, /* 64-bit only ;-) */
 #else
-	0x55555555UL,
-	0xaaaaaaaaUL,
+	0xefbeadde,
 #endif
 };
 
-- 
1.6.1.2



