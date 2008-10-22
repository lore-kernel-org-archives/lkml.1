Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYJVGyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYJVGyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 02:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYJVGxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 02:53:30 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:60757 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYJVGx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:53:29 -0400
Date: Wed, 22 Oct 2008 08:53:25 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Petazzoni <thomas.petazzoni@enix.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
cc: linux-pci@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] pci: PCI_QUIRKS depends on PCI
Message-ID: <Pine.LNX.4.64.0810220851440.8356@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3d137310245e4cdc3e8c8ba1bea2e145a87ae8e3 ("PCI: allow quirks to be
compiled out") introduced CONFIG_PCI_QUIRKS, which now shows up in each
and every .config.

Probably the intention was to make the PCI_QUIRKS symbol depend on PCI, not
on its selection enabler?

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 init/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -739,7 +739,8 @@ config VM_EVENT_COUNTERS
 
 config PCI_QUIRKS
 	default y
-	bool "Enable PCI quirk workarounds" if EMBEDDED && PCI
+	bool "Enable PCI quirk workarounds" if EMBEDDED
+	depends on PCI
 	help
 	  This enables workarounds for various PCI chipset
           bugs/quirks. Disable this only if your target machine is

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
