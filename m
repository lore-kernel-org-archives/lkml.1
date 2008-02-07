Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYBGIK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYBGIK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYBGIKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:10:47 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:57471 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbYBGIKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:10:46 -0500
Date: Thu, 7 Feb 2008 09:10:37 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <starvik@axis.com>
cc: Linux/m68k <linux-m68k@vger.kernel.org>, dev-etrax@axis.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: kill page walker compile warning
Message-ID: <Pine.LNX.4.64.0802070908310.4611@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recently introduced page walker (walk_page_range()) calls pgd_offset with a
const struct mm_struct pointer, causing the following compile warning on m68k:

    mm/pagewalk.c:111: warning: passing argument 1 of 'pgd_offset' discards qualifiers from pointer target type

Make the `mm' parameter of the inline function pgd_offset() const to shut it
up.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
As cris also uses an inline function, I expect a similar warning to show up
there. All other archs use a macro to define pgd_offset.

 include/asm-m68k/motorola_pgtable.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/asm-m68k/motorola_pgtable.h
+++ b/include/asm-m68k/motorola_pgtable.h
@@ -191,7 +191,8 @@ static inline pte_t pte_mkcache(pte_t pt
 #define pgd_index(address)     ((address) >> PGDIR_SHIFT)
 
 /* to find an entry in a page-table-directory */
-static inline pgd_t *pgd_offset(struct mm_struct *mm, unsigned long address)
+static inline pgd_t *pgd_offset(const struct mm_struct *mm,
+				unsigned long address)
 {
 	return mm->pgd + pgd_index(address);
 }

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
