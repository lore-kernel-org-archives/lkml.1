Return-Path: <linux-kernel-owner+w=401wt.eu-S965482AbXH0V7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965482AbXH0V7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764463AbXH0V6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:58:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40659 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764313AbXH0V6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:58:04 -0400
Date: Mon, 27 Aug 2007 23:58:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, rusty@rustycorp.com.au,
       vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Message-ID: <20070827215822.GH3398@elf.ucw.cz>
References: <20070827104350.GA2073@elf.ucw.cz> <b6a2187b0708270736q5cfc180fp3c223a57ea6904f9@mail.gmail.com> <20070827213248.GF3398@elf.ucw.cz> <200708272359.32484.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708272359.32484.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-08-27 23:59:31, Rafael J. Wysocki wrote:
> On Monday, 27 August 2007 23:32, Pavel Machek wrote:
> > On Mon 2007-08-27 22:36:57, Jeff Chua wrote:
> > > On 8/27/07, Pavel Machek <pavel@ucw.cz> wrote:
> > > > On Mon 2007-08-27 12:43:50, Pavel Machek wrote:
> > > > > Hi!
> > > > >
> > > > > Trying to do few onlines/offlines reliably hangs my machine (thinkpad
> > > > > x60, i386 architecture).
> > > 
> > > I just 3 cycles of on-line/off-line on 2.6.23-rc3 on ThinkPad x60s,
> > > and my system still survives.
> > 
> > Can you try 20-or-so tests? Mine hangs randomly, so it survived 4 or
> > so cycles at one point.
> > 
> > ...or maybe difference is in the .config, or maybe I broken something
> > in my kernel sources....
> 
> Well, something seems to be wrong with the CPU hotplug, but it's insanely
> difficult to reproduce on my boxes.
> 
> I bet on one of the notifiers blocking while waiting on a frozen task.

It happens reliably for me, with this script... and randomly, when I
just echo 0/1 > online from commandline... so it should not be
anything with the frozen tasks.

echo test > /sys/power/disk
echo disk > /sys/power/state

reliably hangs on resume in the attached script. It works ok with
nosmp.

								Pavel

#!/bin/bash
killall klogd

echo -n "testing refrigerator (testproc)..."
echo testproc > /sys/power/disk
echo disk > /sys/power/state
echo "okay"

sleep 2
echo -n "testing drivers (test)..."
echo test > /sys/power/disk
echo disk > /sys/power/state
echo "okay"

sleep 2
echo -n "testing swsusp (reboot)..."
echo reboot > /sys/power/disk
echo disk > /sys/power/state
echo "okay"

sleep 2
echo -n "testing s2ram..."
s2ram
echo "okay"

sleep 2
echo -n "testing swsusp (shutdown)..."
echo shutdown > /sys/power/disk
echo disk > /sys/power/state
echo "okay"

sleep 2
echo -n "testing swsusp (platform)..."
echo platform > /sys/power/disk
echo disk > /sys/power/state
echo "okay"

sleep 2
echo -n "testing s2ram..."
s2ram
echo "okay"
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
