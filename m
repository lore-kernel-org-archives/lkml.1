Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYA3XPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYA3XPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbYA3XPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:15:05 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34251 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753555AbYA3XPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:15:04 -0500
Date: Thu, 31 Jan 2008 00:15:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Stephen Blackheath [to Foxconn]" <stephen@symmetric.co.nz>
Cc: David Sterba <dsterba@suse.cz>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jkosina@suse.cz, benm@symmetric.co.nz
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
Message-ID: <20080130231521.GA5937@elf.ucw.cz>
References: <20080128171929.GA3906@ds.suse.cz> <20080130134046.GB5139@elf.ucw.cz> <47A0EC3A.1040502@symmetric.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A0EC3A.1040502@symmetric.co.nz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-01-31 10:29:30, Stephen Blackheath [to Foxconn] wrote:
> Pavel & all,
> 
> 
> Pavel Machek wrote:
> 
> >> +/* I/O ports and bit definitions for version 2 of the hardware */
> >> +
> >> +struct MEMCCR {
> >> +	unsigned short PCCOR;		/* Configuration Option Register */
> >> +	unsigned short PCCSR;		/* Configuration and Status Register */
> >> +	unsigned short PCPRR;		/* Pin Replacemant Register */
> >> +	unsigned short PCSCR;		/* Socket and Copy Register */
> >> +	unsigned short PCESR;		/* Extendend Status Register */
> >> +	unsigned short PCIOB;		/* I/O Base Register */
> >> +};

> > Could we get better names? PCIOB is cryptic, pci_io_base is pretty
> > good.
> >
> >   
> We should keep these names because they are part of the interface
> between host and card defined by the manufacturer.

No. Use sensible names, and put manufacturer-defined 5-letter crap in
the comments. Heck, notice that they just took first letter of each
word of good name....

> > Is some locking needed around *hw?
> >   
> I don't think so, but I'm happy to be corrected.

You have a structure, and are accessing its fields from interrupts. I
assume you access the fields outside interrupt, too? As the fields are
not of atomic_t, I believe you need locking.

(Oh, and I should have said that earlier: Thanks for the driver and
congratulations for getting it this far).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
