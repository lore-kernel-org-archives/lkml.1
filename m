Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbYJVGue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbYJVGue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 02:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYJVGuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 02:50:24 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:44700 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYJVGuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:50:24 -0400
Date: Wed, 22 Oct 2008 08:50:19 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       ArjanvandeVen <arjan@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
cc: linux-pci@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] <linux/pci.h> needs <linux/io.h> for ioremap_nocache()
Message-ID: <Pine.LNX.4.64.0810220848400.8356@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit aa42d7c6138afdc54f74e971456a0fbfec16b77b ("PCI: introduce an
pci_ioremap(pdev, barnr) function") added a static inline function that calls
ioremap_nocache(), causing a compile error on m68k:

| In file included from drivers/ide/ide.c:58:
| include/linux/pci.h: In function 'pci_ioremap_bar':
| include/linux/pci.h:1132: error: implicit declaration of function 'ioremap_nocache'
| include/linux/pci.h:1133: warning: return makes pointer from integer without a cast
| In file included from include/linux/bio.h:30,
|                  from include/linux/blkdev.h:17,
|                  from include/linux/ide.h:13,
|                  from drivers/ide/ide.c:59:

Include <linux/io.h> to provide the prototype for ioremap_nocache().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
FWIW...
Discovered in the linux-next builds on Oct 21, which was actually the one of
Oct 20 (Ozlabs time)
Discovered in the mainline builds two day later

 include/linux/pci.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -44,6 +44,7 @@
 
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/list.h>
 #include <linux/compiler.h>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
