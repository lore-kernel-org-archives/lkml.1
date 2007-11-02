Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbXKBNdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbXKBNdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXKBNd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:33:29 -0400
Received: from ip-svs-1.Informatik.Uni-Oldenburg.DE ([134.106.12.126]:51759
	"EHLO schlidder.svs.informatik.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096AbXKBNd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:33:28 -0400
Date: Fri, 2 Nov 2007 14:33:23 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.23] IBM X41 looses time after Suspend2Disk
Message-ID: <20071102133323.GC2780@titan.lahn.de>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-pm@lists.linux-foundation.org,
	Thomas Gleixner <tglx@linutronix.de>
References: <20071029201955.GA1955@titan.lahn.de> <200710292205.11459.rjw@sisk.pl> <20071030083537.GA2797@titan.lahn.de> <200710302220.34490.rjw@sisk.pl> <20071029201955.GA1955@titan.lahn.de> <20071029212414.GD3692@elf.ucw.cz> <20071029201955.GA1955@titan.lahn.de> <200710292205.11459.rjw@sisk.pl> <20071030083537.GA2797@titan.lahn.de> <20071030210801.GA1767@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710302220.34490.rjw@sisk.pl> <20071030210801.GA1767@elf.ucw.cz>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Tue, Oct 30, 2007 at 10:08:01PM +0100, Pavel Machek wrote:
> > > On Monday, 29 October 2007 21:19, Philipp Matthias Hahn wrote:
> > > > I have an IBM X41 tablet pc running 2.6.23 with the following problem:
> > > > Suspend2Ram work fine, but when I do a Suspend2Disk (echo disk >
> > > > /sys/power/state), the notebook hangs showing the following lines:
> > ...
> > > >         Suspending console(s)
> > > > 
> > > > When I repeatedly press some keys or move the TrackPoint, the SwSusp
> > > > continues and the notebook powers off.
> > > > On reboot, the notebook resumes but hangs showing the following screen:
> > ...
> > > >         Suspending console(s)
> > > > 
> > > > Generating interrupts by pressing keys or moving the TrackPoints makes
> > > > the resume continue. But after that, the notebook looses time, xterms
> > > > don't get updated until I press a key, the beeper beeps until I press a
> > > > key, etc.
...
> > On Mon, Oct 29, 2007 at 10:24:14PM +0100, Pavel Machek wrote:
> > > Yep, I seen that before. Try "nohz=off".
> > 
> > Okay, that seems to solve the "timer loosing time after resume" problem.
> > 
> > 
> > But I still need to press some keys on suspend (7-12 key presses and
> > releases) to unhang it. On resume not key presses are needed any
> > more.
> 
> So it fixed resume but not suspend? strange. Try highres=off, too. And
> maybe irqpoll?

highres=off did the trick. Thank you.

Does somebody want more data to debug this further?


On Tue, Oct 30, 2007 at 10:20:33PM +0100, Rafael J. Wysocki wrote:
> Well, have you tried doing "echo platform > /sys/power/disk" before
> hibernation instead?

It also seems to work, but doesn't improve the situation. I still need
to press keys for resume.

BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
