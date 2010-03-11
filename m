Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368Ab0CKRNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:13:48 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:49883 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933340Ab0CKRNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:13:46 -0500
Message-ID: <4B992408.7040608@oracle.com>
Date: Thu, 11 Mar 2010 09:10:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH -next] mtd/nand/r852: fix build for CONFIG_PCI disabled
References: <20100301210210.c6f465e6.sfr@canb.auug.org.au>	 <4B8C378B.2090400@oracle.com> <1267531329.10734.1.camel@maxim-laptop> <4B991A6F.1080006@oracle.com> <4B991B9B.8070809@oracle.com>
In-Reply-To: <4B991B9B.8070809@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B9924AA.0020:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Sorry, it's there, but there are still build errors.
> I will look at those...
> 


From: Randy Dunlap <randy.dunlap@oracle.com>

r852 fails to build when CONFIG_PCI is not enabled since it uses
pci_*() calls and is a PCI driver, so it should depend on PCI
to prevent build errors.
It should also #include <linux/pci.h>.

drivers/mtd/nand/r852.c:1053: error: implicit declaration of function 'pci_prepare_to_sleep'
drivers/mtd/nand/r852.c:1062: error: implicit declaration of function 'pci_back_from_sleep'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	David Woodhouse <dwmw2@infradead.org>
Cc:	Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/nand/Kconfig |    1 +
 drivers/mtd/nand/r852.c  |    1 +
 2 files changed, 2 insertions(+)

--- linux-next-20100311.orig/drivers/mtd/nand/Kconfig
+++ linux-next-20100311/drivers/mtd/nand/Kconfig
@@ -105,6 +105,7 @@ config MTD_NAND_IDS
 config MTD_NAND_RICOH
 	tristate "Ricoh xD card reader"
 	default n
+	depends on PCI
 	select MTD_SM_COMMON
 	help
 	  Enable support for Ricoh R5C852 xD card reader
--- linux-next-20100311.orig/drivers/mtd/nand/r852.c
+++ linux-next-20100311/drivers/mtd/nand/r852.c
@@ -12,6 +12,7 @@
 #include <linux/jiffies.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
+#include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/delay.h>
 #include <asm/byteorder.h>
