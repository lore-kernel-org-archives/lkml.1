Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYIDE1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYIDE1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 00:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYIDE1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 00:27:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:52087 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYIDE1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 00:27:38 -0400
Date: Wed, 3 Sep 2008 21:27:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alok Kataria <akataria@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>, Dan Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Fix TSC calibration issues
Message-ID: <20080903212729.436da8d3@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0809032112400.3378@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net>
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
	<20080903211029.187d8dab@infradead.org>
	<alpine.LFD.1.10.0809032112400.3378@nehalem.linux-foundation.org>
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

On Wed, 3 Sep 2008 21:20:23 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> I do agree that we could aim for something like that. But even to get
> the rough estimate, we'd probably have to do the 5ms thing.

5msec isn't too big a deal; 250ms otoh ;-)

> 
> > another option for calibrating the tsc rate is to read it from the
> > msr's/cpuid/aperf of what the hardware says it should be, and then
> > all we need is to verify it is that; that we could do over timer or
> > quickly. (of course that only works for systems with constant tsc)
> 
> I don't think it's reliable even for systems with a constant TSC.
> Because the msr/cpuid thing isn't going to actualyl give the right
> frequency. It might be the frequency the thing is _rated_ at, but it
> will be off when people over- or under-clock the front-side bus etc.

for 99%+ of the systems it'll be extremely close. We do need to
validate it to detect the overclocking etc (and if the calibration says
"it smells funny" we can do the slow 250msec thing)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
