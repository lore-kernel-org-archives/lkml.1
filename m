Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbYBAKQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbYBAKQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbYBAKQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:16:12 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22795 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbYBAKQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:16:11 -0500
Message-ID: <47A2F168.8070407@msgid.tls.msk.ru>
Date: Fri, 01 Feb 2008 13:16:08 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: swsusp on an AMD x2-64, 2.6.24: regression?
References: <47A24072.4090001@msgid.tls.msk.ru> <20080131231219.GA14355@elf.ucw.cz>
In-Reply-To: <20080131231219.GA14355@elf.ucw.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Fri 2008-02-01 00:41:06, Michael Tokarev wrote:
[]
>> With 2.6.24, it tries to suspend, saves pages to disk,
>> when prints this:
>>
>> ..Saving pages... done.
>> Sl

It's actually "S|", not "Sl".

>> Suspending console(s)
>> _
>>
>> At this point, nothing more happens.  It does not
>> react to keyboard or to any other external events,

..because the keyboard is USB-connected, and it shuts
down all USB devices.  I'll try with PS/2 keyboard
(when I'll find one I had somewhere... ;)

[]
> no_console_suspend (sp?), nohz=off, highres=off, and try with minimum
> config.

no_console_suspend it is.  Tried that, the "S|" thing is still
here, but instead of "Suspending console(s)" it now shows
progress of suspending other devices.  The end result is
the same - finally it stops and sits here ad infinitum.

nohz and highres are useless now, as I recompiled the kernel
without support for those, and without CPU_IDLE and other
fancy stuff, and disabled cpufreq just in case.

What's minimum config?  Should I turn off SMP (it's a dual-core
CPU by the way)?  Something else?  (I already removed most
driver modules when when trying suspend - only ones which are
absolutely necessary are left).

I've read Documentation/power/tricks.txt. From that list,
I have the following:

 o all drivers are unloaded except disk and usb (keyboard)
 o preempt is disabled (was never enabled)
 o APIC IS in use.
 o modules are in use.  Is it worth to try module-less?
 o vga text console - not even "vga" per se, - no framebuffers
   and such, not even as modules.  No "video mode switching
   support" is enabled.
 o only a few processes left, in like single-user mode.

One other difference between 2.6.23 and 2.6.24 as I see here
is: 2.6.24 tells me about TSC unstability (when I load cpufreq
stuff), while 2.6.23 did not.  This is about 64bit mode - with
32bits, both switches from tsc to hpet, so in this regard,
2.6.24 (with 32bits) is not different from 2.6.23 it seems
(i mean in relation with suspend issues, since 32bits .23
mentioned tsc instability yet it suspended fine).

So I'm.. stuck. :)  Don't know where to go from here.

Thanks!

/mjt
