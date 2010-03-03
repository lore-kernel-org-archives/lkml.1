Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0CCWDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 17:03:08 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:55787 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab0CCWC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 17:02:57 -0500
Date: Wed, 3 Mar 2010 22:33:29 +0100
From: Anders Larsen <al@alarsen.net>
To: linux-arm-kernel@lists.infradead.org
Cc: Andrew Victor <avictor.za@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       Julien Langer <julien.langer@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] AT91 slow-clock suspend: don't wait when turning PLLs
	off
Message-ID: <20100303213329.GA500@alarsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: anders@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Langer <julien.langer@gmail.com>

AT91: when turning off the PLLs during suspend, don't wait for the lock flag
to be set. Previously the code would always run into the loop limitation
of 1000 iterations because the flag is never set when turning the PLLs off.

Signed-off-by: Julien Langer <julien.langer@gmail.com>
Signed-off-by: Anders Larsen <al@alarsen.net>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-at91/pm_slowclock.S |    4 ----
 1 file changed, 4 deletions(-)

Index: b/arch/arm/mach-at91/pm_slowclock.S
===================================================================
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -175,8 +175,6 @@ ENTRY(at91_slow_clock)
 	orr	r3, r3, #(1 << 29)		/* bit 29 always set */
 	str	r3, [r1, #(AT91_CKGR_PLLAR - AT91_PMC)]
 
-	wait_pllalock
-
 	/* Save PLLB setting and disable it */
 	ldr	r3, [r1, #(AT91_CKGR_PLLBR - AT91_PMC)]
 	str	r3, .saved_pllbr
@@ -184,8 +182,6 @@ ENTRY(at91_slow_clock)
 	mov	r3, #AT91_PMC_PLLCOUNT
 	str	r3, [r1, #(AT91_CKGR_PLLBR - AT91_PMC)]
 
-	wait_pllblock
-
 	/* Turn off the main oscillator */
 	ldr	r3, [r1, #(AT91_CKGR_MOR - AT91_PMC)]
 	bic	r3, r3, #AT91_PMC_MOSCEN
