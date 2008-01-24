Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYAXGKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYAXGKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 01:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYAXGKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 01:10:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:51733 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYAXGKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 01:10:12 -0500
Date: Thu, 24 Jan 2008 00:07:32 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Greg KH <greg@kroah.com>
cc: linux-pci@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] [POWERPC] Always build setup-bus.c on powerpc
Message-ID: <Pine.LNX.4.64.0801240006380.21347@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common arch/powerpc code calls in to functions in setup-bus.c
so some builds of ppc32 would fail.

Note, ppc32 usage of setup-irq.c is limited to arch/ppc and should be
removed when arch/ppc goes away.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

Greg, recent changes that BenH has made to the arch/powerpc pci code make
this necessary. If you don't have an issue I'd like this patch to go via
the paulus's powerpc.git tree.

- k

 drivers/pci/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 945bf02..869d689 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -31,8 +31,8 @@ obj-$(CONFIG_ALPHA) += setup-bus.o setup-irq.o
 obj-$(CONFIG_ARM) += setup-bus.o setup-irq.o
 obj-$(CONFIG_PARISC) += setup-bus.o
 obj-$(CONFIG_SUPERH) += setup-bus.o setup-irq.o
-obj-$(CONFIG_PPC32) += setup-irq.o setup-bus.o
-obj-$(CONFIG_PPC64) += setup-bus.o
+obj-$(CONFIG_PPC) += setup-bus.o
+obj-$(CONFIG_PPC32) += setup-irq.o
 obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
 obj-$(CONFIG_X86_VISWS) += setup-irq.o

-- 
1.5.3.7

