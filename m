Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbXIWT7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbXIWT7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 15:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXIWT7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 15:59:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48862 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbXIWT7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 15:59:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Christian P. Schmidt" <charlie@digadd.de>
Subject: Re: Memory allocation problem with 2.6.22 after suspend/resume cycle
Date: Sun, 23 Sep 2007 22:12:56 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>
References: <46F53793.3020102@digadd.de> <200709232028.05423.rjw@sisk.pl> <46F6BC10.1030305@digadd.de>
In-Reply-To: <46F6BC10.1030305@digadd.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709232212.57203.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 September 2007 21:18, Christian P. Schmidt wrote:
> Rafael J. Wysocki wrote:
> > On Sunday, 23 September 2007 18:19, Christian P. Schmidt wrote:
> >> Rafael J. Wysocki wrote:
> >>> On Sunday, 23 September 2007 14:38, Christian P. Schmidt wrote:
> >>>> Rafael J. Wysocki wrote:
> >>>>> On Saturday, 22 September 2007 17:41, Christian P. Schmidt wrote:
> >>>>>> Hi all,
> >>>>>>
> >>>>>> I'm having a strange problem, of course not reproducible. Sometimes
> >>>>>> after a suspend (to ram) and resume cycle, the kernel will try to free
> >>>>>> all memory. This means, all running applications are flushed to swap (as
> >>>>>> long as it is available), caches and buffers stay at around 15MB each.
> >>>>>>
> >>>>>> The following video (traded quality for bandwidth) shows what happens on
> >>>>>> the way from no swap to "swapon -a" (that's the unreadable thing in the
> >>>>>> small shell): http://digadd.de/swapping.avi
> >>>>>>
> >>>>>> The system:
> >>>>>> Linux dnnote 2.6.22.5 #1 SMP PREEMPT Sat Aug 25 18:39:21 AST 2007 x86_64
> >>>>>> Intel(R) Core(TM)2 CPU T7400 @ 2.16GHz GenuineIntel GNU/Linux
> >>>>> Are you using an ATI binary graphics driver?
> >>>> Yes. I do not (yet) have a choice... can't wait for the open source drivers.
> >>> That, most probably, is the source of the problem.  Please see:
> >>> http://bugzilla.kernel.org/show_bug.cgi?id=8943
> >> I do however not agree with Andrew's conclusion, as the memory is not
> >> "used", so I wouldn't expect a memory leak. As soon as I turn swapping
> >> off everything is loaded again, and works. If there was a leak it should
> >> use the memory, shouldn't it?
> >> If the problem would be 100% reproducible I could try without, but as
> >> is, I have up to two weeks with 2-3 cycles daily (sometimes more, as I
> >> receive untraceable SERR from my PCI-E WLAN after which I do not receive
> >> interrupts any more - only a suspend/resume cycle helps...) before the
> >> problem occurs.
> >>
> >> Anyway, is there a way of unloading the module temporarily without
> >> shutting X down?
> > 
> > I don't know.
> > 
> > Can you try another version of the ATI driver?  The reporter of this bugzilla
> > entry did that and it apparently helped him:
> > http://bugzilla.kernel.org/show_bug.cgi?id=8943#c4
> 
> That driver is even more broken, produces artifacts all over the place.
> I'll rather wait for the open source work to be done and live with the
> situation.
> 
> >>>>>> A 32bit Kernel is unable to suspend/resume at all. No idea why. dmesg
> >>>>>> shows nothing, logs show nothing. Any ideas for debugging are welcome.
> >>>>> Well, that's interesting.
> >>>>>
> >>>>> Can you try in the minimal configuration (ie. boot with init=/bin/bash,
> >>>>> mount /sys, mount /proc and run "echo mem > /sys/power/disk)?
> >>>> Which? the 32bit or the 64bit?
> >>> 32-bit, but please do that without the ATI driver.
> >> Did it. As before, suspends, but when I resume, I hear the CD-ROM spin
> >> up, the backlight comes on, and nothing more. The system is a Lenovo
> >> Thinkpad T60 8744-4XG, BIOS 1.09.
> > 
> > Are you 100% sure that your 32-bit kernel configuration reflects the 64-bit
> > one?  In particular, do you have CONFIG_NO_HZ set in the 32-bit .config?
> 
> In both, not. 1000Hz timer, SMP support, hotplug CPU support are
> enabled. I attached a diff (from the 64bit to the 32bit). Maybe I'm
> missing something.

Yes.

Can you try to unset CONFIG_HIGH_RES_TIMERS in the 32-bit .config and retest,
please?

> > Also, would you be able to repeat this test with the latest -git kernel
> > (currently 2.6.23-rc7-git4)?
> 
> Not that I'd really care about the 32bit support, but someone else will.

Exactly.  Plus there are some things in the 32-bit kernel that are going to be
present in the 64-bit one in the future. ;-)

> Also, the 32bit version has problems with the SATA DVD-RW; it hangs for
> several seconds resetting the port (same kernel version, both 2.6.22.5),
> while the 64bit hasn't. Funny ;)
> Sadly, I know that 2.6.23 breaks/will break all the external modules I
> rely on. Anyway, I'll give it a shot later.

You can build it non-modular.

Greetings,
Rafael
