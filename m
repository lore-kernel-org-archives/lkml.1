Return-Path: <linux-kernel-owner+w=401wt.eu-S1761135AbYFQWdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761135AbYFQWdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760527AbYFQWcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:32:08 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50758 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760495AbYFQWcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:32:06 -0400
Date: Wed, 18 Jun 2008 01:30:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh dreamcast: export board_pci_channels
Message-ID: <20080617223040.GI25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  MODPOST 1837 modules
ERROR: "board_pci_channels" [drivers/pcmcia/yenta_socket.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

I freely admit that it's a pathological configuration, but as long as 
it is allowed it should build.

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/sh/drivers/pci/ops-dreamcast.c |    2 ++
 1 file changed, 2 insertions(+)

632d9b2b1d3b5f3c0fed0353b098f92e28c4217d diff --git a/arch/sh/drivers/pci/ops-dreamcast.c b/arch/sh/drivers/pci/ops-dreamcast.c
index e1284fc..f54c291 100644
--- a/arch/sh/drivers/pci/ops-dreamcast.c
+++ b/arch/sh/drivers/pci/ops-dreamcast.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/pci.h>
+#include <linux/module.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -48,6 +49,7 @@ struct pci_channel board_pci_channels[] = {
 	  &gapspci_mem_resource, 0, 1 },
 	{ 0, }
 };
+EXPORT_SYMBOL(board_pci_channels);
 
 /*
  * The !gapspci_config_access case really shouldn't happen, ever, unless
