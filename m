Return-Path: <linux-kernel-owner+w=401wt.eu-S937781AbXG0VZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937781AbXG0VZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 17:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764663AbXG0VZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 17:25:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51700 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761459AbXG0VZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 17:25:31 -0400
Date: Fri, 27 Jul 2007 23:26:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] alpha: fix two section mismatch warnings
Message-ID: <20070727212641.GA16236@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following section mismatch warnings:

WARNING: o-alpha/vmlinux.o(.text+0x1a4d4): Section mismatch: reference to .init.text:free_area_init (between 'paging_init' and 'srm_paging_stop')
WARNING: o-alpha/vmlinux.o(.text+0x1a4dc): Section mismatch: reference to .init.text:free_area_init (between 'paging_init' and 'srm_paging_stop')

One instance of paging_init() was declared __init but not the other one - used by defconfig.
Fixed by declaring the second instance ___init too.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index 550f490..5e6da47 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -267,8 +267,7 @@ callback_init(void * kernel_end)
 /*
  * paging_init() sets up the memory map.
  */
-void
-paging_init(void)
+void __init paging_init(void)
 {
 	unsigned long zones_size[MAX_NR_ZONES] = {0, };
 	unsigned long dma_pfn, high_pfn;
