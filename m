Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYLCPem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYLCPem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYLCPeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:34:21 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:56171 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYLCPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:34:19 -0500
Date: Wed, 3 Dec 2008 16:34:18 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Theodore Tso <tytso@mit.edu>
cc: Pavel Machek <pavel@suse.cz>, Chris Friesen <cfriesen@nortel.com>,
       clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
In-Reply-To: <20081203050709.GL20858@mit.edu>
Message-ID: <Pine.LNX.4.64.0812031613320.5406@artax.karlin.mff.cuni.cz>
References: <20081202094059.GA2585@elf.ucw.cz> <20081202140439.GF16172@mit.edu>
 <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu>
 <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu>
 <20081202224403.GA8277@elf.ucw.cz> <20081203050709.GL20858@mit.edu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Dec 2008, Theodore Tso wrote:

> > Ok, "memory failed before disk" is ... bad hardware.
> 
> It's PC class hardware. Live with it.  Back when SGI made their own
> hardware, they noticed this problem, and so they wired up their SGI
> machines with powerfail interrupts, and extra big capacitors in their
> power supplies, and when Irix got a powerfail interrupt, it would
> frantically run around aborting DMA transfers to avoid this particular
> problem.  At least, that's what an old-timer SGI engineer (who is
> unfortunately no longer at SGI) told me.

I heard this too --- I just don't understand why did they route it to an 
interrupt and undertook the complicated sequence of aborting the commands 
by the kernel --- instead of simply routing it to PCI reset line --- that 
would reset the controller and stop it from feeding data to disks.

Also, if they had ECC memory, the chipset should detect unrecoverable 
garbage and respond with target-abort or full system reset and not feed 
bad data to the controller.

> PC class hardware don't have power fail interrupts.  Hence, my advice
> to you is that if you use a filesystem that does logical journalling
> --- better have a UPS.

ATX has PWR_OK pin that should be deasserted on power failure before the 
voltage drops.

I don't know if motherboards use it --- but there should be no problem 
routing the pin to the chipset reset and stop it before power goes low.

> > ...but... you seem to be saying that modern filesystems can damage 
> > data even on "sane" hardware.
> 
> The example I gave was one where a disk failure could cause a file
> that had previously been sucessfully written to disk and fsync()'ed to
> be damaged by another filesystem operation ***in the face of hard
> drive failure***.  Surely that is obvious.  The most obvious case of
> that might be if the disk controller gets confused and slams a data
> block into the wrong location on disk (there's a reason why DIF
> includes the sector number in its checksum and why some enterprise
> databases do the same thing in their tablespace blocks --- it happens
> often enough that paranoid data integrity engineers worry about it).

You can read the block number back from ATA disk after you write it and 
before you submit the command.

Mikulas
