Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbXHUG5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbXHUG5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761303AbXHUGyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:54:39 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44279 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761280AbXHUGyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:54:38 -0400
Date: Mon, 20 Aug 2007 23:55:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Garzik <jeff@garzik.org>, su henry <henry.su.ati@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 13/20] libata: add ATI SB700 device IDs to AHCI driver
Message-ID: <20070821065532.GN5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-add-ati-sb700-device-ids-to-ahci-driver.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: su henry <henry.su.ati@gmail.com>

The SATA controller device ID is different according to
the onchip SATA type set in the system BIOS:
Device                              Device ID
SATA in IDE mode             0x4390
SATA in AHCI mode           0x4391
SATA in non-raid5 driver     0x4392
SATA in raid5 driver           0x4393

Although the device ID is different, they use the same AHCI driver
.The attached file is the patch for adding these device
IDs for ATI SB700.

Signed-off-by: su henry <henry.su.ati@gmail.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -399,7 +399,10 @@ static const struct pci_device_id ahci_p
 
 	/* ATI */
 	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */
-	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700 */
+	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700 IDE */
+	{ PCI_VDEVICE(ATI, 0x4391), board_ahci_sb600 }, /* ATI SB700 AHCI */
+	{ PCI_VDEVICE(ATI, 0x4392), board_ahci_sb600 }, /* ATI SB700 nraid5 */
+	{ PCI_VDEVICE(ATI, 0x4393), board_ahci_sb600 }, /* ATI SB700 raid5 */
 
 	/* VIA */
 	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */

-- 
