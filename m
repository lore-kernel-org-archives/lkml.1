Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYDXShP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYDXShP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758579AbYDXSe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:34:26 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:40326 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbYDXSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:34:17 -0400
Message-Id: <20080424183243.180200826@mail.of.borg>
References: <20080424182940.424312704@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 20:29:51 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [patch 11/15] m68k: Some input drivers do not check the platform
Content-Disposition: inline; filename=m68k-input-drivers-break-multiplatform.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

Some input drivers do not check whether they're actually running on the
correct platform, causing multi-platform kernels to crash if they are not.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

---
 drivers/input/misc/hp_sdc_rtc.c  |    5 +++++
 drivers/input/serio/hp_sdc_mlc.c |    5 +++++
 2 files changed, 10 insertions(+)

--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -691,6 +691,11 @@ static int __init hp_sdc_rtc_init(void)
 {
 	int ret;
 
+#ifdef __mc68000__
+	if (!MACH_IS_HP300)
+		return -ENODEV;
+#endif
+
 	init_MUTEX(&i8042tregs);
 
 	if ((ret = hp_sdc_request_timer_irq(&hp_sdc_rtc_isr)))
--- a/drivers/input/serio/hp_sdc_mlc.c
+++ b/drivers/input/serio/hp_sdc_mlc.c
@@ -306,6 +306,11 @@ static int __init hp_sdc_mlc_init(void)
 {
 	hil_mlc *mlc = &hp_sdc_mlc;
 
+#ifdef __mc68000__
+	if (!MACH_IS_HP300)
+		return -ENODEV;
+#endif
+
 	printk(KERN_INFO PREFIX "Registering the System Domain Controller's HIL MLC.\n");
 
 	hp_sdc_mlc_priv.emtestmode = 0;

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

