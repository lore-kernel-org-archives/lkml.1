Return-Path: <linux-kernel-owner+w=401wt.eu-S1760682AbXELUMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682AbXELUMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 16:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbXELUM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 16:12:29 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:45862 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbXELUM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 16:12:28 -0400
Date: Sat, 12 May 2007 22:12:37 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Workaround for a PCI restoring bug
Message-ID: <20070512201237.GB3569@ics.muni.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 12 May 2007 22:12:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello,

as of 2.6.21-git16, the bugs related to restoring PCI are still present. The
save pci function reads only -1 from the PCI config space and when restoring,
it messes up totaly most PCI devices. The attached patch is workaround only
until proper fix is found and included. Could it be included into the mainline
for now?

-- 
Luká¹ Hejtmánek

--qlTNgmc+xy1dBmNv
Content-Type: text/x-diff; charset=iso-8859-2
Content-Disposition: attachment; filename="pci.patch"

--- drivers/pci/pci.c.orig	2006-07-15 23:53:08.000000000 +0200
+++ drivers/pci/pci.c	2006-07-21 00:51:07.000000000 +0200
@@ -477,7 +477,7 @@
 	 */
 	for (i = 15; i >= 0; i--) {
 		pci_read_config_dword(dev, i * 4, &val);
-		if (val != dev->saved_config_space[i]) {
+		if (val != dev->saved_config_space[i] && dev->saved_config_space[i] != 0xffffffff) {
 			printk(KERN_DEBUG "PM: Writing back config space on "
 				"device %s at offset %x (was %x, writing %x)\n",
 				pci_name(dev), i,

--qlTNgmc+xy1dBmNv--
