Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbYIJUQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbYIJUQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbYIJUQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:16:06 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:36248 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYIJUQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:16:04 -0400
Message-Id: <20080910201530.880263695@mail.of.borg>
References: <20080910201517.233690597@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 10 Sep 2008 22:15:18 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, video4linux-list@redhat.com,
       Magnus Damm <damm@igel.co.jp>
Subject: [patch 1/2] VIDEO_SH_MOBILE_CEU should depend on HAS_DMA
Content-Disposition: inline; filename=VIDEO_SH_MOBILE_CEU-needs-DMA.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 0d3244d6439c8c31d2a29efd587c7aca9042c8aa ("V4L/DVB (8342):
sh_mobile_ceu_camera: Add SuperH Mobile CEU driver V3") introduced
VIDEO_SH_MOBILE_CEU, which selects VIDEOBUF_DMA_CONTIG. This circumvents the
dependency on HAS_DMA of VIDEOBUF_DMA_CONTIG.

Add a dependency on HAS_DMA to VIDEO_SH_MOBILE_CEU to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Magnus Damm <damm@igel.co.jp>
---
This broke m68k allmodconfig (which still selects Sun-3). I assume it also
affects the other NO_DMA platforms like h8300, m32r, s390, and PCI-less
SPARC?

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

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

