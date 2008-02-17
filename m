Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYBQNMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYBQNMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYBQNMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:12:12 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:52237 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbYBQNML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:12:11 -0500
Date: Sun, 17 Feb 2008 14:12:10 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] modpost: Fix reversed symbol name order
Message-ID: <Pine.LNX.4.64.0802171411400.19269@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XXXINIT_TO_INIT and XXXEXIT_TO_EXIT warnings use the reversed symbol name order
in the suggestion, e.g.:

    WARNING: vmlinux.o(.meminit.text+0x36c): Section mismatch in reference from the function free_area_init_core() to the function .init.text:setup_usemap()
    The function __meminit free_area_init_core() references
    a function __init setup_usemap().
    If free_area_init_core is only used by setup_usemap then
    annotate free_area_init_core with a matching annotation.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1200,7 +1200,7 @@ static void report_sec_mismatch(const ch
 		"annotate %s with a matching annotation.\n",
 		from, sec2annotation(fromsec), fromsym, from_p,
 		to, sec2annotation(tosec), tosym, to_p,
-		fromsym, tosym, fromsym);
+		tosym, fromsym, tosym);
 		break;
 	case INIT_TO_EXIT:
 		fprintf(stderr,

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
