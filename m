Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbYDVHls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbYDVHls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 03:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758918AbYDVHlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:41:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33476 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbYDVHlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:41:37 -0400
Date: Tue, 22 Apr 2008 09:41:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Philipp Zabel <philipp.zabel@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: drivers/mfd/htc-pasic3.c:22:31: error: asm/arch/pxa-regs.h: No
	such file or directory
Message-ID: <20080422074124.GA12187@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


make allyesconfig (on 64-bit x86) build fails on latest -git with the 
following message:

drivers/mfd/htc-pasic3.c:22:31: error: asm/arch/pxa-regs.h: No such file or directory

i suspect this driver was not supposed to be buildable on non-ARM-PXA? 
The patch below should fix this.

	Ingo

------------>
Subject: mtd: htc pasic3 build fix
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Apr 22 09:24:38 CEST 2008

build fix:

  drivers/mfd/htc-pasic3.c:22:31: error: asm/arch/pxa-regs.h: No such file or directory

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/mfd/Kconfig
===================================================================
--- linux.orig/drivers/mfd/Kconfig
+++ linux/drivers/mfd/Kconfig
@@ -32,6 +32,7 @@ config HTC_EGPIO
 
 config HTC_PASIC3
 	tristate "HTC PASIC3 LED/DS1WM chip support"
+	depends on ARCH_PXA
 	help
 	  This core driver provides register access for the LED/DS1WM
 	  chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
