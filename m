Return-Path: <linux-kernel-owner+w=401wt.eu-S965405AbXBLVD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965405AbXBLVD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965408AbXBLVD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:03:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44622 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965409AbXBLVD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:03:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 22:01:00 +0100
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Manu Abraham <abraham.manu@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc,
       Robert Hancock <hancockr@shaw.ca>
References: <1171059433.8675.195.camel@laptopd505.fenrus.org> <200702122131.33662.rjw@sisk.pl> <20070212205857.GE18101@elf.ucw.cz>
In-Reply-To: <20070212205857.GE18101@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702122201.01666.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 February 2007 21:58, Pavel Machek wrote:
> Hi!
> 
> > > > If all you need to do is say 'I don't need to do anything' and we have a
> > > > shared function that does that, all we're talking about doing is adding
> > > > to your struct pci_device (or whatever)
> > > > 
> > > > .resume = generic_empty_resume;
> > > > 
> > > > To me at least, that doesn't look awkward, and says cleanly and clearly
> > > > that you've checked things over and decided you know what's required.
> > > 
> > > Actually, I'd like it to be
> > > 
> > > .resume = generic_empty_resume; /* Explain, why your driver needs no
> > > 				   resume */
> > 
> > Okay, but we can't define an empty .resume(), because, for example, the PCI's
> > generic suspend/resume won't be called.
> 
> PCI drivers should just do .resume = pci_generic_resume, explicitely.

Well, I generally agree, but I think the idea with the "pm_safe" flag has some
advantages.  For example, the drivers that do deffine .suspend() and .resume()
which don't work correctly could be flagged as not "pm_safe" until the problems
are fixed.

Greetings,
Rafael
