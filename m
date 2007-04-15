Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbXDOID0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbXDOID0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 04:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXDOID0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 04:03:26 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:1082 "EHLO yumi.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbXDOIDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 04:03:23 -0400
Date: Sun, 15 Apr 2007 10:02:59 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070415080258.GA2716@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Adrian Bunk <bunk@stusta.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	pavel@suse.cz, linux-pm@lists.osdl.org,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704142223.32410.rjw@sisk.pl> <20070414213526.GA2401@melchior.yamamaya.is-a-geek.org> <200704142358.31758.rjw@sisk.pl> <20070415073820.GA2589@melchior.yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070415073820.GA2589@melchior.yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Rafael J. Wysocki wrote:
> > On Saturday, 14 April 2007 23:35, Tobias Diedrich wrote:
> > > Rafael J. Wysocki wrote:
> > > > On Saturday, 14 April 2007 21:56, Tobias Diedrich wrote:
> > > > > Rafael J. Wysocki wrote:
> > > > > > On Saturday, 14 April 2007 15:00, Adrian Bunk wrote:
> > > > > > > On Sat, Apr 14, 2007 at 02:31:54PM +0200, Tobias Diedrich wrote:
> > > > > > > > Tobias Diedrich wrote:
> > > > > > > > > > ed746e3b18f4df18afa3763155972c5835f284c5 is first bad commit
> > > > > > > > > > commit ed746e3b18f4df18afa3763155972c5835f284c5
> > > > > > > > > > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > > > > > Date:   Sat Feb 10 01:43:32 2007 -0800
> > > > > > > > > > 
> > > > > > > > > >     [PATCH] swsusp: Change code ordering in disk.c
> > > > > > > > > >     
> > > > > > > > > >     Change the ordering of code in kernel/power/disk.c so that device_suspend() is
> > > > > > > > > >     called before disable_nonboot_cpus() and platform_finish() is called after
> > > > > > > > > >     enable_nonboot_cpus() and before device_resume(), as indicated by the recent
> > > > > > > > > >     discussion on Linux-PM (cf.
> > > > > > > > > >     http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).
> > > > > > > > > >     
> > > > > > > > > >     The changes here only affect the built-in swsusp.
> > > > > > > > > >     
> > > > > > > > > >     [alexey.y.starikovskiy@linux.intel.com: fix LED blinking during image load]
> > > > > > > > > >     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > > > > >     Acked-by: Pavel Machek <pavel@ucw.cz>
> > > > > > > > > >     Cc: Greg KH <greg@kroah.com>
> > > > > > > > > >     Cc: Nigel Cunningham <nigel@suspend2.net>
> > > > > > > > > >     Cc: Patrick Mochel <mochel@digitalimplant.org>
> > > > > > > > > >     Cc: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
> > > > > > > > > >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > > > > > > >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > > > > > > 
> > > > > > > > > > :040000 040000 7eca5b3a8f9606bc4f2ff41192ec8c9d4ca90d18 8313b674e1d1bdf6849350af06d28a89b3bb3054 M      kernel
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > Now, the remaining test is to try reverting this commit from -rc6. :)
> > > > > > > > > 
> > > > > > > > > Doesn't apply cleanly against -rc6, but fixes the problem when
> > > > > > > > > reverted from -rc1.
> > > > > > > > 
> > > > > > > > Now, this was already reported in
> > > > > > > > http://lkml.org/lkml/2007/3/16/126
> > > > > > > > and I even flagged that message in my local folder, but apparently forgot
> > > > > > > > to follow up on it... *sigh*
> > > > > > > 
> > > > > > > Unless I misunderstood something, all of the problems Maxim described in 
> > > > > > > this email are fixed for him in -rc6.
> > > > > > > 
> > > > > > > But it's quite possible that you are running into a different issue 
> > > > > > > exposed by this commit.
> > > > > > 
> > > > > > Yes, it's likely.
> > > > > > 
> > > > > > Tobias, I'm unable to reproduce the problem with your .config, but my hardware
> > > > > > is certainly different.  Which suspend mode do you use?  If that's "platform",
> > > > > > can you try to use "shutdown" or "reboot" and see if that helps?
> > > > > 
> > > > > Sure.
> > > > > shutdown/reboot works fine, only platform is broken.
> > > > 
> > > > Thanks.
> > > > 
> > > > Now, I suspect the problem is somehow related to the hardware, so it would help
> > > > a lot if we could identify the piece of hardware (or driver) involved.
> > > > 
> > > > AFAICT, your system is a non-SMP one, so we can rule out
> > > > disable/enable_nonboot_cpus().  To confirm that the problem is related to
> > > > platform_finish(), can you please apply the appended debug patch and
> > > > see if the suspend in the 'platform' mode works with it?
> > > 
> > > Yes, it's a Asus M2N-SLI-Deluxe Mainboard with a Athlon64 3200+
> > > single core CPU.
> > > 
> > > > Also, would that be feasible for you to use 'shutdown' as a workaround in case
> > > > the source of the problem is difficult to find and/or fix?
> > > 
> > > I guess so, but the below patch fixes the problem. :)
> > 
> > Well, I thought it would, but it also would break some other people's systems.
> > That's the _real_ problem.  Let's see if we can learn more.
> > 
> > Can you please revert it for now, apply the appended one and try to
> > suspend/resume twice in the 'platform' mode (it may or may not work)?
> 
> Ok. The patch doesn't apply cleanly to 2.6.21-rc6:
> |patching file kernel/power/disk.c
> |Hunk #1 FAILED at 267.
> |Hunk #2 succeeded at 265 (offset -23 lines).
> |1 out of 2 hunks FAILED -- saving rejects to file
> |kernel/power/disk.c.rej
> 
> wiggle helps, seems the first part of Hunk #1 is already applied in
> 2.6.21-rc6.
> With CONFIG_PM_DEBUG=y and CONFIG_DISABLE_CONSOLE_SUSPEND=y I see
> that the second suspend hangs at "i8042 i8042: EARLY resume".
> This is kinda interesting because I'm normally using a USB keyboard
> and sure enough, if I hook up a normal keyboard and disable USB
> legacy support in the BIOS, then suspend to disk works multiple
> times. I'd still rather like to use my USB keyboard though. ;)

And I can now confirm that unpatched 2.6.21-rc6 works fine as long
as USB legacy support is disabled (however without legacy support I
can't use the USB keyboard to control grub).

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
