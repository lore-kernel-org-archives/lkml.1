Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbYERTDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbYERTDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760877AbYERSyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:54:19 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:57699 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761938AbYERSyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:54:05 -0400
Message-Id: <20080518185151.718572513@mail.of.borg>
References: <20080518184706.631023070@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 May 2008 20:47:14 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: [patch 08/18] m68k: macide doesnt check for Mac
Content-Disposition: inline; filename=m68k-macide-breaks-multi-platform.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

The Macintosh IDE driver (macide) doesn't check whether it's actually running
on Mac hardware, causing a crash if it isn't.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/ide/legacy/macide.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -95,6 +95,9 @@ static int __init macide_init(void)
 	int irq;
 	hw_regs_t hw;
 
+	if (!MACH_IS_MAC)
+		return -ENODEV;
+
 	switch (macintosh_config->ide_type) {
 	case MAC_IDE_QUADRA:
 		base = IDE_BASE;

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

