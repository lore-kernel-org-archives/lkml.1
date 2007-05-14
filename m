Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbXENV2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbXENV2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbXENV2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:28:04 -0400
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:47212 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252AbXENV2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:28:03 -0400
From: Frank Seidel <frank@kernalert.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/skfp/drvfbi.c: trivial cleanup
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Cc: linux@syskonnect.de
Date: Mon, 14 May 2007 23:27:52 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705142327.52458.frank@kernalert.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (for 2.6.21-mm2) contains a trivial cleanup:
- removes unused exist_board() variation
- removed part is depecrated and doesn't compile anymore

Signed-off-by: Frank Seidel <frank@kernalert.de>

---
 drivers/net/skfp/drvfbi.c |   40 ----------------------------------------
 1 file changed, 40 deletions(-)

Index: b/drivers/net/skfp/drvfbi.c
===================================================================
--- a/drivers/net/skfp/drvfbi.c
+++ b/drivers/net/skfp/drvfbi.c
@@ -1224,46 +1224,6 @@ int get_board_para(struct s_smc *smc, in
 }
 #endif	/* ISA */
 
-#ifdef PCI
-#ifdef USE_BIOS_FUN
-int exist_board(struct s_smc *smc, int slot)
-{
-	u_short dev_id ;
-	u_short ven_id ;
-	int found ; 
-	int i ;
-
-	found = FALSE ;		/* make sure we returned with adatper not found*/
-				/* if an empty oemids.h was included */
-
-#ifdef MULT_OEM
-        smc->hw.oem_id = (struct s_oem_ids *) &oem_ids[0] ;
-	for (; smc->hw.oem_id->oi_status != OI_STAT_LAST; smc->hw.oem_id++) {
-		if (smc->hw.oem_id->oi_status < smc->hw.oem_min_status)
-			continue ;
-#endif
-		ven_id = OEMID(smc,0) + (OEMID(smc,1) << 8) ; 
-		dev_id = OEMID(smc,2) + (OEMID(smc,3) << 8) ; 
-		for (i = 0; i < slot; i++) {
-			if (pci_find_device(i,&smc->hw.pci_handle,
-				dev_id,ven_id) != 0) {
-
-				found = FALSE ;
-			} else {
-				found = TRUE ;
-			}
-		}
-		if (found) {
-			return(1) ;	/* adapter was found */
-		}
-#ifdef MULT_OEM
-	}
-#endif
-	return(0) ;	/* adapter was not found */
-}
-#endif	/* PCI */
-#endif	/* USE_BIOS_FUNC */
-
 void driver_get_bia(struct s_smc *smc, struct fddi_addr *bia_addr)
 {
 	int i ;
