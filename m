Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZBPQqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZBPQqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZBPQqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:46:34 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:40621 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZBPQqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:46:33 -0500
Message-ID: <49999858.6000604@oracle.com>
Date: Mon, 16 Feb 2009 08:46:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] staging/phison: fix kconfig for clean build
References: <20090216172016.f1d159a7.sfr@canb.auug.org.au>
In-Reply-To: <20090216172016.f1d159a7.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4999982E.0070:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

phison is an ATA driver, not a classic IDE driver, so fix the Kconfig file
so that it will build.

drivers/staging/phison/phison.c:43: error: implicit declaration of function 'ATA_BMDMA_SHT'
drivers/staging/phison/phison.c:43: error: initializer element is not constant
drivers/staging/phison/phison.c:43: error: (near initialization for 'phison_sht.module')
drivers/staging/phison/phison.c:47: error: 'ata_bmdma_port_ops' undeclared here (not in a function)
drivers/staging/phison/phison.c:65: error: implicit declaration of function 'ata_pci_sff_init_one'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/phison/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090216.orig/drivers/staging/phison/Kconfig
+++ linux-next-20090216/drivers/staging/phison/Kconfig
@@ -1,5 +1,5 @@
 config IDE_PHISON
 	tristate "PCIE ATA PS5000 IDE support"
-	depends on IDE
+	depends on ATA && ATA_SFF
 	---help---
 	  This is an experimental driver for PS5000 IDE driver.
