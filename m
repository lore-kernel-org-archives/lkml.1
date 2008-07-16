Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbYGPXLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbYGPXLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759587AbYGPXLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:11:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:53704 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759011AbYGPXLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:11:05 -0400
Date: Wed, 16 Jul 2008 18:05:58 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: linuxppc-dev@ozlabs.org
cc: davej@redhat.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/ep8248e: Unconditionally select PHYLIB for mdio_bitbang
Message-ID: <Pine.LNX.4.64.0807161802590.26841@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its possible to build the phylib as a module, however this breaks the
board code because alloc_mdio_bitbang and mdiobus_register are not
available if we build as a module.  These are needed by the board code
since it implements the low level mdio bitbang ops.

So we unconditionally select PHYLIB to ensure its built into the kernel
if we are building in EP8248E support.

Long term we should look at moving the mdio_ops into its own file so it
can be built as a module.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

This patch supercededs:

[PATCH] powerpc/ep8248e: Fix compile problem if !CONFIG_FS_ENET

I've reverted the old patch and applied the new patch in my git tree and
have asked Ben to pull and push it to Linus.

- k

 arch/powerpc/platforms/82xx/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/82xx/Kconfig b/arch/powerpc/platforms/82xx/Kconfig
index 1c8034b..75eb1ed 100644
--- a/arch/powerpc/platforms/82xx/Kconfig
+++ b/arch/powerpc/platforms/82xx/Kconfig
@@ -30,6 +30,7 @@ config EP8248E
 	select 8272
 	select 8260
 	select FSL_SOC
+	select PHYLIB
 	select MDIO_BITBANG
 	help
 	  This enables support for the Embedded Planet EP8248E board.
-- 
1.5.5.1

