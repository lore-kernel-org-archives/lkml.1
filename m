Return-Path: <linux-kernel-owner+w=401wt.eu-S1762019AbXIKAMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762019AbXIKAMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 20:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756688AbXIKAML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 20:12:11 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:50495 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756656AbXIKAMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 20:12:10 -0400
Date: Tue, 11 Sep 2007 02:13:31 +0200
From: aherrman@arcor.de
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Stephan Wolf <WolfSt.External@qimonda.com>,
       Antonino Daplas <adaplas@gmail.com>
Subject: [PATCH] radeonfb: bug fix for 2.6.23-rc5
Message-ID: <20070911001331.GD5155@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b5f2f4d1a6d7efde39cfb5e1d034981c69f2214c adds PCI ID 0x5975
to radeonfb. But the chip family is wrong. Instead of R300 it should
be RS480.

With 2.6.23-rc5 and radeonfb enabled my Laptop hangs and console
blanks. My ATI Radeon is the following model:

  ATI Technologies Inc RS482 [Radeon Xpress 200M] [1002:5975]

Attached patch fixes the problem - no system hang and radeonfb is usable.
(I have to use force_measure_pll to get the best resolution though.)

I guess this fix should go into 2.6.23 or alternatively the mentioned
commit should be reverted.


Regards,

Andreas

--
radeonfb: fix chip definition for Radeon Xpress 200M 0x5975

 - rename PCI_CHIP_RS485_5975 to PCI_CHIP_RS482_5975
 - correct chip family (RS480 instead of R300)
 - make sure that PCI IDs are in ascending order in ati_ids.h

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 drivers/video/aty/ati_ids.h     |   12 ++++++------
 drivers/video/aty/radeon_base.c |    3 +--
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/video/aty/ati_ids.h b/drivers/video/aty/ati_ids.h
index 685a754..dca2eb8 100644
--- a/drivers/video/aty/ati_ids.h
+++ b/drivers/video/aty/ati_ids.h
@@ -192,6 +192,12 @@
 #define PCI_CHIP_RS300_5835		0x5835
 #define PCI_CHIP_RS300_5836		0x5836
 #define PCI_CHIP_RS300_5837		0x5837
+#define PCI_CHIP_RS480_5955             0x5955
+#define PCI_CHIP_RV280_5960		0x5960
+#define PCI_CHIP_RV280_5961		0x5961
+#define PCI_CHIP_RV280_5962		0x5962
+#define PCI_CHIP_RV280_5964		0x5964
+#define PCI_CHIP_RS482_5975		0x5975
 #define PCI_CHIP_RV370_5B60             0x5B60
 #define PCI_CHIP_RV370_5B61             0x5B61
 #define PCI_CHIP_RV370_5B62             0x5B62
@@ -200,14 +206,8 @@
 #define PCI_CHIP_RV370_5B65             0x5B65
 #define PCI_CHIP_RV370_5B66             0x5B66
 #define PCI_CHIP_RV370_5B67             0x5B67
-#define PCI_CHIP_RV280_5960		0x5960
-#define PCI_CHIP_RV280_5961		0x5961
-#define PCI_CHIP_RV280_5962		0x5962
-#define PCI_CHIP_RV280_5964		0x5964
-#define PCI_CHIP_RS485_5975		0x5975
 #define PCI_CHIP_RV280_5C61		0x5C61
 #define PCI_CHIP_RV280_5C63		0x5C63
 #define PCI_CHIP_R423_5D57              0x5D57
 #define PCI_CHIP_RS350_7834             0x7834
 #define PCI_CHIP_RS350_7835             0x7835
-#define PCI_CHIP_RS480_5955             0x5955
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 47ca62f..e8e135f 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -102,6 +102,7 @@
 static struct pci_device_id radeonfb_pci_table[] = {
         /* Radeon Xpress 200m */
 	CHIP_DEF(PCI_CHIP_RS480_5955,   RS480,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
+	CHIP_DEF(PCI_CHIP_RS482_5975,	RS480,	CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
 	/* Mobility M6 */
 	CHIP_DEF(PCI_CHIP_RADEON_LY, 	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
 	CHIP_DEF(PCI_CHIP_RADEON_LZ,	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
@@ -153,8 +154,6 @@ static struct pci_device_id radeonfb_pci_table[] = {
 	/* Mobility 9200 (M9+) */
 	CHIP_DEF(PCI_CHIP_RV280_5C61,	RV280,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
 	CHIP_DEF(PCI_CHIP_RV280_5C63,	RV280,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
-	/*Mobility Xpress 200 */
-	CHIP_DEF(PCI_CHIP_RS485_5975,	R300,	CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
 	/* 9200 */
 	CHIP_DEF(PCI_CHIP_RV280_5960,	RV280,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV280_5961,	RV280,	CHIP_HAS_CRTC2),
-- 
1.5.3


