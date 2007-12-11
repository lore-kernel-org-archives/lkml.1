Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbXLKWYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbXLKWYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbXLKWW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:22:28 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38512 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756647AbXLKWW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:22:27 -0500
Date: Tue, 11 Dec 2007 23:22:28 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86_32: disable_pse must be __cpuinitdata
Message-ID: <20071211222228.GP14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch with CONFIG_HOTPLUG=n,
CONFIG_HOTPLUG_CPU=y:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0xfa52): Section mismatch: reference to .init.data:disable_pse (between 'identify_cpu' and 'identify_secondary_cpu')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4cd9e8dd188db19d1ef697beb1fceb2ae67294a1 
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index e1e18c3..9c24b45 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -67,7 +67,7 @@
    address, and must not be in the .bss segment! */
 unsigned long init_pg_tables_end __initdata = ~0UL;
 
-int disable_pse __devinitdata = 0;
+int disable_pse __cpuinitdata = 0;
 
 /*
  * Machine setup..

