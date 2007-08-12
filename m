Return-Path: <linux-kernel-owner+w=401wt.eu-S933793AbXHLJq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793AbXHLJq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761931AbXHLJnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:43:52 -0400
Received: from astra.telenet-ops.be ([195.130.132.58]:55973 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551AbXHLJnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:43:46 -0400
Message-Id: <20070812094119.026287596@mail.of.borg>
References: <20070812094050.522858761@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:40:57 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 07/10] m68k: Dont include RODATA into text segment
Content-Disposition: inline; filename=m68k-do-not-include-RODATA-in-text-segment.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Zippel <zippel@linux-m68k.org>

Don't include RODATA into text segment as it includes the kallsyms data
and can cause spurious link failures (layout differences can change the
number of symbols in kallsyms, i.e. when a symbol is equal to _etext it's
not included).

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/vmlinux-std.lds |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -19,6 +19,8 @@ SECTIONS
 	*(.gnu.warning)
 	} :text = 0x4e75
 
+  _etext = .;			/* End of text section */
+
   . = ALIGN(16);		/* Exception table */
   __start___ex_table = .;
   __ex_table : { *(__ex_table) }
@@ -26,8 +28,6 @@ SECTIONS
 
   RODATA
 
-  _etext = .;			/* End of text section */
-
   .data : {			/* Data */
 	DATA_DATA
 	CONSTRUCTORS

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

