Return-Path: <linux-kernel-owner+w=401wt.eu-S1761018AbZBMO7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018AbZBMO7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbZBMO73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:59:29 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:55189 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637AbZBMO73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:59:29 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 09:59:28 EST
X-BigFish: VPS3(zzzzzzz32i6bh43j)
X-WSS-ID: 0KF0EYN-02-JCS-01
Date: Fri, 13 Feb 2009 15:59:05 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] x86: memtest: wipe out test pattern from memory
Message-ID: <20090213145905.GF13000@alberich.amd.com>
References: <20090213144600.GA6298@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090213144600.GA6298@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Feb 2009 14:59:15.0853 (UTC) FILETIME=[A39C4BD0:01C98DEB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/memtest.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index e3e986d..bea66d5 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -126,6 +126,13 @@ void __init early_memtest(unsigned long start, unsigned long end)
 
 			t_start += t_size;
 		}
+		if (idx && (i == (memtest_pattern - 1))) {
+			i = -1;
+			memtest_pattern = 1;
+			printk(KERN_CONT "\n");
+			printk(KERN_INFO "early_memtest: wipe out last pattern");
+			continue; /* one more test to wipe out patterns */
+		}
 	}
 	printk(KERN_CONT "\n");
 }
-- 
1.6.1.2



