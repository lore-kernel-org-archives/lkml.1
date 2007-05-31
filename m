Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbXEaAwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbXEaAwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbXEaAwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:52:08 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:45923 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753232AbXEaAwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:52:07 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200705310051.l4V0pvk2018678@turbo.physics.adelaide.edu.au>
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Date: Thu, 31 May 2007 10:21:57 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       davidsen@tmr.com (Bill Davidsen), linux-kernel@vger.kernel.org
In-Reply-To: <20070528143101.GB10008@csclub.uwaterloo.ca> from "Lennart Sorensen" at May 28, 2007 10:31:02 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Sorensen wrote:
> On Mon, May 28, 2007 at 08:37:21AM +0930, Jonathan Woithe wrote:
> > The CDROM was showing up in the POST in all cases.
> > 
> > It turns out the problem (as I outlined in a followup post) resulted from a
> > combination of issues.
> > 
> >  1) This board uses a Marvell PATA controller, so the relevant driver must
> >     be configured.
> > 
> >  2) Unless the "Configure SATA as" setting in the BIOS is set to "AHCI" the
> >     PATA controller won't be found.  Sounds a bit odd and counter-intuitive,
> >     but that's what's happening.  Originally this item was set to IDE; the
> >     other option is RAID but I haven't tested that.
> 
> Maybe the SATA pretending to be PATA took up the ports that the marvell
> PATA needed to provide PATA, so in effect hidding the marvell.

I don't think so but I could be wrong.  When "Configure SATA as" was set to
"IDE" the HDD was being detected as a SATA drive and showed up as /dev/sda. 
The only visible difference the change to "AHCI" made was that instead of
the drive being handled by the ata_piix it now utilises the ahci driver
(which is a much better driver).  The other interesting thing is that the
probe for the Marvell PATA device occured before the initialisation of the
ata_piix driver (or ahci for that matter), so as far as I can tell ata_piix
had no chance to grab any ports before the marvell driver initialised.

Regards
  jonathan
-- 
"Time is an illusion; lunchtime doubly so"
