Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYIDDQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYIDDQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 23:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbYIDDQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 23:16:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:33087 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbYIDDQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 23:16:10 -0400
Date: Wed, 3 Sep 2008 20:16:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alok Kataria <akataria@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>, Dan Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Fix TSC calibration issues
Message-ID: <20080903201602.2ab6c449@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0809031817430.3515@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net>
	<alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
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

On Wed, 3 Sep 2008 19:56:10 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 3 Sep 2008, Alok Kataria wrote:
> > 
> > As Linus suggested, we should be moving the tsc_read_refs outside
> > of the loop, this gives us more accurate TSC calibration when
> > calibrating against hpet/pmtimer, since we are now calibrating over
> > a period of 250ms.
> 
> Side note: I'd like to change that.
> 
> 250ms is a _loong_ time. It's a really really long time. It's 
> human-noticeable. A quarter of a second at boot is just too long.

yeah it's insane ;-(
(since we boot a kernel in 1 second and a full OS including the kernel
in 5)

>  - do other things while calibrating.

one option for that is the fastboot patchkit in -next ;-)

but at some point, even doing things in parallel/asynchronous isn't
helping, "parallel shit is still shit" :)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
