Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbYIDEKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbYIDEKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 00:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYIDEKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 00:10:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:57287 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYIDEKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 00:10:39 -0400
Date: Wed, 3 Sep 2008 21:10:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alok Kataria <akataria@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>, Dan Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Fix TSC calibration issues
Message-ID: <20080903211029.187d8dab@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0809032041130.3515@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net>
	<alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809021906250.3259@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809031103090.3243@apollo.tec.linutronix.de>
	<1220490884.22734.83.camel@alok-dev1>
	<alpine.LFD.1.10.0809031817430.3515@nehalem.linux-foundation.org>
	<20080903201602.2ab6c449@infradead.org>
	<alpine.LFD.1.10.0809032041130.3515@nehalem.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 20:59:05 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The only frequency we can trust on 99% of all machines is the PIT,

pmtimer is also quite ok, with the exception of some K6 based boxes.
(I'm surprised the K6 boxes even have enough modern stuff to have
pmtimer; I'd think they would fall under the date cutoff)

> and it's a very uncomfortable programming model due to all the
> history (it is one of the few truly 8-bit things left in a modern
> PC). The other options are just not reliably there, or are known to
> not have a stable frequency.
> 
> So how would you suggest we do it? Lowering the wait to 5ms (times 5,
> so it's really 25ms, although we can probably stop early if the first 
> iterations are very consistent) will work, but it _will_ reduce
> precision. And it's still real time.

one of the options we have is to start with an initial
rough-but-conservative estimate, and refine it over time as the system
is running.... sort of like ntp but for the calibration.

another option for calibrating the tsc rate is to read it from the
msr's/cpuid/aperf of what the hardware says it should be, and then all
we need is to verify it is that; that we could do over timer or quickly.
(of course that only works for systems with constant tsc)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
