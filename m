Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbYCQPq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbYCQPq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYCQPqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:46:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1182 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751992AbYCQPqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:46:51 -0400
Date: Mon, 17 Mar 2008 16:46:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Joel K. Greene" <joel.greene@catapult.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Timer interrupt stops, causes soft lockup
Message-ID: <20080317154639.GA4102@ucw.cz>
References: <1205235450.18463.45.camel@linuxdt036.nc.catapult.com> <47D6423D.1E6F.00AA.0@novell.com> <1205255048.18463.60.camel@linuxdt036.nc.catapult.com> <1205260328.18463.67.camel@linuxdt036.nc.catapult.com> <47D68B9D.1E6F.00AA.0@novell.com> <1205265642.18463.82.camel@linuxdt036.nc.catapult.com> <1205322793.20205.9.camel@linuxdt036.nc.catapult.com> <1205326713.20205.27.camel@linuxdt036.nc.catapult.com> <1205332212.20205.33.camel@linuxdt036.nc.catapult.com> <1205510009.29658.83.camel@linuxdt036.nc.catapult.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205510009.29658.83.camel@linuxdt036.nc.catapult.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Of course when time stops progessing forward at a steady pace all
> sorts of Bad Things happen.  
> 
> The clock loop is caused by jiffies not incrementing. It seems that wall
> time updates itself and then resync's with jiffies every ~4s.
> 
> We verified that all spinlocks ( xtime_lock in particular ) were not
> being held, and that the kernel had no reason not to update jiffies.
> Other interrupts continue to fire, so we're not stuck in the timer
> handler.
> 
> So, we went on to look at the PIC. We threw together a little kernel
> module to get some debug info.

Nice debugging.

> We have over 10 systems demonstrating the problem, many in customer
> sites. 

Does nosmp help?

Does noapic/nolapic help?

You may want to try testing with HZ=4000... to show the problem
faster.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
