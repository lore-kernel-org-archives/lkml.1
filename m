Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbXDQDgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbXDQDgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 23:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXDQDgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 23:36:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbXDQDgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 23:36:13 -0400
Date: Mon, 16 Apr 2007 23:34:00 -0400
From: Dave Jones <davej@redhat.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [2/2] 2.6.21-rc7: known regressions
Message-ID: <20070417033400.GE22804@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de> <20070416005446.GB21217@redhat.com> <20070416011636.GO3691@stusta.de> <20070416062921.GB7528@redhat.com> <1176706447.5129.6.camel@daplas> <20070416072326.GA15281@redhat.com> <1176708722.5129.8.camel@daplas> <20070416075543.GB15281@redhat.com> <1176715603.6794.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176715603.6794.13.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 10:26:43AM +0100, Richard Purdie wrote:

 > >  > >  > CONFIG_FB_BACKLIGHT=y
 > >  > >  > CONFIG_ACPI_VIDEO=n
 > >  > > 
 > >  > > That also gets me a dead display. Backlight doesn't turn back on.
 > >  > 
 > >  > Anything under /sys/class/backlight?
 > > 
 > > Entries from ibm_acpi.  I rmmod'd that, leaving the dir empty,
 > > and it still fails.
 > 
 > What happens if you never load ibm-acpi?

Same thing. No backlight on resume.
I rm'd the .ko, so there's no chance it got loaded.

 > I'm a bit puzzled as CONFIG_FB_BACKLIGHT doesn't do anything with the
 > intelfb driver. One thing it does do is set
 > CONFIG_BACKLIGHT_CLASS_DEVICE. When you disabled FB_BACKLIGHT and got a
 > working display on resume, was that set and was (or had) ibm-acpi been
 > loaded?
 > 
 > A variety of other options such as ACPI_IBM also set
 > CONFIG_BACKLIGHT_CLASS_DEVICE although without a backlight driver it
 > will do nothing hence the suspicion is on ibm-acpi, perhaps interacting
 > with the backlight class badly.
 > 
 > Does echoing numbers to /sys/class/backlight/ibm_acpi/brightness change
 > the backlight brightness as expected?

/sys/class/backlight/ibm/brightness takes a value from 0 to 7.
Starts off with a default of 0. I tried all values in there, and
it made no visible difference.  But as the no-backlight thing happens
without this even loaded, I think this is a separate problem.

 > If you can ssh into the machine
 > after its resumed with the display problem, it would be interesting to
 > know what the brightness was and if changing it helped too...

When the backlight doesn't come on, for some reason, nothing else
runs.  Capslock works, so it's at least partially alive, but even
doing..

echo mem > /sys/power/state ; echo foo >/bar ; sync

results in no /bar being created.
Ethernet remains down when its in this state too.

It's the reason it's taken this long to get any debug info out of it at all.

	Dave

-- 
http://www.codemonkey.org.uk
