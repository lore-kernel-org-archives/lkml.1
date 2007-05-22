Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbXEVEcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbXEVEcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 00:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbXEVEcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 00:32:04 -0400
Received: from smtp.osdl.org ([207.189.120.12]:35461 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbXEVEcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 00:32:02 -0400
Date: Mon, 21 May 2007 21:31:46 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Mike Houston <mikeserv@bmts.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
Message-ID: <20070521213146.3e220a44@freepuppy>
In-Reply-To: <20070521225806.bb18d589.mikeserv@bmts.com>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
	<20070520170506.814a38d9.mikeserv@bmts.com>
	<20070521084549.61a1aa71@freepuppy>
	<20070521131055.0017404f.mikeserv@bmts.com>
	<20070521103755.51b954e1@freepuppy>
	<20070521225806.bb18d589.mikeserv@bmts.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 22:58:06 -0400
Mike Houston <mikeserv@bmts.com> wrote:

> On Mon, 21 May 2007 10:37:55 -0700
> Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> 
> > On Mon, 21 May 2007 13:10:55 -0400
> > Mike Houston <mikeserv@bmts.com> wrote:
> > 
> > > On Mon, 21 May 2007 08:45:49 -0700
> > > Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > > 
> > > > It's almost certainly a problem with the BIOS and hardware (not
> > > > a sky2) driver issue. Since there are many similar boards and
> > > > configurations, I made the decision not to enforce restrictions
> > > > in the driver.
> > > 
> > > >> May 20 15:57:48 cramit kernel: sky2 0000:04:00.0: v1.14 addr
> > > >> 0xf8000000 irq 16 Yukon-EC Ultra (0xb4) rev 2
> > > 
> > > Thank you for your answer. I was half wondering if that was the
> > > case after staring at those log messages several more times. I
> > > don't understand hardware at the low level but got thinking maybe
> > > interrupt routing issue. There's an Nvidia PCI Express card in
> > > there that gets IRQ 16, though it was not initialized by a driver
> > > at the time. (plain old VGA console after fresh cold boot... no
> > > framebuffer, no X, no nvidia module). I guess some things don't
> > > share well.
> > > 
> > > It works well in that other OS that came with the hardware, but
> > > that's beside the point.
> > 
> > It is some low level PCI Express related stuff, try latest BIOS (F9)
> > and if that doesn't help there is a EEPROM update from Gigabyte
> > for the Marvell hardware that might help.
> 
> Thanks for your suggestions, I followed through on them. It may still
> be interesting/useful to hear from me that it didn't help. The
> problem is the same.
> 
> My motherboard is a newer revision (Gigabyte GA-965P-DS3 Rev 3.3) and
> already had the "F10" bios version, but I flashed to the latest F11
> version anyways. I also flashed with the EEPROM update from Gigabyte,
> from a FAQ entry for my motherboard revision.
> (faq_marvell_eeprom.zip). Both operations were successful. I cleared
> the CMOS and reconfigured after the bios flash too.
> 
> Incidently, it was showing IRQ 16 in that early initialization
> message, but actually getting a MSI interrupt (IRQ 219, PCI-MSI-edge)
> 
> I've disabled the onboard yukon2 adapter in bios and gone
> back to the PCI card now. I think we can consider the matter closed,
> since it's not a problem with the driver, but just so you know, I'm
> always willing to help test when it's hardware that I have.
> 
> Mike Houston

There maybe some hardware level interaction with SATA controller.
I saw no failures running off i386 kernel of PATA drive and quickly
see errors with SATA/AHCI and x86_64.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
