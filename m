Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZLRThy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZLRThy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZLRTh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:37:28 -0500
Received: from kroah.org ([198.145.64.141]:47466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbZLRTgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:36:36 -0500
Subject: patch staging-slicoss-use-pci_device_table.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Fri, 18 Dec 2009 11:33:54 -0800
In-Reply-To: <20091218075904.GA4524@coldcone>
Message-ID: <12611648343477@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: slicoss Use PCI_DEVICE_TABLE.

to my gregkh-2.6 tree.  Its filename is

    staging-slicoss-use-pci_device_table.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From kirjanov@gmail.com  Fri Dec 18 10:34:05 2009
From: "Denis Kirjanov <kirjanov@gmail.com" <kirjanov@gmail.com>
Date: Fri, 18 Dec 2009 10:59:04 +0300
Subject: staging: slicoss Use PCI_DEVICE_TABLE.
To: gregkh@suse.de, liodot@gmail.com, charrer@alacritech.com
Cc: devel@linuxdriverproject.org
Message-ID: <20091218075904.GA4524@coldcone>
Content-Disposition: inline


Use PCI_DEVICE_TABLE: defines array as const and puts
it into the __devinitconst section.

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/staging/slicoss/slicoss.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -194,14 +194,10 @@ MODULE_PARM_DESC(dynamic_intagg, "Dynami
 module_param(intagg_delay, int, 0);
 MODULE_PARM_DESC(intagg_delay, "uSec Interrupt Aggregation Delay");
 
-static struct pci_device_id slic_pci_tbl[] __devinitdata = {
-	{PCI_VENDOR_ID_ALACRITECH,
-	 SLIC_1GB_DEVICE_ID,
-	 PCI_ANY_ID, PCI_ANY_ID,},
-	{PCI_VENDOR_ID_ALACRITECH,
-	 SLIC_2GB_DEVICE_ID,
-	 PCI_ANY_ID, PCI_ANY_ID,},
-	{0,}
+static DEFINE_PCI_DEVICE_TABLE(slic_pci_tbl) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_ALACRITECH, SLIC_1GB_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ALACRITECH, SLIC_2GB_DEVICE_ID) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, slic_pci_tbl);

