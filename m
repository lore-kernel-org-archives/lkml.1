Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbXK0MWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbXK0MWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 07:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbXK0MWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 07:22:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47700 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbXK0MWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 07:22:30 -0500
Date: Tue, 27 Nov 2007 13:23:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>
Subject: [patch] Fix hpet wrong values
Message-ID: <20071127122308.GA2640@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If hpet is not enabled in config, its init should not pretend to work,
and people should not try to get time from it. 

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/include/asm-x86/hpet.h b/include/asm-x86/hpet.h
index b1f3c1e..1777d68 100644
--- a/include/asm-x86/hpet.h
+++ b/include/asm-x86/hpet.h
@@ -81,8 +81,8 @@ #endif /* CONFIG_HPET_EMULATE_RTC */
 
 #else
 
-static inline int hpet_enable(void) { return 0; }
-static inline unsigned long hpet_readl(unsigned long a) { return 0; }
+static inline int hpet_enable(void) { return -ENODEV; }
+static inline unsigned long hpet_readl(unsigned long a) { BUG(); }
 
 #endif /* CONFIG_HPET_TIMER */
 #endif /* ASM_X86_HPET_H */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
