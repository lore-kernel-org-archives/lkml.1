Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbYICHT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbYICHT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 03:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYICHST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 03:18:19 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:55232 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYICHSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 03:18:13 -0400
Message-Id: <20080903071742.640740341@mail.of.borg>
References: <20080903071542.615137611@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 09:15:48 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 6/8] m68k: Define rtc_lock on Atari
Content-Disposition: inline; filename=atari-define-rtc_lock.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

The nvram and rtc-cmos drivers use the spinlock rtc_lock to protect against
concurrent accesses to the CMOS memory. As m68k doesn't support SMP or preempt
yet, the spinlock calls tend to get optimized away, but not for all
configurations, causing in some rare cases:

| ERROR: "rtc_lock" [drivers/rtc/rtc-cmos.ko] undefined!
| ERROR: "rtc_lock" [drivers/char/nvram.ko] undefined!

Add the spinlock to the Atari core code to avoid this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/atari/time.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/m68k/atari/time.c
+++ b/arch/m68k/atari/time.c
@@ -20,6 +20,9 @@
 
 #include <asm/atariints.h>
 
+DEFINE_SPINLOCK(rtc_lock);
+EXPORT_SYMBOL_GPL(rtc_lock);
+
 void __init
 atari_sched_init(irq_handler_t timer_routine)
 {

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

