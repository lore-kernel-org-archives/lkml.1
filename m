Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbXGGAVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbXGGAVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 20:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXGGAVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 20:21:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60123 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbXGGAVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 20:21:13 -0400
Message-ID: <468EDC76.9050708@garzik.org>
Date: Fri, 06 Jul 2007 20:21:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: IDE/ATA development list <linux-ide@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: libata-dev.git clean up and branch status
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

libata-dev.git was left a bit grotty when I went on vacation.  That has 
now been fixed.  The current branches are:

git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

master		Always vanilla Linus tree

ALL		Always the "exported for testing" meta-branch
		(currently == upstream + sil680-mmio + mv-ahci)

upstream	queued for 2.6.23
		Parent: master

mv-ahci		Marvell 6121/6141 AHCI clone SATA support
		Parent: upstream
		Status: Works, once NCQ & PCI MSI are disabled.
			Turn these off, then can go up.

mv-ahci-pata	Marvell 6121/6141 AHCI clone PATA support
		Parent: mv-ahci
		Status: Need to update for proper use of PATA
			controller commands (provides direct access to
			PATA device shadow registers)

mv-eh		sata_mv (50xx/60xx) conversion to new EH
		Parent: upstream
		Status: Required for hotplug, NCQ, etc.  Working, but
			currently NCQ disks fail (even if NCQ not used)

new-eh		pdc_adma, sata_qstor, sata_sx4 conversion to new EH
		Parent: upstream
		Status: All conversions complete...
			and completely untested.

sii-lbt		sata_sil Large [DMA] Block Transfer support
		Parent: upstream
		Status: Useful, but reported to fail in some cases

sil680-mmio	pata_sil680 MMIO support
		Parent: upstream
		Status: dissolved into some argument about MMIO flushing


