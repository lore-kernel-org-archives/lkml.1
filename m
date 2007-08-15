Return-Path: <linux-kernel-owner+w=401wt.eu-S1762894AbXHOJvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762894AbXHOJvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757756AbXHOJuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:50:01 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:58659 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbXHOJt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:49:56 -0400
Message-Id: <20070815094848.728170818@mail.of.borg>
References: <20070815094539.181979221@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 11:45:41 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 02/10] m68k: Dont include RODATA into text segment
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

