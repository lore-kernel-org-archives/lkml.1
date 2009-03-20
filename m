Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZCTDUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZCTDUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbZCTDUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:20:39 -0400
Received: from kroah.org ([198.145.64.141]:43874 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750722AbZCTDUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:20:39 -0400
Date: Thu, 19 Mar 2009 19:48:16 -0700
From: Greg KH <greg@kroah.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, daniel.krueger@systec-electronic.com,
       Michael Olbrich <mol@pengutronix.de>, Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
Message-ID: <20090320024816.GA20213@kroah.com>
References: <20090318183232.GA11594@kroah.com> <20090320005808.GM5367@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320005808.GM5367@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 01:58:08AM +0100, Robert Schwebel wrote:
> Greg,
> 
> On Wed, Mar 18, 2009 at 11:32:32AM -0700, Greg KH wrote:
> > If anyone has any questions that this summary doesn't answer, please let me
> > know.
> 
> Let me take this as an opportunity to discuss the epl (Ethernet
> Powerlink) driver in staging. Taken aside the eye-cancer thing while
> looking at the code (this could be fixed in the staging model), I
> suppose the whole design is questionable.

Sure it's questionable, and it's horrid code, but it is being used by
people and is the only public implementation of EPL on Linux that I can
find.

> We have ported similar commercial EPL stacks to linux-rt in the past,
> and what we simply did is to implement the code completely in userspace,
> ontop of a raw socket. It worked out pretty well and with reasonable
> realtime performance. For the high level API, we used the process data
> model provided by libpv [1], which gives you an abstraction that follows
> both, automation-people's "process variable" concept and a modern object
> oriented desing (in C, modeled after the POSIX object model for example
> like pthread_create() & friends).
> 
> Doing this kind of network protocols in kernel space may be possible in
> general, but IMHO the first thing that has to be done for a sane design
> is:
> 
> 	"Invent proper APIs and abstractions"

Agreed.

> Unfortunately, industry people have somehow missed the last 10 years of
> software engineering, so even recent ethernet fieldbus designs like
> PowerLink or EtherCAT use the CANopen Object Dictionary [1] as their
> "abstraction" between the stack and the application. So writing
> applications in the EPL/CANopen/EtherCAT world works by PEEK and POKE on
> a variable-length global variable array. Welcome to software design of
> the 80es. Nevertheless, "Object Dictionary" is a standard API for
> industry people which cannot be discussed away, because automation
> people are used to this terminology.
> 
> So if we want to do any kind of EPL/CANopen/EtherCAT work in the kernel,
> let's start with the question what it buys us in comparism with a pure
> userspace solution like outlined above.

Are userspace solutions for this opensource today?

<snip>

> What do others think? Is it worth the effort to invent a proper objdict
> API for linux?

I suggest discussing this on netdev, that's the proper place for network
protocol discussions like this, right?

thanks,

greg k-h
