Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbZBBVqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbZBBVqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZBBVqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:46:37 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:60071 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbZBBVqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:46:36 -0500
Date: Mon, 2 Feb 2009 22:46:28 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
cc: uClinux development list <uclinux-dev@uclinux.org>,
       Greg Ungerer <gerg@uclinux.org>, Sam Ravnborg <sam@ravnborg.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [uClinux-dev] [PATCH] m68k: Unify arch/m68k/include/asm/unistd.h
In-Reply-To: <498599A6.7080202@snapgear.com>
Message-ID: <Pine.LNX.4.64.0902022245400.15898@anakin>
References: <Pine.LNX.4.64.0902011114410.30504@anakin> <498599A6.7080202@snapgear.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Feb 2009, Greg Ungerer wrote:
> Geert Uytterhoeven wrote:
>       m68k: use mmu scatterlist.h for non-mmu setups as well

A small cleanup:

>From bb3640a02d427175006f8d0c49311bf7a2290dd0 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 2 Feb 2009 22:14:23 +0100
Subject: [PATCH] m68k: Use dma_addr_t for scatterlist.dma_address

dma_addr_t (as was used by m68knommu) is more correct than u32.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/scatterlist.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/scatterlist.h b/arch/m68k/include/asm/scatterlist.h
index d3a7a0e..e27ad90 100644
--- a/arch/m68k/include/asm/scatterlist.h
+++ b/arch/m68k/include/asm/scatterlist.h
@@ -11,7 +11,7 @@ struct scatterlist {
 	unsigned int offset;
 	unsigned int length;
 
-	__u32 dma_address;	/* A place to hang host-specific addresses at. */
+	dma_addr_t dma_address;	/* A place to hang host-specific addresses at. */
 };
 
 /* This is bogus and should go away. */
-- 
1.5.6.5


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
