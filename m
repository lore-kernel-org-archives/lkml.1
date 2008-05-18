Return-Path: <linux-kernel-owner+w=401wt.eu-S1759734AbYERTBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbYERTBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759667AbYERSyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:54:07 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:52080 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761930AbYERSyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:54:00 -0400
Message-Id: <20080518185151.958136548@mail.of.borg>
References: <20080518184706.631023070@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 May 2008 20:47:15 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [patch 09/18] m68k: dnfb doesnt check for Apollo
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

