Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab0BCPXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:23:14 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:45823 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756714Ab0BCPXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:23:10 -0500
Date: Wed, 3 Feb 2010 16:23:22 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: albert_herranz@yahoo.es
Cc: siccegge@stud.informatik.uni-erlangen.de,
       vamos@i4.informatik.uni-erlangen.de, linux-kernel@vger.kernel.org,
       mb@bu3sch.de
Subject: Unreachable block in Kernel Code (CONFIG_SSB_SDIO)
Message-ID: <20100203152322.GA7167@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	In git commit 24ea602e183ca20a7577ebe253323d0e5d0f9847 you
introduced SDIO in drivers/ssb/main.c. While most of the config checks
look for CONFIG_SSB_SDIOHOST there's one check for CONFIG_SSB_SDIO
which looks wrong (and is one of the CONFIG_ vars that are not defined
anywhere in source neither avaiable in kconfig.

	Changing this only occurence to SDIOHOST [0] as well however
unfortunately results in a build failure [1] I can't find the correct
way to fix. Maybe you know how to correctly handle that?

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0]
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -494,7 +494,7 @@ static int ssb_devices_register(struct ssb_bus
*bus)
 #endif
                        break;
                case SSB_BUSTYPE_SDIO:
-#ifdef CONFIG_SSB_SDIO
+#ifdef CONFIG_SSB_SDIOHOST
                        sdev->irq = bus->host_sdio->dev.irq;
                        dev->parent = &bus->host_sdio->dev;
 #endif

[1]
drivers/ssb/main.c: In function 'ssb_devices_register':
drivers/ssb/main.c:498: error: 'struct device' has no member named 'irq'
