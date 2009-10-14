Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbZJNWBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbZJNWBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761499AbZJNWBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:01:40 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:31752 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761494AbZJNWBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:01:39 -0400
Date: Wed, 14 Oct 2009 14:59:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>
Subject: [PATCH -mmotm] spi: fix dw_spi_pci build when CONFIG_PM=n
Message-Id: <20091014145911.877130a7.randy.dunlap@oracle.com>
In-Reply-To: <200910140436.n9E4aF9G001644@imap1.linux-foundation.org>
References: <200910140436.n9E4aF9G001644@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4AD64A13.0089:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix names of the suspend and resume macros so that build succeeds
when CONFIG_PM=n:

drivers/spi/dw_spi_pci.c:150: error: 'spi_suspend' undeclared here (not in a function)
drivers/spi/dw_spi_pci.c:151: error: 'spi_resume' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Feng Tang <feng.tang@intel.com>
---
 drivers/spi/dw_spi_pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2009-1013-2113.orig/drivers/spi/dw_spi_pci.c
+++ mmotm-2009-1013-2113/drivers/spi/dw_spi_pci.c
@@ -132,8 +132,8 @@ static int spi_resume(struct pci_dev *pd
 	return dw_spi_resume_host(&dwpci->dws);
 }
 #else
-#define mrst_spi_suspend	NULL
-#define mrst_spi_resume		NULL
+#define spi_suspend	NULL
+#define spi_resume	NULL
 #endif
 
 static const struct pci_device_id pci_ids[] __devinitdata = {
