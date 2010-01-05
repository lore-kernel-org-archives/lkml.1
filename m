Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149Ab0AEQl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab0AEQl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142Ab0AEQl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:41:56 -0500
Received: from [206.15.93.42] ([206.15.93.42]:6958 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754570Ab0AEQkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:40:36 -0500
X-Greylist: delayed 1092 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 11:40:34 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/atm/lanai.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:26:49 -0700
Cc: netdev@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050926.50117.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index cf97c34..7fe7c32 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -998,9 +998,7 @@ static int __devinit eeprom_validate(struct lanai_dev *lanai)
 			    (unsigned int) e[EEPROM_MAC_REV + i]);
 			return -EIO;
 		}
-	DPRINTK("eeprom: MAC address = %02X:%02X:%02X:%02X:%02X:%02X\n",
-		e[EEPROM_MAC + 0], e[EEPROM_MAC + 1], e[EEPROM_MAC + 2],
-		e[EEPROM_MAC + 3], e[EEPROM_MAC + 4], e[EEPROM_MAC + 5]);
+	DPRINTK("eeprom: MAC address = %pM\n", &e[EEPROM_MAC]);
 	/* Verify serial number */
 	lanai->serialno = eeprom_be4(lanai, EEPROM_SERIAL);
 	v = eeprom_be4(lanai, EEPROM_SERIAL_REV);
@@ -2483,14 +2481,8 @@ static int lanai_proc_read(struct atm_dev *atmdev, loff_t *pos, char *page)
 		return sprintf(page, "revision: board=%d, pci_if=%d\n",
 		    lanai->board_rev, (int) lanai->pci->revision);
 	if (left-- == 0)
-		return sprintf(page, "EEPROM ESI: "
-		    "%02X:%02X:%02X:%02X:%02X:%02X\n",
-		    lanai->eeprom[EEPROM_MAC + 0],
-		    lanai->eeprom[EEPROM_MAC + 1],
-		    lanai->eeprom[EEPROM_MAC + 2],
-		    lanai->eeprom[EEPROM_MAC + 3],
-		    lanai->eeprom[EEPROM_MAC + 4],
-		    lanai->eeprom[EEPROM_MAC + 5]);
+		return sprintf(page, "EEPROM ESI: %pM\n",
+		    &lanai->eeprom[EEPROM_MAC]);
 	if (left-- == 0)
 		return sprintf(page, "status: SOOL=%d, LOCD=%d, LED=%d, "
 		    "GPIN=%d\n", (lanai->status & STATUS_SOOL) ? 1 : 0,
