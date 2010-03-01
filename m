Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0CAV4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:56:20 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:55711 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab0CAV4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:56:19 -0500
Message-ID: <4B8C378B.2090400@oracle.com>
Date: Mon, 01 Mar 2010 13:54:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH -next] mtd/nand/r852: fix build for CONFIG_PM=n
References: <20100301210210.c6f465e6.sfr@canb.auug.org.au>
In-Reply-To: <20100301210210.c6f465e6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B8C37E2.0076:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix r852 build for the case of CONFIG_PM=n.

drivers/mtd/nand/r852.c:1039: error: implicit declaration of function 'pci_prepare_to_sleep'
drivers/mtd/nand/r852.c:1048: error: implicit declaration of function 'pci_back_from_sleep'

This patch leaves r852_pm_ops untouched.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/nand/r852.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-next-20100301.orig/drivers/mtd/nand/r852.c
+++ linux-next-20100301/drivers/mtd/nand/r852.c
@@ -1007,6 +1007,7 @@ void r852_shutdown(struct pci_dev *pci_d
 	pci_disable_device(pci_dev);
 }
 
+#ifdef CONFIG_PM
 int r852_suspend(struct device *device)
 {
 	struct r852_device *dev = pci_get_drvdata(to_pci_dev(device));
@@ -1081,6 +1082,10 @@ int r852_resume(struct device *device)
 	r852_update_card_detect(dev);
 	return 0;
 }
+#else
+#define r852_suspend	NULL
+#define r852_resume	NULL
+#endif
 
 static const struct pci_device_id r852_pci_id_tbl[] = {
 

-- 
~Randy
