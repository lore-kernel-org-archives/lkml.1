Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbZJVHVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbZJVHVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 03:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZJVHVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 03:21:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51053 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZJVHVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 03:21:21 -0400
Date: Thu, 22 Oct 2009 09:21:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: linux-mmc@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: msm_sdcc.c: add missing include
Message-ID: <20091022072119.GA3285@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add missing include for	msm_sdcc compilation.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/include/asm/mach/mmc.h b/arch/arm/include/asm/mach/mmc.h
new file mode 100644
index 0000000..8948dec
--- /dev/null
+++ b/arch/arm/include/asm/mach/mmc.h
@@ -0,0 +1,26 @@
+/*
+ *  arch/arm/include/asm/mach/mmc.h
+ */
+#ifndef ASMARM_MACH_MMC_H
+#define ASMARM_MACH_MMC_H
+
+#include <linux/mmc/host.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sdio_func.h>
+
+struct embedded_sdio_data {
+        struct sdio_cis cis;
+        struct sdio_cccr cccr;
+        struct sdio_embedded_func *funcs;
+        int num_funcs;
+};
+
+struct mmc_platform_data {
+	unsigned int ocr_mask;			/* available voltages */
+	u32 (*translate_vdd)(struct device *, unsigned int);
+	unsigned int (*status)(struct device *);
+	struct embedded_sdio_data *embedded_sdio;
+	int (*register_status_notify)(void (*callback)(int card_present, void *dev_id), void *dev_id);
+};
+
+#endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
