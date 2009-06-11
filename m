Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbZFKDvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbZFKDvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbZFKDux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:50:53 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58579 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbZFKDuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:50:52 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: netdev@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Date: Thu, 11 Jun 2009 09:20:46 +0530
Message-Id: <20090611035046.22125.26641.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH][BUILD FAILURE 03/04] Next June 04:PPC64 randconfig [drivers/net/lance.o]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin/Paul,

>On Thu, 2009-06-04 at 19:02 +0530, Subrata Modak wrote:
>CC      drivers/net/lance.o
> drivers/net/lance.c: In function 'lance_probe1':
> drivers/net/lance.c:575: error: implicit declaration of function 'isa_virt_to_bus'
> drivers/net/lance.c: In function 'lance_rx':
> drivers/net/lance.c:1197: error: implicit declaration of function 'isa_bus_to_virt'
> make[2]: *** [drivers/net/lance.o] Error 1
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

Reference: http://lkml.org/lkml/2009/6/4/240,
To fix the following build error:

drivers/net/lance.c: In function 'lance_probe1':
drivers/net/lance.c:575: error: implicit declaration of function 'isa_virt_to_bus'
drivers/net/lance.c: In function 'lance_rx':
drivers/net/lance.c:1197: error: implicit declaration of function 'isa_bus_to_virt'
make[2]: *** [drivers/net/lance.o] Error 1
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

I would like to propose the following patch. The prototypes for the functions:
'isa_virt_to_bus' & 'isa_virt_to_bus' are existing for some archs like the
mips, x86, parisc, arm & alpha, but, is missing for powerpc. Is it safe to
introduce the following soultion for powerpc ? It fixes the build problem
i reported earlier.

Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>
---

--- linux-2.6.30-rc8/arch/powerpc/include/asm/io.h.orig	2009-06-10 21:56:49.000000000 -0500
+++ linux-2.6.30-rc8/arch/powerpc/include/asm/io.h	2009-06-10 22:21:35.000000000 -0500
@@ -680,6 +680,9 @@ extern void __iounmap_at(void *ea, unsig
 #define mmio_outsw(addr, src, count)	writesw(addr, src, count)
 #define mmio_outsl(addr, src, count)	writesl(addr, src, count)
 
+#define isa_virt_to_bus		virt_to_phys
+#define isa_bus_to_virt		phys_to_virt
+
 /**
  *	virt_to_phys	-	map virtual addresses to physical
  *	@address: address to remap

---
Regards--
Subrata

