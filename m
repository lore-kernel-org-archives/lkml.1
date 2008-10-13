Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYJMUGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYJMUGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYJMUFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:05:42 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:34614 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbYJMUFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:05:39 -0400
Message-Id: <20081013195913.713707918@mail.of.borg>
References: <20081013195846.674654386@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 21:58:49 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 03/18] m68k: Put .bss at the end of the data section
Content-Disposition: inline; filename=m68k-put-bss-at-end-of-data-section.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Zippel <zippel@linux-m68k.org>

Put .bss at the end of the data section

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/vmlinux-std.lds |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -34,10 +34,10 @@ SECTIONS
 	CONSTRUCTORS
 	}
 
-  .bss : { *(.bss) }		/* BSS */
-
   . = ALIGN(16);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) } :data
+  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+
+  .bss : { *(.bss) }		/* BSS */
 
   _edata = .;			/* End of data section */
 
@@ -48,7 +48,7 @@ SECTIONS
 	_sinittext = .;
 	INIT_TEXT
 	_einittext = .;
-  }
+  } :data
   .init.data : { INIT_DATA }
   . = ALIGN(16);
   __setup_start = .;

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

