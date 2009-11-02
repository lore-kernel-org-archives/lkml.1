Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZKBKzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZKBKzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZKBKzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:55:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38199 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbZKBKzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:55:13 -0500
Date: Mon, 2 Nov 2009 11:55:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 3/3] msm: Add memory map for HTC Dream
Message-ID: <20091102105512.GA23559@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add memory map to HTC Dream, so that boot can proceed further.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- linux-good//arch/arm/mach-msm/board-dream.c	2009-11-02 11:54:12.000000000 +0100
+++ linux-dream-mainline/arch/arm/mach-msm/board-dream.c	2009-11-02 11:11:47.000000000 +0100
@@ -21,6 +21,7 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/setup.h>
 
 #include <mach/board.h>
 #include <mach/hardware.h>
@@ -44,6 +45,15 @@
 	msm_init_irq();
 }
 
+static void __init trout_fixup(struct machine_desc *desc, struct tag *tags,
+				char **cmdline, struct meminfo *mi)
+{
+	mi->nr_banks = 1;
+	mi->bank[0].start = PHYS_OFFSET;
+	mi->bank[0].node = PHYS_TO_NID(PHYS_OFFSET);
+	mi->bank[0].size = (101*1024*1024);
+}
+
 static void __init trout_init(void)
 {
 	platform_add_devices(devices, ARRAY_SIZE(devices));
@@ -77,6 +87,7 @@
 	.io_pg_offst	= ((MSM_DEBUG_UART_BASE) >> 18) & 0xfffc,
 #endif
 	.boot_params	= 0x10000100,
+	.fixup		= trout_fixup,
 	.map_io		= trout_map_io,
 	.init_irq	= trout_init_irq,
 	.init_machine	= trout_init,

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
