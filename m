Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbYIVNN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbYIVNN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYIVNNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:13:49 -0400
Received: from ns0.wincor-nixdorf.com ([80.154.98.130]:59784 "EHLO
	mxpdbe2.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbYIVNNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:13:48 -0400
Message-ID: <48D79977.30403@wincor-nixdorf.com>
Date: Mon, 22 Sep 2008 15:11:19 +0200
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-serial@vger.kernel.org
CC: Russell King <rmk@arm.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] serial: set correct baud_base for Oxford Semiconductor
 Ltd EXSYS EX-41092 Dual 16950 Serial adapter
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Sep 2008 13:12:56.0567 (UTC) FILETIME=[EDC68070:01C91CB4]
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI-card identified as "Oxford Semiconductor Ltd EXSYS EX-41092 Dual
16950 Serial adapter" is only usable with other devices (i.e. not the same
card) after doing a "setserial /dev/ttyS<n> baud_base 115200".  This
baud_base should be default for this card.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
---
 drivers/serial/8250_pci.c |    3 +++
 include/linux/pci_ids.h   |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index c2f2393..3539c3c 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -2291,6 +2291,9 @@ static struct pci_device_id serial_pci_tbl[] = {
 		 * For now just used the hex ID 0x950a.
 		 */
 	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
+		PCI_SUBVENDOR_ID_SIIG, PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL, 0, 0,
+		pbn_b0_2_115200 },
+	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_2_1130000 },
 	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI954,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f1624b3..9e46ab3 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1751,6 +1751,7 @@
 #define PCI_DEVICE_ID_SIIG_8S_20x_650	0x2081
 #define PCI_DEVICE_ID_SIIG_8S_20x_850	0x2082
 #define PCI_SUBDEVICE_ID_SIIG_QUARTET_SERIAL	0x2050
+#define PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL	0x2530
 
 #define PCI_VENDOR_ID_RADISYS		0x1331
 




-- 
WINCOR NIXDORF International GmbH 
Sitz der Gesellschaft: Paderborn 
Registergericht Paderborn HRB 3507
Geschäftsführer: Eckard Heidloff (Vorsitzender), Stefan Auerbach, Dr. Jürgen Wunram
Vorsitzender des Aufsichtsrats: Karl-Heinz Stiller 
Steuernummer: 339/5884/0020 - Ust-ID Nr.: DE812927716 - WEEE-Reg.-Nr. DE44477193

Diese E-Mail enthält vertrauliche Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und vernichten Sie diese E-Mail. Das unerlaubte Kopieren sowie die unbefugte Weitergabe dieser E-Mail ist nicht gestattet.

This e-mail may contain confidential information. If you are not the intended recipient (or have received this e-mail in error) please notify the sender immediately and destroy this e-mail. Any unauthorised copying, disclosure or distribution of the material in this e-mail is strictly forbidden. 

