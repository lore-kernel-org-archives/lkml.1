Return-Path: <linux-kernel-owner+w=401wt.eu-S1750827AbXDOOTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750827AbXDOOTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 10:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbXDOOTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 10:19:37 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:4744 "EHLO
	asav13.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXDOOTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 10:19:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HALjQIUZKhRO4UGdsb2JhbACPfgEBKg
From: Dmitry Torokhov <dtor@insightbb.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.21-rc6
Date: Sun, 15 Apr 2007 10:19:35 -0400
User-Agent: KMail/1.9.3
Cc: Tobias Diedrich <ranma+kernel@tdiedrich.de>, pavel@suse.cz,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Maxim Levitsky <maximlevitsky@gmail.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070415080258.GA2716@melchior.yamamaya.is-a-geek.org> <200704151316.26136.rjw@sisk.pl>
In-Reply-To: <200704151316.26136.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151019.37074.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007 07:16, Rafael J. Wysocki wrote:
> On Sunday, 15 April 2007 10:02, Tobias Diedrich wrote:
> 
> > > With CONFIG_PM_DEBUG=y and CONFIG_DISABLE_CONSOLE_SUSPEND=y I see
> > > that the second suspend hangs at "i8042 i8042: EARLY resume".
> > > This is kinda interesting because I'm normally using a USB keyboard
> > > and sure enough, if I hook up a normal keyboard and disable USB
> > > legacy support in the BIOS, then suspend to disk works multiple
> > > times. I'd still rather like to use my USB keyboard though. ;)
> 
> Well, I think that when you're using the USB keyboard and the USB legacy
> support, the i8042 driver thinks it has a keyboard to handle and tries to
> handle it during the suspend, which fails.  I don't know why it fails during
> the second suspend, though.
> 
> Dmitry, could you please have a look?
> 

This is wierd as i8042 does not use suspend_late/resume_early hooks and
so it is impossible for it to hang there. None of input drivers use these
hooks. Could it be that some other driver _after_ i8042 hangs?

> > And I can now confirm that unpatched 2.6.21-rc6 works fine as long
> > as USB legacy support is disabled (however without legacy support I
> > can't use the USB keyboard to control grub).
> 
> I think using the 'shutdown' mode of suspend would be better.  There's a little
> point in using 'platform' on desktop systems anyway.
> 
> Frankly, I don't know what to do about it.  If we move platform_finish() after
> device_resume(), some systems may be broken and I think there are more such
> systems than there are systems that set USB legacy support in the BIOS and
> have no PS/2 keyboards attached.

I would say that every box that does not use PS/2 keyboard does this.
IOW every box with USB keyboard has legacy emulation turned on so quite
few of them...

-- 
Dmitry
