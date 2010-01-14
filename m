Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229Ab0ANPkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0ANPkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132Ab0ANPkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:40:40 -0500
Received: from khc.piap.pl ([195.187.100.11]:33505 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab0ANPkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:40:39 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Seth Heasley <seth.heasley@intel.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel  Cougar Point DeviceIDs
References: <201001121700.18234.seth.heasley@intel.com>
	<4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>
	<51f3faa71001131611y343ad225n1acc73900fd49894@mail.gmail.com>
Date: Thu, 14 Jan 2010 16:40:36 +0100
In-Reply-To: <51f3faa71001131611y343ad225n1acc73900fd49894@mail.gmail.com>
	(Robert Hancock's message of "Wed, 13 Jan 2010 18:11:43 -0600")
Message-ID: <m3eilsitjf.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockrwd@gmail.com> writes:

> Well, ata_piix does have a couple of entries that are listed in ahci
> as well, for ICH6 device IDs 0x2652 and 0x2653. For 0x2653 ata_piix
> checks the class code to make sure it's IDE, but for the 0x2652 entry,
> and in both cases in ahci, the class code isn't checked. Deleting the
> specific entries from ahci for those controllers would seemingly
> actually improve the situation, since then ahci wouldn't try and
> attach to those devices when they indicate IDE class. ata_piix should
> also should be checking for IDE class on 0x2652 as well.

Interestingly the ICH6* datasheet says:
2651 is plain ICH6 (not RAID/AHCI capable)
2652 is ICH6R
2553 is ICH6-M

The subclass code is:
for plain ICH6: 01 (IDE controller)
for ICH6R: 04 (RAID controller)
for ICH6-M: 01 (IDE) or 06 (SATA=AHCI)

I think later chips change their subclass depending on
IDE/AHCI/RAID BIOS setting, wasn't it the ICH6R case as well?

Not checking the subclass for ICH6-M in ahci driver may be a bug,
unless ahci can handle the chip in BIOS-set IDE mode. Not checking
ICH6R code (or checking only for RAID) seems right, though.
-- 
Krzysztof Halasa
