Return-Path: <linux-kernel-owner+w=401wt.eu-S964954AbXBYPhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964954AbXBYPhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 10:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964955AbXBYPhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 10:37:41 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4542 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964954AbXBYPhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 10:37:40 -0500
Date: Sun, 25 Feb 2007 15:37:27 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>, Tim Hockin <thockin@hockin.org>,
       Jeff Garzik <jgarzik@pobox.com>
Cc: Adrian Bunk <bunk@stusta.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: natsemi: Fix detection of vanilla natsemi cards
Message-ID: <20070225153726.GB15068@sirena.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Tim Hockin <thockin@hockin.org>, Jeff Garzik <jgarzik@pobox.com>,
	Adrian Bunk <bunk@stusta.de>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Sauron is alive in Argentina!
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Tracy <rct@gherkin.frus.com> reported that the addition of support
for Aculab E1/T1 cPCI carrier cards broke detection of vanilla natsemi
cards.  This patch fixes that: the problem is that the driver-specific
ta in the PCI device table is an index into a second table and this
had not been updated for the vanilla cards.

This patch fixes the problem minimally.

Signed-Off-By: Mark Brown <broonie@sirena.org.uk>

--- linux.orig/drivers/net/natsemi.c	2007-02-23 11:13:03.000000000 +0000
+++ linux/drivers/net/natsemi.c	2007-02-23 11:12:00.000000000 +0000
@@ -260,7 +260,7 @@
 
 static const struct pci_device_id natsemi_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_NS, 0x0020, 0x12d9,     0x000c,     0, 0, 0 },
-	{ PCI_VENDOR_ID_NS, 0x0020, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VENDOR_ID_NS, 0x0020, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1 },
 	{ }	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, natsemi_pci_tbl);

-- 
"You grabbed my hand and we fell into it, like a daydream - or a fever."
