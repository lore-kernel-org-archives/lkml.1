Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbXFAHGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbXFAHGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbXFAHGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:06:14 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:38150 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbXFAHGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:06:14 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200706010705.l5175uwJ028953@turbo.physics.adelaide.edu.au>
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
To: jeff@garzik.org (Jeff Garzik)
Date: Fri, 1 Jun 2007 16:35:56 +0930 (CST)
Cc: lsorense@csclub.uwaterloo.ca (Lennart Sorensen),
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       davidsen@tmr.com (Bill Davidsen), linux-kernel@vger.kernel.org
In-Reply-To: <465ED34C.2060801@garzik.org> from "Jeff Garzik" at May 31, 2007 09:53:16 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Lennart Sorensen wrote:
> > On Thu, May 31, 2007 at 10:21:57AM +0930, Jonathan Woithe wrote:
> >> I don't think so but I could be wrong.  When "Configure SATA as" was set to
> >> "IDE" the HDD was being detected as a SATA drive and showed up as /dev/sda. 
> >> The only visible difference the change to "AHCI" made was that instead of
> >> the drive being handled by the ata_piix it now utilises the ahci driver
> >> (which is a much better driver).  The other interesting thing is that the
> >> probe for the Marvell PATA device occured before the initialisation of the
> >> ata_piix driver (or ahci for that matter), so as far as I can tell ata_piix
> >> had no chance to grab any ports before the marvell driver initialised.
> > 
> > Linux can still detect the chip and drive it natively even if the bios
> > is emulating IDE/PATA on the chip.  And libata will make both PATA and
> > SATA show up as /dev/sda now if you use libata for both.  On the other
> > hand if the bios has configured the intel chip to use the standard ide
> > registers, then it can't have configured the marvell to do so I would
> > guess, which could make it difficult to talk to.
> 
> Mostly true...  "standard IDE" can be configured in two modes, legacy 
> mode and native mode.  Legacy mode has fixed addresses originating from 
> the ISA days (0x170, 0x1f0, irqs 14 & 15), and (as you implied) you 
> cannot bind two IDE controllers to the same ISA addresses.
> 
> OTOH, an unlimited number of IDE controllers can be configured into 
> native mode, where all addresses and irq are allocated using standard 
> means accorded all PCI devices.

In the situation being discussed, "ATA/IDE Mode" was set to "Native" in the
BIOS (the other option for this item was "Legacy").  The BIOS had a separate
"Configure SATA as" item with the options RAID, IDE and AHCI and it is this
one which, when set to IDE, prevented Linux from finding the Marvell PATA
chip - even though "ATA/IDE Mode" was set to "native".

The legacy/native issue Jeff discusses sounds like it relates to the
"ATA/IDE Mode" BIOS setting.  Since this was always "Native" during the
tests and given what Jeff wrote, I would have thought the BIOS would not be
using the legacy ISA-era settings and therefore they were not the reason for
Linux not finding the Marvell PATA controller.

Regards
  jonathan
