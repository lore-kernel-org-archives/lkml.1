Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYBAPFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYBAPFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYBAPEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:04:53 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22387 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbYBAPEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:04:52 -0500
Message-ID: <47A33512.8050401@msgid.tls.msk.ru>
Date: Fri, 01 Feb 2008 18:04:50 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: swsusp on an AMD x2-64, 2.6.24: regression?
References: <47A24072.4090001@msgid.tls.msk.ru> <20080131231219.GA14355@elf.ucw.cz> <47A2F168.8070407@msgid.tls.msk.ru> <200802011225.11571.rjw@sisk.pl>
In-Reply-To: <200802011225.11571.rjw@sisk.pl>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday, 1 of February 2008, Michael Tokarev wrote:
[]
>> no_console_suspend it is.  Tried that, the "S|" thing is still
>> here, but instead of "Suspending console(s)" it now shows
>> progress of suspending other devices.  The end result is
>> the same - finally it stops and sits here ad infinitum.
> 
> I guess it's a special variation of
> http://bugzilla.kernel.org/show_bug.cgi?id=9528
> 
> Please try to hibernate in the shutdown mode (ie. echo
> "shutdown" into /sys/power/disk before hibernation).

Hmm.  A very obscure thing - that bug, that is.

Tried "shutdown" - it works - even with all the other
"fancy" stuff like highres timers, cpufreq et al.  And
it resumes correctly as well.

After reading all the stuff attached to that bugreport,
I also tried removing ohci_hcd - it also works just fine
(had to do it in one line --
   rmmod ohci-hcd; sleep 5; echo disk > /sys/power/state
-- because I don't have non-USB keyboard handy :)

What I also noticied is that at least twice while doing
all the experiments, I've seen a message similar to (off
memory):

  ohci_hcd: unlink after non-IRQ - controller is probably using the wrong IRQ

this is done when no_console_suspend is enabled - during
the final stage of suspend, when the kernel prints messages
about disabling acpi devices.  I can't reproduce it easily,
but it happened at least twice with the same kernel configuration
(i tried different options, many variations, recompiling and
reinstalling kernel each time).

In any way, this is definitely progress, and that bug
seems to be the same as I'm seeing here.

Now... I see there's a new BIOS for this mobo available
(it's ASUS M2NPV-VM motherboard, Geforce6150/Nforce430(?)),
which is more recent compared with what I have here.  Trying
it now (will try to reflash it without a floppy - it turns
out to be quite.. challenging task ;)

Thanks!

/mjt
