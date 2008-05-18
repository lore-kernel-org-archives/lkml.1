Return-Path: <linux-kernel-owner+w=401wt.eu-S1763431AbYERTBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763431AbYERTBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761960AbYERSyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:54:01 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:57582 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761932AbYERSx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:53:59 -0400
Message-Id: <20080518185151.484995763@mail.of.borg>
References: <20080518184706.631023070@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 May 2008 20:47:13 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 07/18] m68k: Correct jump if not running on HP300
Content-Disposition: inline; filename=m68k-hp300-breaks-multi-platform.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

When running a HP300-enabled kernel on non-HP300 hardware, a test in the early
startup code jumps to the wrong label, causing a double bus fault.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/head.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -1434,7 +1434,7 @@ L(mmu_fixup_done):
 #endif
 
 #ifdef CONFIG_HP300
-	is_not_hp300(1f)
+	is_not_hp300(2f)
 	/*
 	 * Fix up the iobase register to point to the new location of the LEDs.
 	 */

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

