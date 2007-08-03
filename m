Return-Path: <linux-kernel-owner+w=401wt.eu-S1761430AbXHCLRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430AbXHCLRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 07:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759582AbXHCLRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 07:17:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:59260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759473AbXHCLRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 07:17:03 -0400
Subject: Re: 2.6.22 regression: thermal trip points
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Andi Kleen <andi@firstfloor.org>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, lenb@kernel.org
In-Reply-To: <20070802183830.GA4192@one.firstfloor.org>
References: <46B1988C.3090302@t-online.de>
	 <20070802015248.45a40717.akpm@linux-foundation.org>
	 <p731wemnre6.fsf@bingen.suse.de>
	 <20070802120014.1d08830a@the-village.bc.nu>
	 <20070802120511.GA440@one.firstfloor.org>
	 <20070802140442.62c56dbd@the-village.bc.nu>
	 <20070802131622.GA1234@one.firstfloor.org> <20070802155753.GB3974@ucw.cz>
	 <20070802183830.GA4192@one.firstfloor.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Fri, 03 Aug 2007 13:16:58 +0200
Message-Id: <1186139818.18821.590.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 20:38 +0200, Andi Kleen wrote:
> On Thu, Aug 02, 2007 at 03:57:54PM +0000, Pavel Machek wrote:
> > On Thu 2007-08-02 15:16:22, Andi Kleen wrote:
> > > On Thu, Aug 02, 2007 at 02:04:42PM +0100, Alan Cox wrote:
> > > > > > Set a taint flag, 
> > > > > That's hardly any useful if the machine is dead afterwards.
> > > > 
> > > > It won't be the hardware will do a failsafe shutdown first.
> > > 
> > > Not necessarily. At SUSE we had at least one broken laptop
> > > with wrong trip points. The machine ran very hot for some time
> > > and afterwards the hard disk was dead.
> > 
> > Yes, but it was original BIOS trip points that were wrong. And yes,
> > its failsafe shutdown was too late. At least lowering the trip points
> > would allow me to run it safely.
> 
> I have no problem with lowering them (in fact I proposed this
> to Thomas as a possible solution at some point). Just rising 
> is a bad idea.

Ok.
If nobody screams (especially Len who has to accept this in the end, I
don't want to do work for nothing..), I'll try an implementation that:
  - Allows lowering trip points
  - If BIOS modifies trip points, the overridden ones might also
    get lowered if they are even lower
  - Allow the definition of a passive trip point (with some default
    values for hysteresis), even if the thermal zone does not
    provide one

If we have something like this, we could still discuss a config option,
that also allows to increase trip points, marking it with "If you set
this you can destroy your machine, you have been warned...". While this
would not be an option for distributions to compile in, some people may
come around the biggest hammer -> overriding DSDT.

I cannot promise, but I try to get this for 2.6.24.

   Thomas

