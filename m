Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbXLNSY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbXLNSY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXLNSYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:24:20 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:34993 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbXLNSYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:24:19 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 19:22:04 +0100
User-Agent: KMail/1.9.6
Cc: "Ingo Molnar" <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       "John Linville" <linville@tuxdriver.com>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
References: <20071213003028.676998182@mvista.com> <200712141749.33708.mb@bu3sch.de> <2c0942db0712141001l6ad77657q1dceee5cb872a979@mail.gmail.com>
In-Reply-To: <2c0942db0712141001l6ad77657q1dceee5cb872a979@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712141922.04677.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 19:01:51 Ray Lee wrote:
> No, I don't have module autoloading disabled. modprobe-ing b43
> automatically loads ssb. Neither, however, will load rfkill or
> rfkill-input. And if they aren't loaded, then b43/ssb are *completely*
> silent during load. Nothing to dmesg at all.

That is a bug in your distribution. I cannot fix this.
Maybe the module is blacklisted or whatever. This is _not_ a b43 bug.

> > This all works perfectly well on all of my systems. And I never heared
> > such a problem before.
> 
> WTF? Please read *YOUR OWN MESSAGE* to the bcm43xx-dev list:
> 
> https://lists.berlios.de/pipermail/bcm43xx-dev/2007-December/006456.html
> 
> I'm going to blame this on you being tired or something, okay? But in
> the meantime, could you *PLEASE* start giving me the benefit of the
> doubt?

The message you quote describes a _completely_ unrelated bug.
Besides that the bug described in the message does _not_ prevent
the device from working. It does _just_ prevent some random LED from
blinking. I'd not call that a big issue.
To say it again: This message was about loading "rfkill-input" _after_
b43 was loaded successfully.

Please carefully read the messages before using them to prove me wrong.

> > If you have a PCI device probing works as follows:
> > The PCI table is in ssb. So as soon as your kernel detects the PCI device
> > it will load ssb. ssb will register the PCI device. That will trigger
> > an udev event for the contained 802.11 core to get probed. This will load
> > b43.
> >
> > So, I'm not sure where's the issue with my code here.
> 
> There's a patch from Larry Finger to address this and other issues. It
> hasn't made it's way fully upstream yet. Please read your message
> here, in particular item number seven on Larry's list:
> 
> https://lists.berlios.de/pipermail/bcm43xx-dev/2007-December/006472.html

1) I sent this patch out today for inclusion in the kernel
2) This is a _completely_ unrelated issue.
   It is about "rfkill-input" being not loaded. NOT about
   "b43" or "rfkill" not being loaded.

> > If you do
> > modprobe b43
> > it will automatically load _all_ required modules.
> > It works perfectly well on my systems.
> > Try it. Simply type "modprobe b43". It will also work for you.
> 
> As I've said multiple times earlier in this thread, I did try that and
> it didn't work. Do you believe me now?

Ok, Please find out why it doesn't work.

> > > Heeeeellooooo? I tried that. It failed. What *I'm* talking about here
> > > is that this everyone needs to be aware that this is *not* a drop in
> > > replacement for bcm43xx, and if I'm having problems (not a kernel
> > > hacker, but I make my living writing code), then sheesh, you're gonna
> > > have a flood of people needing hand-holding on this.
> >
> > All problems so far were not related to the b43 sourcecode at all.
> > And I think I can not be held responsible for unrelated code or bugs
> > in the operating system scripts.
> 
> So, do you want a scorecard on this?
> 
> One problem related to b43 source code, patch exists, has yet to be
> merged upstream.

Yeah. A problem preventing a LED from blinking.
That's a real regression.... Come on. Stop that bullshit.

> One problem related to udev rules, that may or may not be fixed in the
> latest udev. I have udev version 113, which is the latest shipped in
> Ubuntu's nightly development snapshots (hardy heron). I see that
> version 117 of udev is available on kernel.org, but mine is from the
> end of June. One would think that wouldn't be so old as to be a
> complete deal breaker. Especially as bcm43xx works fine with my udev.

How can I fix that?

> With udev rules hand-edited to include the ATTRS{type}==1 Larry
> pointed out (thanks Larry), b43 also seems to create an odd extra
> device, wmaster0.

That's not b43 specific. And it is not a bug. Ignore wmaster.
It is not useful for anything from userspace.

> Same MAC as eth1, my wireless. It's just an odd 
> thing that wasn't there before with bcm43xx. May be good, may be bad,
> dunno.

Blame your distribution, please.

> And yeah, in my opinion, making the kernel play well with up-to-date
> userspace actually *is* part of your job, but then again, what do I
> know.

How the hell do I workaround broken udev scripts from within the kernel?

> Michael, you're a good guy, I believe that. You're doing unglamorous
> and mostly thankless work, and I am thankful for it. I'm afraid the
> only way I could make it glamorous is to offer to send you a fancy
> feathered outfit to wear while coding :-). But try to meet us testers
> halfway, okay? Please keep in mind that I'm really only trying to
> help.

Yeah. So PLEASE point out real bugs in MY code and do not bother
me with other peoples bugs that I simply can not fix.
In the list above there was exactly one bug for which I am responsible.
And I already sent a fix for this one.

> Now I'm going to go off, sit in the sun, sip some coffee, and think
> happy thoughts of kittens playing with yarn for a while.

Have fun.

-- 
Greetings Michael.
