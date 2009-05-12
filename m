Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbZELKH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbZELKH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZELKHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:07:38 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:49470 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760664AbZELKHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:07:36 -0400
Date: Tue, 12 May 2009 12:05:23 +0200
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Message-ID: <20090512100523.GA31131@mea.homelinux.org>
MIME-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Mats Erik Andersson <mats.andersson@gisladisker.se>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 20 bytes)
X-SA-Exim-Mail-From: mats.andersson@gisladisker.se
Subject: [PATCH 1/1] pci: expose SMBus on Asus notebook A6L
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on aun.utmark.mea)
X-Originating-IP: 83.253.242.141
X-Scan-Result: No virus found in message 1M3otY-0001bu-7H.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1M3otY-0001bu-7H 61d4a0599a58ff1cb6bcc7e44a22db0a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mats Erik Andersson <mats.andersson@gisladisker.se>

Addition of one unknown subsystem identifier to the
quirks handler for chipset i82855GM_HB on notebook
Asus A6L. This exposes the otherwise hidden SMBus
controller within the south bridge ICH4-M.

Signed-off-by: Mats Erik Andersson <mats.andersson@gisladisker.se>
---

Tried and successfully used on kernel 2.6.29 and 2.6.23.17.

--- drivers/pci/quirks.c.orig	2009-05-09 00:47:21.000000000 +0200
+++ drivers/pci/quirks.c	2009-05-12 11:20:04.000000000 +0200
@@ -1068,8 +1068,9 @@ static void __init asus_hides_smbus_host
 		else if (dev->device == PCI_DEVICE_ID_INTEL_82855GM_HB)
 			switch (dev->subsystem_device) {
 			case 0x1751: /* M2N notebook */
 			case 0x1821: /* M5N notebook */
+			case 0x1897: /* A6L notebook */
 				asus_hides_smbus = 1;
 			}
 		else if (dev->device == PCI_DEVICE_ID_INTEL_82855PM_HB)
 			switch (dev->subsystem_device) {
