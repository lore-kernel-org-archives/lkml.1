Return-Path: <linux-kernel-owner+w=401wt.eu-S1763312AbZJOXRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763312AbZJOXRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763303AbZJOXRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:17:23 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:43514 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758113AbZJOXRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:17:23 -0400
Date: Thu, 15 Oct 2009 17:16:45 -0600
From: dougthompson@xmission.com
To: kmannth@us.ibm.com, iws@ovro.caltech.edu, jroberson@jroberson.net,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 1/2] edac: i5400 fix missing CONFIG_PCI define
Message-ID: <4ad7ad5d.bbMDMCOY1LPNMc5Q%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ira W. Snyder <iws@ovro.caltech.edu>

When building without CONFIG_PCI the edac_pci_idx variable is unused,
causing a build-time warning. Wrap the variable in #ifdef CONFIG_PCI, just
like the rest of the PCI support.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
drivers/edac/mpc85xx_edac.c |    2 ++
1 files changed, 2 insertions(+), 0 deletions(-)

Index: linux-2.6.31/drivers/edac/mpc85xx_edac.c
===================================================================
--- linux-2.6.31.orig/drivers/edac/mpc85xx_edac.c
+++ linux-2.6.31/drivers/edac/mpc85xx_edac.c
@@ -26,7 +26,9 @@
 #include "mpc85xx_edac.h"
 
 static int edac_dev_idx;
+#ifdef CONFIG_PCI
 static int edac_pci_idx;
+#endif
 static int edac_mc_idx;
 
 static u32 orig_ddr_err_disable;
