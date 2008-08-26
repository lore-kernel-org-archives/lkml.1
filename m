Return-Path: <linux-kernel-owner+w=401wt.eu-S1759769AbYHZThe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759769AbYHZThe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756515AbYHZTh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:37:26 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:50195 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbYHZThZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:37:25 -0400
Date: Tue, 26 Aug 2008 21:37:21 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Paul Mundt <lethal@linux-sh.org>, video4linux-list@redhat.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] VIDEO_SH_MOBILE_CEU should depend on HAS_DMA (was: Re: m68k
 allmodconfig)
In-Reply-To: <20080814195522.ad74990c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0808262035310.7910@anakin>
References: <20080814195522.ad74990c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Andrew,

On Thu, 14 Aug 2008, Andrew Morton wrote:
> ERROR: "dma_alloc_coherent" [drivers/media/video/videobuf-dma-contig.ko] undefined!
> ERROR: "dma_sync_single_for_cpu" [drivers/media/video/videobuf-dma-contig.ko] undefined!
> ERROR: "dma_free_coherent" [drivers/media/video/videobuf-dma-contig.ko] undefined!

M68k allmodconfig still selects Sun-3, which sets NO_DMA.
I guess you're also seeing this on the other NO_DMA platforms (h8300, m32r,
s390, and PCI-less SPARC)?

Below is a patch.

Shouldn't it also (or instead) depend on SUPERH or some SuperH platform?
Or is this not done to have more compile-coverage?

Subject: [PATCH] VIDEO_SH_MOBILE_CEU should depend on HAS_DMA

commit 0d3244d6439c8c31d2a29efd587c7aca9042c8aa ("V4L/DVB (8342):
sh_mobile_ceu_camera: Add SuperH Mobile CEU driver V3") introduced
VIDEO_SH_MOBILE_CEU, which selects VIDEOBUF_DMA_CONTIG. This circumvents the
dependency on HAS_DMA of VIDEOBUF_DMA_CONTIG.

Add a dependency on HAS_DMA to VIDEO_SH_MOBILE_CEU to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -968,7 +968,7 @@ config VIDEO_PXA27x
 
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
-	depends on VIDEO_DEV
+	depends on VIDEO_DEV && HAS_DMA
 	select SOC_CAMERA
 	select VIDEOBUF_DMA_CONTIG
 	---help---

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
