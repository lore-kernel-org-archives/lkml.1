Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbXEaNkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbXEaNkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXEaNkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:40:06 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:45389 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbXEaNkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:40:04 -0400
Date: Thu, 31 May 2007 09:40:03 -0400
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
Message-ID: <20070531134003.GQ10006@csclub.uwaterloo.ca>
References: <20070528143101.GB10008@csclub.uwaterloo.ca> <200705310051.l4V0pvk2018678@turbo.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705310051.l4V0pvk2018678@turbo.physics.adelaide.edu.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 10:21:57AM +0930, Jonathan Woithe wrote:
> I don't think so but I could be wrong.  When "Configure SATA as" was set to
> "IDE" the HDD was being detected as a SATA drive and showed up as /dev/sda. 
> The only visible difference the change to "AHCI" made was that instead of
> the drive being handled by the ata_piix it now utilises the ahci driver
> (which is a much better driver).  The other interesting thing is that the
> probe for the Marvell PATA device occured before the initialisation of the
> ata_piix driver (or ahci for that matter), so as far as I can tell ata_piix
> had no chance to grab any ports before the marvell driver initialised.

Linux can still detect the chip and drive it natively even if the bios
is emulating IDE/PATA on the chip.  And libata will make both PATA and
SATA show up as /dev/sda now if you use libata for both.  On the other
hand if the bios has configured the intel chip to use the standard ide
registers, then it can't have configured the marvell to do so I would
guess, which could make it difficult to talk to.

--
Len Sorensen
