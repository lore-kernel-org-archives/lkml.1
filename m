Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYFSVcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYFSVcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbYFSVbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:31:52 -0400
Received: from mail.suse.de ([195.135.220.2]:38060 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbYFSVbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:31:51 -0400
Date: Thu, 19 Jun 2008 14:29:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Juergen Kosel <juergen.kosel@gmx.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 04/15] opti621: remove DMA support
Message-ID: <20080619212948.GE20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="opti621-remove-dma-support.patch"
In-Reply-To: <20080619212621.GA20267@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit f361037631ba547ea88adf8d2359d810c1b2605a upstream

These controllers don't support DMA.

Based on a bugreport from Juergen Kosel & inspired by pata_opti.c code.

Tested-by: Juergen Kosel <juergen.kosel@gmx.de>
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/pci/opti621.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -324,20 +324,16 @@ static const struct ide_port_info opti62
 		.name		= "OPTI621",
 		.init_hwif	= init_hwif_opti621,
 		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
+		.host_flags	= IDE_HFLAG_NO_DMA |
 				  IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO3,
-		.swdma_mask	= ATA_SWDMA2,
-		.mwdma_mask	= ATA_MWDMA2,
 	},{	/* 1 */
 		.name		= "OPTI621X",
 		.init_hwif	= init_hwif_opti621,
 		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
+		.host_flags	= IDE_HFLAG_NO_DMA |
 				  IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO3,
-		.swdma_mask	= ATA_SWDMA2,
-		.mwdma_mask	= ATA_MWDMA2,
 	}
 };
 

-- 
