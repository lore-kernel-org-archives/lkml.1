Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbYIARuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbYIARuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYIARuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:50:04 -0400
Received: from www.tglx.de ([62.245.132.106]:40441 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYIARuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:50:03 -0400
Date: Mon, 1 Sep 2008 19:49:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <48BC0C1C.9050205@lwfinger.net>
Message-ID: <alpine.LFD.1.10.0809011940110.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC0C1C.9050205@lwfinger.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Larry Finger wrote:

> Thomas Gleixner wrote:
> > 
> > > +Clocksource tsc unstable (delta = 500037272 ns)
> > 
> > > -Clocksource tsc unstable (delta = 83950402 ns)
> > 
> > In both cases the TSC is ahead of the pm_timer, which looks like the
> > pm_timer is behaving strange.
> > 
> > Can you please disable the pm_timer (in the kernel config,
> > unfortunately there is no command line option for that) for a test and
> > provide the relevant output of demsg ?
> 
> I manually deleted CONFIG_X86_PM_TIMER from .config, but it returns silently.
> The only way I see to turn off the pm_timer is to disable power management. Is
> that what I need to do?

The switch depends on CONFIG_EMBEDDED. Just turn that on in "General Setup"

       [*] Configure standard kernel features (for small systems)  --->

Then you get an extra switch in:

 "Powermanagement Options"
 	ACPI (Advanced Configuration and Power Interface) Support  ---> 
		[*]   Power Management Timer Support 

Turn that one off.

Thanks,

	tglx
