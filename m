Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbYHSNsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbYHSNsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbYHSNr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:47:26 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56964 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960AbYHSNrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:47:24 -0400
Date: Tue, 19 Aug 2008 16:47:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: cooloney@kernel.org, jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] blackfin: let PCI depend on BROKEN
Message-ID: <20080819134714.GG8852@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AFAIR there exists blackfin hardware with PCI support, but the support 
currently in the kernel fails to build starting with:

<--  snip  -->

...
  CC      drivers/pci/probe.o
probe.c: In function 'pci_scan_slot':
probe.c:1056: error: implicit declaration of function 'pcibios_scan_all_fns'
make[3]: *** [drivers/pci/probe.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b5be58af247c67af4f1e40e2883f87be7a1e8383 
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index f64d259..4154ff1 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -855,6 +855,7 @@ menu "Bus options (PCI, PCMCIA, EISA, MCA, ISA)"
 
 config PCI
 	bool "PCI support"
+	depends on BROKEN
 	help
 	  Support for PCI bus.
 

