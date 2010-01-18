Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127Ab0ARVpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0ARVpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449Ab0ARVph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:45:37 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:16298 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873Ab0ARVpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:45:36 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgQGAPNkVEtbssBB/2dsb2JhbACceLgLCoQpBA
Date: Mon, 18 Jan 2010 22:45:34 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Seth Heasley <seth.heasley@intel.com>
Subject: [WATCHDOG] linux-2.6.33-rc4 patches
Message-ID: <20100118214534.GM3122@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/iTCO_wdt.c |   45 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

with these Changes:

Author: Seth Heasley <seth.heasley@intel.com>
Date:   Thu Jan 14 20:58:05 2010 +0000

    [WATCHDOG] iTCO_wdt: Add Intel Cougar Point and PCH DeviceIDs
    
    This patch adds the Intel Cougar Point and PCH DeviceIDs for iTCO Watchdog.
    
    Signed-off-by: Seth Heasley <seth.heasley@intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index c8a3bec..4bdb7f1 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -29,8 +29,9 @@
  *	document number 313056-003, 313057-017: 82801H (ICH8)
  *	document number 316972-004, 316973-012: 82801I (ICH9)
  *	document number 319973-002, 319974-002: 82801J (ICH10)
- *	document number 322169-001, 322170-001: 5 Series, 3400 Series (PCH)
+ *	document number 322169-001, 322170-003: 5 Series, 3400 Series (PCH)
  *	document number 320066-003, 320257-008: EP80597 (IICH)
+ *	document number TBD                   : Cougar Point (CPT)
  */
 
 /*
@@ -100,8 +101,22 @@ enum iTCO_chipsets {
 	TCO_ICH10DO,	/* ICH10DO */
 	TCO_PCH,	/* PCH Desktop Full Featured */
 	TCO_PCHM,	/* PCH Mobile Full Featured */
+	TCO_P55,	/* P55 */
+	TCO_PM55,	/* PM55 */
+	TCO_H55,	/* H55 */
+	TCO_QM57,	/* QM57 */
+	TCO_H57,	/* H57 */
+	TCO_HM55,	/* HM55 */
+	TCO_Q57,	/* Q57 */
+	TCO_HM57,	/* HM57 */
 	TCO_PCHMSFF,	/* PCH Mobile SFF Full Featured */
+	TCO_QS57,	/* QS57 */
+	TCO_3400,	/* 3400 */
+	TCO_3420,	/* 3420 */
+	TCO_3450,	/* 3450 */
 	TCO_EP80579,	/* EP80579 */
+	TCO_CPTD,	/* CPT Desktop */
+	TCO_CPTM,	/* CPT Mobile */
 };
 
 static struct {
@@ -144,8 +159,22 @@ static struct {
 	{"ICH10DO", 2},
 	{"PCH Desktop Full Featured", 2},
 	{"PCH Mobile Full Featured", 2},
+	{"P55", 2},
+	{"PM55", 2},
+	{"H55", 2},
+	{"QM57", 2},
+	{"H57", 2},
+	{"HM55", 2},
+	{"Q57", 2},
+	{"HM57", 2},
 	{"PCH Mobile SFF Full Featured", 2},
+	{"QS57", 2},
+	{"3400", 2},
+	{"3420", 2},
+	{"3450", 2},
 	{"EP80579", 2},
+	{"CPT Desktop", 2},
+	{"CPT Mobile", 2},
 	{NULL, 0}
 };
 
@@ -216,8 +245,22 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(0x3a14,				TCO_ICH10DO)},
 	{ ITCO_PCI_DEVICE(0x3b00,				TCO_PCH)},
 	{ ITCO_PCI_DEVICE(0x3b01,				TCO_PCHM)},
+	{ ITCO_PCI_DEVICE(0x3b02,				TCO_P55)},
+	{ ITCO_PCI_DEVICE(0x3b03,				TCO_PM55)},
+	{ ITCO_PCI_DEVICE(0x3b06,				TCO_H55)},
+	{ ITCO_PCI_DEVICE(0x3b07,				TCO_QM57)},
+	{ ITCO_PCI_DEVICE(0x3b08,				TCO_H57)},
+	{ ITCO_PCI_DEVICE(0x3b09,				TCO_HM55)},
+	{ ITCO_PCI_DEVICE(0x3b0a,				TCO_Q57)},
+	{ ITCO_PCI_DEVICE(0x3b0b,				TCO_HM57)},
 	{ ITCO_PCI_DEVICE(0x3b0d,				TCO_PCHMSFF)},
+	{ ITCO_PCI_DEVICE(0x3b0f,				TCO_QS57)},
+	{ ITCO_PCI_DEVICE(0x3b12,				TCO_3400)},
+	{ ITCO_PCI_DEVICE(0x3b14,				TCO_3420)},
+	{ ITCO_PCI_DEVICE(0x3b16,				TCO_3450)},
 	{ ITCO_PCI_DEVICE(0x5031,				TCO_EP80579)},
+	{ ITCO_PCI_DEVICE(0x1c42,				TCO_CPTD)},
+	{ ITCO_PCI_DEVICE(0x1c43,				TCO_CPTM)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
