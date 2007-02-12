Return-Path: <linux-kernel-owner+w=401wt.eu-S965334AbXBLVYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965334AbXBLVYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965378AbXBLVYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:24:48 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:37250 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965334AbXBLVYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:24:47 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Manu Abraham <abraham.manu@gmail.com>,
       Willy Tarreau <w@1wt.eu>, Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tilman@imap.cc,
       Robert Hancock <hancockr@shaw.ca>
In-Reply-To: <200702122201.01666.rjw@sisk.pl>
References: <1171059433.8675.195.camel@laptopd505.fenrus.org>
	 <200702122131.33662.rjw@sisk.pl> <20070212205857.GE18101@elf.ucw.cz>
	 <200702122201.01666.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 08:24:13 +1100
Message-Id: <1171315453.4081.23.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-02-12 at 22:01 +0100, Rafael J. Wysocki wrote:
> On Monday, 12 February 2007 21:58, Pavel Machek wrote:
> > Hi!
> > 
> > > > > If all you need to do is say 'I don't need to do anything' and we have a
> > > > > shared function that does that, all we're talking about doing is adding
> > > > > to your struct pci_device (or whatever)
> > > > > 
> > > > > .resume = generic_empty_resume;
> > > > > 
> > > > > To me at least, that doesn't look awkward, and says cleanly and clearly
> > > > > that you've checked things over and decided you know what's required.
> > > > 
> > > > Actually, I'd like it to be
> > > > 
> > > > .resume = generic_empty_resume; /* Explain, why your driver needs no
> > > > 				   resume */
> > > 
> > > Okay, but we can't define an empty .resume(), because, for example, the PCI's
> > > generic suspend/resume won't be called.
> > 
> > PCI drivers should just do .resume = pci_generic_resume, explicitely.
> 
> Well, I generally agree, but I think the idea with the "pm_safe" flag has some
> advantages.  For example, the drivers that do deffine .suspend() and .resume()
> which don't work correctly could be flagged as not "pm_safe" until the problems
> are fixed.

Oooh. Now I like that idea. Are you thinking of a document in
Documentation/power that describes why pm_safe is off, or comments in
the code itself?

Regards,

Nigel

