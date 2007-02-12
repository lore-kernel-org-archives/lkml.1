Return-Path: <linux-kernel-owner+w=401wt.eu-S965385AbXBLUzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965385AbXBLUzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965394AbXBLUyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:54:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44554 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965385AbXBLUyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:54:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 21:31:32 +0100
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Manu Abraham <abraham.manu@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc,
       Robert Hancock <hancockr@shaw.ca>
References: <1171059433.8675.195.camel@laptopd505.fenrus.org> <1171236787.4493.132.camel@nigel.suspend2.net> <20070212165207.GC17400@elf.ucw.cz>
In-Reply-To: <20070212165207.GC17400@elf.ucw.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702122131.33662.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 February 2007 17:52, Pavel Machek wrote:
> Hi!
> 
> > > > > > Neither am I. I'm just asking that new drivers have power management as
> > > > > > standard.
> > > >
> > > > > What if the hardware doesn't support power management ?
> > > >
> > > > You would still want to do the cleanup and configuration that you'd do
> > > > for module load/unload.
> > > >
> > > By adding dummy functions, wouldn't that just look awkward ?
> > 
> > If all you need to do is say 'I don't need to do anything' and we have a
> > shared function that does that, all we're talking about doing is adding
> > to your struct pci_device (or whatever)
> > 
> > .resume = generic_empty_resume;
> > 
> > To me at least, that doesn't look awkward, and says cleanly and clearly
> > that you've checked things over and decided you know what's required.
> 
> Actually, I'd like it to be
> 
> .resume = generic_empty_resume; /* Explain, why your driver needs no
> 				   resume */

Okay, but we can't define an empty .resume(), because, for example, the PCI's
generic suspend/resume won't be called.

I think we can introduce a "pm_safe" flag that will indicate if the driver
handles suspend/resume correctly.  If we do it, we can flag all of the drivers
currently in the tree as "pm_safe" unless we know that they aren't.  Next,
we can convert the core to fail the suspend for any driver that is not flagged
as "pm_safe".  But I think that will take time.

In the meantime, I'd like to ask the authors of new drivers to define
error-returning .suspend() if they don't intend to define "real" .suspend()
and .resume() for now.  When we are ready with the conversion, we'll be able
to drop the error-returning .suspend()s and clear "pm_safe" for them.

Greetings,
Rafael
