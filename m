Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbYF3Ohg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbYF3Ohg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 10:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYF3Oh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 10:37:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33709 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751737AbYF3Oh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 10:37:27 -0400
Date: Mon, 30 Jun 2008 10:37:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Stefan Becker <Stefan.Becker@nokia.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>,
       ext Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PATCH: 2.6.26-rc8: Fix IRQF_DISABLED for shared interrupts
In-Reply-To: <200806300415.15796.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0806301035510.2708-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, David Brownell wrote:

> On Monday 30 June 2008, Stefan Becker wrote:
> > It seems IRQF_SHARED | IRQF_DISABLED has already been discussed several 
> > times on LKML:
> 
> Given that, I'm surprised that nobody has added a warning that
> prints when those two flags are both passed to request_irq().
> 
> The problems have been around for a long time, "tested" and known
> to be broken.  They'll never go away without nag messages nudging
> developers to fix the problems.
> 
> 
> > Alan: should I try to implement his choice (f) insteadn, i.e. drop 
> > IRQF_DISABLED from USB HCD interrupts and disable interrupts in 
> > usb_hcd_irq() instead?
> 
> That's the best solution for USB, given that IRQF_DISABLED isn't
> going to do what it claims to do.

I agree.  Note that IRQF_DISABLED is used in hcd_pci.c as well as in
quite a few files in drivers/usb/host.

Alan Stern

