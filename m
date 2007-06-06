Return-Path: <linux-kernel-owner+w=401wt.eu-S935206AbXFFUQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935206AbXFFUQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934991AbXFFUQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:16:31 -0400
Received: from nethservice.nethesis.it ([82.104.129.21]:36679 "HELO
	nethesis.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934975AbXFFUQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:16:30 -0400
Message-ID: <4667160E.5000608@mobilia.it>
Date: Wed, 06 Jun 2007 22:16:14 +0200
From: Filippo Carletti <carletti@mobilia.it>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.4.34 - Add some ahci pci ids
References: <465FE51E.2060705@mobilia.it> <466005C6.4050303@garzik.org> <20070606054304.GA4241@1wt.eu>
In-Reply-To: <20070606054304.GA4241@1wt.eu>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------090304040305050907080209"
X-Virus-Checked: Checked by ClamAV on nethesis.it
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090304040305050907080209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>>> The original patch contained also this lines (that I omitted):
>>> +       /* JMicron-specific fixup: make sure we're in AHCI mode */
>>> +       if (pdev->vendor == 0x197b)
>>> +               pci_write_config_byte(pdev, 0x41, 0xa1);
>> NAK.  Don't omit obviously needed lines, if you are going to add JMicron 
>> PCI IDs.
> 
> Filippo,
> 
> would you please resend your patch including the lines you have omitted ?
> Jeff is right, those lines are explicitly labelled as a fixup, so either
> we merge the complete patch, or nothing at all.

I'm attaching a revised patch that includes JMicron fixup I missed earlier.

The patch applies but it's not tested because I lack appropriate hw.

Ciao,
Filippo

--------------090304040305050907080209
Content-Type: text/x-patch;
 name="linux-2.4.34_ahci.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.4.34_ahci.patch"

--- drivers/scsi/ahci.c.orig	2006-12-23 20:34:20.000000000 +0000
+++ drivers/scsi/ahci.c	2007-05-11 22:11:52.000000000 +0000
@@ -275,6 +275,24 @@
 	  board_ahci }, /* ESB2 */
 	{ PCI_VENDOR_ID_INTEL, 0x27c6, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	  board_ahci }, /* ICH7-M DH */
+	{ PCI_VENDOR_ID_INTEL, 0x2821, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ICH8 */
+	{ PCI_VENDOR_ID_INTEL, 0x2822, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ICH8 */
+	{ PCI_VENDOR_ID_INTEL, 0x2824, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ICH8 */
+	{ PCI_VENDOR_ID_INTEL, 0x2829, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ICH8M */
+	{ PCI_VENDOR_ID_INTEL, 0x282a, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ICH8M */
+	{ 0x197b, 0x2360, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* JMicron JMB360 */
+	{ 0x197b, 0x2363, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* JMicron JMB363 */
+	{ PCI_VENDOR_ID_ATI, 0x4380, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ATI SB600 non-raid */
+	{ PCI_VENDOR_ID_ATI, 0x4381, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ATI SB600 raid */
 	{ }	/* terminate list */
 };

@@ -1085,6 +1085,10 @@
 	if (have_msi)
 		hpriv->flags |= AHCI_FLAG_MSI;
 
+	/* JMicron-specific fixup: make sure we're in AHCI mode */
+	if (pdev->vendor == 0x197b)
+		pci_write_config_byte(pdev, 0x41, 0xa1);
+
 	/* initialize adapter */
 	rc = ahci_host_init(probe_ent);
 	if (rc)

--------------090304040305050907080209--
