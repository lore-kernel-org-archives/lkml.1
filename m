Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645Ab0AMPPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab0AMPPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497Ab0AMPPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:15:33 -0500
Received: from khc.piap.pl ([195.187.100.11]:38615 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab0AMPPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:15:31 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Seth Heasley <seth.heasley@intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel Cougar Point DeviceIDs
References: <201001121700.18234.seth.heasley@intel.com>
	<4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>
Date: Wed, 13 Jan 2010 16:15:29 +0100
In-Reply-To: <4B4DAA68.60608@pobox.com> (Jeff Garzik's message of "Wed, 13 Jan
	2010 06:11:36 -0500")
Message-ID: <m3my0i6nou.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jgarzik@pobox.com> writes:

> Well, two lines of thinking here:
>
> * some of lines of Intel chips do not separate AHCI into a separate
> PCI ID rather legacy IDE interface.  When an AHCI interface exists and
> AHCI/IDE share the same PCI ID, we default to using AHCI.  Thus, some
> of those PCI ID matches in ahci.c's PCI table may not get caught by
> the generic PCI class match at the end of the table.
>
> * the cost carrying redundant PCI IDs seems low, harmless, and
> potentially helpful.

Also people may use things like this:

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a3241a1..0616bbb 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -561,9 +561,11 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b2f), board_ahci }, /* PCH AHCI */
 
+#ifdef DOESNT_WORK_FOR_ME
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },
+#endif
 
 	/* ATI */
 	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */
@@ -667,9 +669,11 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
 
+#ifdef DOESNT_WORK_FOR_ME
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
+#endif
 
 	{ }	/* terminate list */
 };

-- 
Krzysztof Halasa
