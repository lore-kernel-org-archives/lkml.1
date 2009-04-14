Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZDNNAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZDNNAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZDNM7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:59:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32940 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752339AbZDNM7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:59:51 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/4] parport_pc: Fix build failure
	drivers/parport/parport_pc.c for powerpc
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 14 Apr 2009 14:58:41 +0100
Message-ID: <20090414135828.13935.22659.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090414135501.13935.13500.stgit@t61.ukuu.org.uk>
References: <20090414135501.13935.13500.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Breeds <tony@bakeyournoodle.com>

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
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

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

