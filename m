Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZHFQ2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZHFQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZHFQ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:28:16 -0400
Received: from emulex.emulex.com ([138.239.112.1]:51540 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbZHFQ2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:28:15 -0400
From: Chetan.Loke@Emulex.Com
To: <tony@linx.net>
CC: <hancockrwd@gmail.com>, <jgarzik@pobox.com>, <linux-ide@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <philipl@overt.org>
Date: Thu, 6 Aug 2009 09:28:02 -0700
Subject: RE: [PATCH 2.6.32 v2] MCP55 SATA2 conditional MSI support for
 sata_nv
Thread-Topic: [PATCH 2.6.32 v2] MCP55 SATA2 conditional MSI support for
 sata_nv
Thread-Index: AcoWrvIBnurx2YazRAe6I2hKNhAWsgAAjpRQ
Message-ID: <412A05BA40734D4887DBC67661F433080D7322B1@EXMAIL.ad.emulex.com>
References: <20090805192055.8F2DE1007C@gold.linx.net>
	 <4A7A16C9.6030500@gmail.com>
	 <412A05BA40734D4887DBC67661F433080D73228B@EXMAIL.ad.emulex.com>
 <1249574363.4530.23.camel@localhost>
In-Reply-To: <1249574363.4530.23.camel@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 06 Aug 2009 16:28:05.0000 (UTC) FILETIME=[DFE81880:01CA16B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Tony Vroon [mailto:tony@linx.net]
> Sent: Thursday, August 06, 2009 11:59 AM
> To: Loke,Chetan
> Cc: hancockrwd@gmail.com; jgarzik@pobox.com; linux-ide@vger.kernel.org;
> linux-kernel@vger.kernel.org; philipl@overt.org
> Subject: RE: [PATCH 2.6.32 v2] MCP55 SATA2 conditional MSI support for
> sata_nv
> 
> > disable_msi() is missing right?
> 
> I didn't add that as none of the other drivers have it:

Then they would leak the MSI-vectors if request_irq fails.


> chainsaw@amalthea /cvs/linux-2.6/drivers/ata $ grep _msi * | grep pci
> ahci.c:		pci_enable_msi(pdev);
> sata_mv.c:	if (msi && pci_enable_msi(pdev) == 0)
> sata_vsc.c:	if (pci_enable_msi(pdev) == 0)
> 
> (This is a tree without the sata_nv change I submitted)
> 
> I do believe it is safe to shut the interrupt down and unload the
> handler whilst it is still in MSI mode. At least, I don't see the libata
> core special-casing it in any way.

If I'm not wrong then that's how it's supposed to be done. free_irq and then disable_msi. You can't reverse the order. Also the driver should know when to quiesce the ASIC. So quiesce first and then shutdown everything.


> Regards,
> Tony V.

Regards
Chetan
