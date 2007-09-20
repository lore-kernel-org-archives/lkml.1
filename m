Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbXITGTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbXITGTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbXITGSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:18:53 -0400
Received: from www.osadl.org ([213.239.205.134]:51960 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750924AbXITGSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:18:52 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <200709200206.20992.rjw@sisk.pl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <200709191944.22383.rjw@sisk.pl> <1190229690.2975.4.camel@chaos>
	 <200709200206.20992.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 08:18:48 +0200
Message-Id: <1190269128.3235.7.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 02:06 +0200, Rafael J. Wysocki wrote:
> On Wednesday, 19 September 2007 21:21, Thomas Gleixner wrote:
> > On Wed, 2007-09-19 at 19:44 +0200, Rafael J. Wysocki wrote:
> > > > > It boots with nohpet alone and suspend/hibernation seem to work (still,
> > > > > it didn't want to boot right after hibernation, but booted after I'd switched
> > > > > it off/on manually).
> > > > 
> > > > Can you please check, whether
> > > > 
> > > > http://tglx.de/projects/hrtimers/2.6.23-rc6/patch-2.6.23-rc6-hrt2.patch
> > > > 
> > > > works for you ?
> > > 
> > > Nope.  It's a total disaster. :-(
> > 
> > True. I have instrumented it to the point where the broadcast device is
> > programmed, but no interrupt comes in for totally unknown reasons.
> > 
> > > Doesn't boot at all, even with "noacpitimer nohpet", and that's with
> > > NO_HZ and HIGH_RES_TIMERS unset.
> > 
> > > If you have a bisectable patch series, I can try to identify the responsible
> > > patch.
> > 
> > http://tglx.de/projects/hrtimers/2.6.23-rc6/patch-2.6.23-rc6-hrt2.patches.tar.bz2
> > 
> > The first patches in the queue are the mainline fixups.
> 
> It's x86_64-convert-to-clockevents.patch (ie. after applying it the box stops
> to boot).
> 
> I haven't had the time to check if any special command line arguments help.
> Will check tomorrow.

Can you please disable the patches, which I sent Linus wards:

timekeeping-access-rtc-outside-xtime-lock.patch
xtime-supsend-resume-fixup.patch
acpi-reevaluate-c-p-t-states.patch
clockevents-enforce-broadcast-on-resume.patch
clockevents-do-not-shutdown-broadcast-device-in-oneshot-mode.patch
clockevents-prevent-stale-tick-update-on-offline-cpu.patch

Without those patches you get the state of rc4-mm1. It would be
interesting to know which one interferes with the acpi stuff.

	tglx


