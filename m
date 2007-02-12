Return-Path: <linux-kernel-owner+w=401wt.eu-S965398AbXBLU7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965398AbXBLU7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965400AbXBLU7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:59:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51609 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965398AbXBLU7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:59:22 -0500
Date: Mon, 12 Feb 2007 21:58:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Manu Abraham <abraham.manu@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070212205857.GE18101@elf.ucw.cz>
References: <1171059433.8675.195.camel@laptopd505.fenrus.org> <1171236787.4493.132.camel@nigel.suspend2.net> <20070212165207.GC17400@elf.ucw.cz> <200702122131.33662.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702122131.33662.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > If all you need to do is say 'I don't need to do anything' and we have a
> > > shared function that does that, all we're talking about doing is adding
> > > to your struct pci_device (or whatever)
> > > 
> > > .resume = generic_empty_resume;
> > > 
> > > To me at least, that doesn't look awkward, and says cleanly and clearly
> > > that you've checked things over and decided you know what's required.
> > 
> > Actually, I'd like it to be
> > 
> > .resume = generic_empty_resume; /* Explain, why your driver needs no
> > 				   resume */
> 
> Okay, but we can't define an empty .resume(), because, for example, the PCI's
> generic suspend/resume won't be called.

PCI drivers should just do .resume = pci_generic_resume, explicitely.

> In the meantime, I'd like to ask the authors of new drivers to define
> error-returning .suspend() if they don't intend to define "real" .suspend()
> and .resume() for now.  When we are ready with the conversion, we'll be able
> to drop the error-returning .suspend()s and clear "pm_safe" for them.

Yes... please.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
