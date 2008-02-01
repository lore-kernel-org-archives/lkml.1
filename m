Return-Path: <linux-kernel-owner+w=401wt.eu-S1763141AbYBAMo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763141AbYBAMo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbYBAMoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:44:19 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3169 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755181AbYBAMoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:44:19 -0500
Date: Fri, 1 Feb 2008 12:44:08 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: swsusp on an AMD x2-64, 2.6.24: regression?
Message-ID: <20080201124407.GA4349@ucw.cz>
References: <47A24072.4090001@msgid.tls.msk.ru> <20080131231219.GA14355@elf.ucw.cz> <47A2F168.8070407@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A2F168.8070407@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-01 13:16:08, Michael Tokarev wrote:
> Pavel Machek wrote:
> > On Fri 2008-02-01 00:41:06, Michael Tokarev wrote:
> []
> >> With 2.6.24, it tries to suspend, saves pages to disk,
> >> when prints this:
> >>
> >> ..Saving pages... done.
> >> Sl
> 
> It's actually "S|", not "Sl".
> 
> >> Suspending console(s)
> >> _
> >>
> >> At this point, nothing more happens.  It does not
> >> react to keyboard or to any other external events,
> 
> ..because the keyboard is USB-connected, and it shuts
> down all USB devices.  I'll try with PS/2 keyboard
> (when I'll find one I had somewhere... ;)
> 
> []
> > no_console_suspend (sp?), nohz=off, highres=off, and try with minimum
> > config.
> 
> no_console_suspend it is.  Tried that, the "S|" thing is still
> here, but instead of "Suspending console(s)" it now shows
> progress of suspending other devices.  The end result is
> the same - finally it stops and sits here ad infinitum.
> 
> nohz and highres are useless now, as I recompiled the kernel
> without support for those, and without CPU_IDLE and other
> fancy stuff, and disabled cpufreq just in case.
> 
> What's minimum config?  Should I turn off SMP (it's a dual-core
> CPU by the way)?  Something else?  (I already removed most
> driver modules when when trying suspend - only ones which are
> absolutely necessary are left).

Disabling smp can't hurt, agreed.

> I've read Documentation/power/tricks.txt. From that list,
> I have the following:
> 
>  o all drivers are unloaded except disk and usb (keyboard)
>  o preempt is disabled (was never enabled)
>  o APIC IS in use.
>  o modules are in use.  Is it worth to try module-less?
>  o vga text console - not even "vga" per se, - no framebuffers
>    and such, not even as modules.  No "video mode switching
>    support" is enabled.
>  o only a few processes left, in like single-user mode.

Try init=/bin/bash, too.

> One other difference between 2.6.23 and 2.6.24 as I see here
> is: 2.6.24 tells me about TSC unstability (when I load cpufreq
> stuff), while 2.6.23 did not.  This is about 64bit mode - with
> 32bits, both switches from tsc to hpet, so in this regard,
> 2.6.24 (with 32bits) is not different from 2.6.23 it seems
> (i mean in relation with suspend issues, since 32bits .23
> mentioned tsc instability yet it suspended fine).
> 
> So I'm.. stuck. :)  Don't know where to go from here.

git bisect is always an option.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
