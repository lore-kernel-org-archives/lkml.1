Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbZCTIqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbZCTIqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbZCTIqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:46:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43538 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbZCTIqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:46:40 -0400
Date: Fri, 20 Mar 2009 09:46:36 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Daniel =?iso-8859-15?Q?Kr=FCger?= 
	<daniel.krueger@systec-electronic.com>
Cc: Greg KH <greg@kroah.com>, Robert Schwebel <r.schwebel@pengutronix.de>,
       linux-kernel@vger.kernel.org, Michael Olbrich <mol@pengutronix.de>,
       Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
Message-ID: <20090320084636.GP5367@pengutronix.de>
References: <20090318183232.GA11594@kroah.com> <20090320005808.GM5367@pengutronix.de> <20090320024816.GA20213@kroah.com> <49C35515.8050808@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C35515.8050808@systec-electronic.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:36:22 up 30 days, 29 min, 47 users,  load average: 0.03, 0.10,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 09:34:29AM +0100, Daniel Krüger wrote:
> > Sure it's questionable, and it's horrid code, but it is being used by
> > people and is the only public implementation of EPL on Linux that I
> > can find.
>
> BTW, the implementation does not follow the kernel style guide,
> because  our company has its own code style guide. But what is that
> you don't like?

If you do your private stuff, you can do whatever you like. If you want
to bring something into the kernel, you have to follow the kernel style.

But it's not only a matter of coding style. Please let's not start with
implementation details as long as the overall design is unclear. So I
suggest that following Greg's advise and moving the discussion to netdev
is what we should do.

> > > Doing this kind of network protocols in kernel space may be
> > > possible in general, but IMHO the first thing that has to be done
> > > for a sane design is:
> > >
> > > 	"Invent proper APIs and abstractions"
> >
> > Agreed.
>
> I can only second that. But it is no easy task to find a common API
> for all field busses.

Finding a common API for all field busses is somethign we'll do on a
higher level in the OSADL Fieldbus Framework project, but in userspace.

What matters for the kernel is that, if we want to have things in
mainline, we must answer the question "what have these things in
common". It doesn't make any sense to invent infrastructure for things
that don't have anything in common. Kernel frameworks are all about
abstraction.

> > Are userspace solutions for this opensource today?
>
> No. But openPOWERLINK can be ported to userspace.

Sure.

> I would propose another solution. Just leave the high priority tasks
> in the kernel which directly deal with the Ethernet frames and
> implement all other modules in userspace.

So why not work completely ontop of raw sockets? What else do you need
in the kernel?

The only thing I can imagine is a fast packet switch that separates high
priority realtime packets from normal non-rt traffic in the network
stack. As far as I know, tglx has a patch for that.

Let's move the discussion to netdev.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
