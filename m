Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbXEOG5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbXEOG5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 02:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXEOG5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 02:57:47 -0400
Received: from host2.marvell.com ([65.219.4.2]:43159 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753729AbXEOG5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 02:57:46 -0400
X-Greylist: delayed 1390 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 02:57:46 EDT
Content-class: urn:content-classes:message
Subject: AW: [PATCH] drivers/net/skfp/drvfbi.c: trivial cleanup
Date: Tue, 15 May 2007 08:34:33 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <4D634BCFD1A2144ABECC75FF512D7A90DA8D2A@SKGExch01.marvell.com>
In-Reply-To: <200705142327.52458.frank@kernalert.de>
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/skfp/drvfbi.c: trivial cleanup
Thread-Index: AceWbseXp1prJ5hHQv6xQH2FTftqhwATDxcQ
From: "Abdelkarim Jamal" <ajamal@marvell.com>
To: "Frank Seidel" <frank@kernalert.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Cc: <linux@syskonnect.de>
X-OriginalArrivalTime: 15 May 2007 06:34:35.0654 (UTC) FILETIME=[1AD49A60:01C796BB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vielen Dank Herr Seidel fuer Ihr Feedback.

Mit freundlichen Gruessen
Jamal

Marvell® Semiconductor Germany GmbH 
------------------------------------- 
Dipl. -Ing. Karim Jamal 
Technical Support Engineer 
-------------------------------------- 
Phone: +49 (0) 7243502-330 
Fax: +49 (0) 7243502-364 
Mail: support@syskonnect.de 
Web: http:\\www.syskonnect.de 
Marvell Semiconductor Germany GmbH, Siemensstr. 23, 76275 Ettlingen, Amtsgericht Karlsruhe HRB 1620 E Geschäftsführer: Dipl.-Volksw. Mathias Horak, Thomas Ruf



-----Ursprüngliche Nachricht-----
Von: Frank Seidel [mailto:frank@kernalert.de] 
Gesendet: Montag, 14. Mai 2007 23:28
An: Linux Kernel
Cc: linux@syskonnect.de
Betreff: [PATCH] drivers/net/skfp/drvfbi.c: trivial cleanup


This patch (for 2.6.21-mm2) contains a trivial cleanup:
- removes unused exist_board() variation
- removed part is depecrated and doesn't compile anymore

Signed-off-by: Frank Seidel <frank@kernalert.de>

---
 drivers/net/skfp/drvfbi.c |   40 ----------------------------------------
 1 file changed, 40 deletions(-)

Index: b/drivers/net/skfp/drvfbi.c ===================================================================
--- a/drivers/net/skfp/drvfbi.c
+++ b/drivers/net/skfp/drvfbi.c
@@ -1224,46 +1224,6 @@ int get_board_para(struct s_smc *smc, in  }
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
 void driver_get_bia(struct s_smc *smc, struct fddi_addr *bia_addr)  {
 	int i ;

