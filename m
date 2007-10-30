Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbXJ3VEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbXJ3VEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbXJ3VDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:03:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42105 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbXJ3VDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:03:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
Subject: Re: [2.6.23] IBM X41 looses time after Suspend2Disk
Date: Tue, 30 Oct 2007 22:20:33 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <20071029201955.GA1955@titan.lahn.de> <200710292205.11459.rjw@sisk.pl> <20071030083537.GA2797@titan.lahn.de>
In-Reply-To: <20071030083537.GA2797@titan.lahn.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710302220.34490.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 30 October 2007 09:35, Philipp Matthias Hahn wrote:
> Hello Rafael, Pavel!
> 
> Thank you both for the fast help.
> 
> On Mon, Oct 29, 2007 at 10:05:10PM +0100, Rafael J. Wysocki wrote:
> > On Monday, 29 October 2007 21:19, Philipp Matthias Hahn wrote:
> > > I have an IBM X41 tablet pc running 2.6.23 with the following problem:
> > > Suspend2Ram work fine, but when I do a Suspend2Disk (echo disk >
> > > /sys/power/state), the notebook hangs showing the following lines:
> ...
> > >         Suspending console(s)
> > > 
> > > When I repeatedly press some keys or move the TrackPoint, the SwSusp
> > > continues and the notebook powers off.
> > > On reboot, the notebook resumes but hangs showing the following screen:
> ...
> > >         Suspending console(s)
> > > 
> > > Generating interrupts by pressing keys or moving the TrackPoints makes
> > > the resume continue. But after that, the notebook looses time, xterms
> > > don't get updated until I press a key, the beeper beeps until I press a
> > > key, etc.
> ...
> > Please try to do "echo shutdown > /sys/power/disk" before hibernation and
> > see what happens.
> 
> I'm already doing that.

Well, have you tried doing "echo platform > /sys/power/disk" before hibernation
instead?

> > Also, is it an SMP kernel or UP?
> 
> UP.
> 
> 
> On Mon, Oct 29, 2007 at 10:24:14PM +0100, Pavel Machek wrote:
> > Yep, I seen that before. Try "nohz=off".
> 
> Okay, that seems to solve the "timer loosing time after resume" problem.
> 
> 
> But I still need to press some keys on suspend (7-12 key presses and
> releases) to unhang it. On resume not key presses are needed any more.
> 
> During on suspend-resume cycle ACPI barfed afer resume spewing messages
> without end (error during execution of methode \...THM, error evaulation
> operand ...) I had to remove the battery and pull the power-plug to
> reboot it.

The ACPI platform firmware got confused, apparently.

Greetings,
Rafael
