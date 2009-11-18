Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbZKRNXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbZKRNXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 08:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZKRNXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 08:23:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43528 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZKRNXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 08:23:50 -0500
Date: Wed, 18 Nov 2009 10:01:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.32-rc7: compile regression on spitz
Message-ID: <20091118090100.GA1399@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If CONFIG_AKITA is not set, spitz fails to compile. It worked ok in
rc5. Fix is one more ifdef...

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- a/arch/arm/mach-pxa/spitz.c	2009-11-17 17:10:21.000000000 +0100
+++ b/arch/arm/mach-pxa/spitz.c	2009-11-18 05:55:21.000000000 +0100
@@ -802,10 +802,12 @@
 {
 	spitz_ficp_platform_data.gpio_pwdown = SPITZ_GPIO_IR_ON;
 
+#ifdef CONFIG_MACH_BORZOI
 	if (machine_is_borzoi()) {
 		sharpsl_nand_platform_data.badblock_pattern = &sharpsl_akita_bbt;
 		sharpsl_nand_platform_data.ecc_layout = &akita_oobinfo;
 	}
+#endif
 
 	platform_scoop_config = &spitz_pcmcia_config;
 





-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
