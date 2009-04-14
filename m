Return-Path: <linux-kernel-owner+w=401wt.eu-S1752300AbZDNFdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbZDNFdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 01:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZDNFdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 01:33:42 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:40012 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZDNFdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 01:33:41 -0400
To: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-Id: <aea82416ed6c6805412a2631fe8a8be6420c5c9d.1239687192.git.tony@bakeyournoodle.com>
From: Tony Breeds <tony@bakeyournoodle.com>
Subject: [PATCH 1/1] Fix build failure drivers/parport/parport_pc.c for powerpc
Date: Tue, 14 Apr 2009 15:33:40 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 51dcdfec6a274afc1c6fce180d582add9ff512c0 (parport: Use the PCI
IRQ if offered) parport_pc_probe_port() gained an irqflags arg.  This
isn't being supplied on powerpc.  This patch make powerpc fallback to
the old behaviour, that is using "0" for irqflags.

Fixes build failure:
In file included from drivers/parport/parport_pc.c:68:
arch/powerpc/include/asm/parport.h: In function 'parport_pc_find_nonpci_ports':
arch/powerpc/include/asm/parport.h:32: error: too few arguments to function 'parport_pc_probe_port'
arch/powerpc/include/asm/parport.h:32: error: too few arguments to function 'parport_pc_probe_port'
arch/powerpc/include/asm/parport.h:32: error: too few arguments to function 'parport_pc_probe_port'
make[3]: *** [drivers/parport/parport_pc.o] Error 1

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
Resend due to MUA badness

 arch/powerpc/include/asm/parport.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/parport.h b/arch/powerpc/include/asm/parport.h
index 414c50e..94942d6 100644
--- a/arch/powerpc/include/asm/parport.h
+++ b/arch/powerpc/include/asm/parport.h
@@ -29,7 +29,7 @@ static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma)
 		prop = of_get_property(np, "interrupts", NULL);
 		if (!prop)
 			continue;
-		if (parport_pc_probe_port(io1, io2, prop[0], autodma, NULL) != NULL)
+		if (parport_pc_probe_port(io1, io2, prop[0], autodma, NULL, 0) != NULL)
 			count++;
 	}
 	return count;
-- 
1.6.0.6

