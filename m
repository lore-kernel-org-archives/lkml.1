Return-Path: <linux-kernel-owner+w=401wt.eu-S1762328AbYDXSgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762328AbYDXSgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757917AbYDXSeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:34:24 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:50953 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbYDXSeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:34:16 -0400
Message-Id: <20080424183242.692694606@mail.of.borg>
References: <20080424182940.424312704@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 20:29:49 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [patch 09/15] m68k: dnfb doesnt check for Apollo
Content-Disposition: inline; filename=m68k-dnfb-breaks-multi-platform.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

The Apollo frame buffer device driver (dnfb) doesn't check whether it's
actually running on Apollo hardware, causing a crash if it isn't.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/dnfb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/dnfb.c
+++ b/drivers/video/dnfb.c
@@ -284,6 +284,9 @@ int __init dnfb_init(void)
 {
 	int ret;
 
+	if (!MACH_IS_APOLLO)
+		return -ENODEV;
+
 	if (fb_get_options("dnfb", NULL))
 		return -ENODEV;
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

