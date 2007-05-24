Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbXEXK0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbXEXK0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbXEXK0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:26:32 -0400
Received: from mx10.go2.pl ([193.17.41.74]:37264 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754922AbXEXK0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:26:31 -0400
Date: Thu, 24 May 2007 12:33:23 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] smpboot: cachesize comparison fix in smp_tune_scheduling()
Message-ID: <20070524103322.GA1920@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


smpboot: cachesize comparison fix in smp_tune_scheduling()

boot_cpu_data.x86_cache_size is signed int and can be < 0 too.

PS: this function is removed from current -mm.


Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.22-rc2-git5-/arch/i386/kernel/smpboot.c 2.6.22-rc2-git5/arch/i386/kernel/smpboot.c
--- 2.6.22-rc2-git5-/arch/i386/kernel/smpboot.c	2007-05-24 09:37:11.000000000 +0200
+++ 2.6.22-rc2-git5/arch/i386/kernel/smpboot.c	2007-05-24 11:48:03.000000000 +0200
@@ -948,7 +948,7 @@ static void smp_tune_scheduling(void)
 	if (cpu_khz) {
 		cachesize = boot_cpu_data.x86_cache_size;
 
-		if (cachesize > 0)
+		if ((long)cachesize > 0)
 			max_cache_size = cachesize * 1024;
 	}
 }
