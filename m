Return-Path: <linux-kernel-owner+w=401wt.eu-S1423129AbXBUVGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423129AbXBUVGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423130AbXBUVGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:06:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47563 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423129AbXBUVGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:06:50 -0500
Date: Wed, 21 Feb 2007 13:06:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
cc: tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: Linux 2.6.21-rc1
In-Reply-To: <1172090973.8577.77.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.64.0702211302300.4043@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> 
 <1172075053.8577.38.camel@imap.mvista.com>  <1172077664.25076.75.camel@localhost.localdomain>
  <1172078340.8577.43.camel@imap.mvista.com>  <1172079671.25076.80.camel@localhost.localdomain>
  <1172079523.8577.48.camel@imap.mvista.com>  <1172081931.25076.95.camel@localhost.localdomain>
  <1172082200.8577.56.camel@imap.mvista.com>  <1172085792.25076.119.camel@localhost.localdomain>
  <1172088050.8577.71.camel@imap.mvista.com>  <1172090603.25076.127.camel@localhost.localdomain>
 <1172090973.8577.77.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Feb 2007, Daniel Walker wrote:
> 
> Here's the final commit from the bisect which caused it . It says "No
> changes to existing functionality" ?

Ok, it wouldn't be the first time some change that is supposed to change 
nothing does actually change something.

That said, one thing to worry about when doing bisection: the kernel 
configuration.

If you always just do "make oldconfig" or something, the kernel config for 
the thing you test will depend on the _previous_ kernel you compiled, and 
that is not always what you want. I've once had a failing kernel, did 
bisection, and it turned out that since I had gone back in time to before 
the option that caused the failure even existed, I had (by mistake) then 
compiled some of the later kernels without that option enabled, and called 
them "good". 

The end result: "git bisect" didn't actually end up pointing to the right 
commit, just because I had effectively lied to it.

That said, considering that you did get a commit that doesn't look 
entirely unlikely (and that clearly changes things that are relevant), I 
suspect you did actually find the right one.

		Linus
---
> commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Feb 16 01:28:04 2007 -0800
> 
>     [PATCH] clockevents: i386 drivers
> 
>     Add clockevent drivers for i386: lapic (local) and PIT/HPET (global).  Update
>     the timer IRQ to call into the PIT/HPET driver's event handler and the
>     lapic-timer IRQ to call into the lapic clockevent driver.  The assignement of
>     timer functionality is delegated to the core framework code and replaces the
>     compile and runtime evalution in do_timer_interrupt_hook()
> 
>     Use the clockevents broadcast support and implement the lapic_broadcast
>     function for ACPI.
> 
>     No changes to existing functionality.
> 
> 
