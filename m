Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbXDOQfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbXDOQfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 12:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXDOQfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 12:35:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53802 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbXDOQfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 12:35:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dtor@insightbb.com>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>
Subject: Re: Linux 2.6.21-rc6
Date: Sun, 15 Apr 2007 17:52:59 +0200
User-Agent: KMail/1.9.5
Cc: pavel@suse.cz, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Maxim Levitsky <maximlevitsky@gmail.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704151316.26136.rjw@sisk.pl> <200704151019.37074.dtor@insightbb.com>
In-Reply-To: <200704151019.37074.dtor@insightbb.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704151753.00584.rjw@sisk.pl>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 15 April 2007 16:19, Dmitry Torokhov wrote:
> On Sunday 15 April 2007 07:16, Rafael J. Wysocki wrote:
> > On Sunday, 15 April 2007 10:02, Tobias Diedrich wrote:
> > 
> > > > With CONFIG_PM_DEBUG=y and CONFIG_DISABLE_CONSOLE_SUSPEND=y I see
> > > > that the second suspend hangs at "i8042 i8042: EARLY resume".
> > > > This is kinda interesting because I'm normally using a USB keyboard
> > > > and sure enough, if I hook up a normal keyboard and disable USB
> > > > legacy support in the BIOS, then suspend to disk works multiple
> > > > times. I'd still rather like to use my USB keyboard though. ;)
> > 
> > Well, I think that when you're using the USB keyboard and the USB legacy
> > support, the i8042 driver thinks it has a keyboard to handle and tries to
> > handle it during the suspend, which fails.  I don't know why it fails during
> > the second suspend, though.
> > 
> > Dmitry, could you please have a look?
> > 
> 
> This is wierd as i8042 does not use suspend_late/resume_early hooks and
> so it is impossible for it to hang there. None of input drivers use these
> hooks. Could it be that some other driver _after_ i8042 hangs?

Yes.

Tobias, can you please post the dmesg output from after a successful
suspend/resume cycle with CONFIG_PM_DEBUG=y in the 'platform' mode?

> > > And I can now confirm that unpatched 2.6.21-rc6 works fine as long
> > > as USB legacy support is disabled (however without legacy support I
> > > can't use the USB keyboard to control grub).
> > 
> > I think using the 'shutdown' mode of suspend would be better.  There's a little
> > point in using 'platform' on desktop systems anyway.
> > 
> > Frankly, I don't know what to do about it.  If we move platform_finish() after
> > device_resume(), some systems may be broken and I think there are more such
> > systems than there are systems that set USB legacy support in the BIOS and
> > have no PS/2 keyboards attached.
> 
> I would say that every box that does not use PS/2 keyboard does this.

Quite some people I know use USB keyboards with notebooks, but in these cases
the PS/2 keyboard is still attached (except for notebooks in which the built-in
keyboard is a USB one, that is).

> IOW every box with USB keyboard has legacy emulation turned on so quite
> few of them...

I have such a machine nearby, so I'll see if I can reproduce the problem.

Greetings,
Rafael

