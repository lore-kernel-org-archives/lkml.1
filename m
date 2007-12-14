Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbXLNSCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbXLNSCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXLNSBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:01:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:38980 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbXLNSBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PIpKmY2tOtaymSceMDkYTdmaTTE2T26wEy7NPl4OG0tV9LIOhW45pdCK5rIr5/Pl5vU0sRJyIXwtmvVuAPTyRqKCo17O4EzEobexWdfAEoK00g0NphkPRYWiw860fUBAd3Anix+amhrLm20t3bgI4tMHZaJ8rh6rZMeh3nYSIGo=
Message-ID: <2c0942db0712141001l6ad77657q1dceee5cb872a979@mail.gmail.com>
Date: Fri, 14 Dec 2007 10:01:51 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Ingo Molnar" <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       "John Linville" <linville@tuxdriver.com>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <200712141749.33708.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <200712141409.00311.mb@bu3sch.de>
	 <2c0942db0712140806p61ec06d5nf3289dab938fd93a@mail.gmail.com>
	 <200712141749.33708.mb@bu3sch.de>
X-Google-Sender-Auth: 4ebe2a0626997f76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 8:49 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 14 December 2007 17:06:39 Ray Lee wrote:
> > Hi all. Perhaps I can inject some facts into this?
> >
> > On Dec 14, 2007 5:08 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > > > > This user did get the following messages in dmesg:
> > > > >
> > > > > b43err(dev->wl, "Firmware file \"%s\" not found "
> > > > >        "or load failed.\n", path);
> > > > > b43err(wl, "You must go to "
> > > > >        "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
> > > > >        "and download the correct firmware (version 4).\n");
> > > > >
> > > > > I'm not sure how I can improve that even more. There is a full URL
> > > > > describing how to get the device workin in _full_ detail.
> >
> > Yes, but only if you load rfkill-input and rfkill by hand, prior.
>
> I'm not sure what you are doing there.
> Do you have module autoloading disabled?

No, I don't have module autoloading disabled. modprobe-ing b43
automatically loads ssb. Neither, however, will load rfkill or
rfkill-input. And if they aren't loaded, then b43/ssb are *completely*
silent during load. Nothing to dmesg at all.

> This all works perfectly well on all of my systems. And I never heared
> such a problem before.

WTF? Please read *YOUR OWN MESSAGE* to the bcm43xx-dev list:

https://lists.berlios.de/pipermail/bcm43xx-dev/2007-December/006456.html

I'm going to blame this on you being tired or something, okay? But in
the meantime, could you *PLEASE* start giving me the benefit of the
doubt?

> If you have a PCI device probing works as follows:
> The PCI table is in ssb. So as soon as your kernel detects the PCI device
> it will load ssb. ssb will register the PCI device. That will trigger
> an udev event for the contained 802.11 core to get probed. This will load
> b43.
>
> So, I'm not sure where's the issue with my code here.

There's a patch from Larry Finger to address this and other issues. It
hasn't made it's way fully upstream yet. Please read your message
here, in particular item number seven on Larry's list:

https://lists.berlios.de/pipermail/bcm43xx-dev/2007-December/006472.html

> > That I'm one of the first people to hit that makes me think that your
> > testing base so far has been miniscule.
>
> The driver is shipped by Fedora since quite some time.

<shrug> Well, then they've made changes to udev or something else to
make this work okay for mere mortals such as myself, and haven't
pushed those changes upstream so that others can benefit from it.

> > > > || Well, doing an `rmmod bcm43xx ; modprobe ssb b43` gives me nothing in
> > > > || dmesg other than lines related to the bcm43xx driver.
> > > > || iwconfig/ifconfig do not see the interface either.
> >
> > See above. Without a modprobe of rfkill, rfkill-input that is the case.
>
> You can't do
> modprobe ssb b43
> This will be interpreted as modprobe of "ssb" with the module
> parameter "b43". At least by my modutils.

Yes, I know. I'm sorry I was unclear.

> If you do
> modprobe b43
> it will automatically load _all_ required modules.
> It works perfectly well on my systems.
> Try it. Simply type "modprobe b43". It will also work for you.

As I've said multiple times earlier in this thread, I did try that and
it didn't work. Do you believe me now?

> > Heeeeellooooo? I tried that. It failed. What *I'm* talking about here
> > is that this everyone needs to be aware that this is *not* a drop in
> > replacement for bcm43xx, and if I'm having problems (not a kernel
> > hacker, but I make my living writing code), then sheesh, you're gonna
> > have a flood of people needing hand-holding on this.
>
> All problems so far were not related to the b43 sourcecode at all.
> And I think I can not be held responsible for unrelated code or bugs
> in the operating system scripts.

So, do you want a scorecard on this?

One problem related to b43 source code, patch exists, has yet to be
merged upstream.

One problem related to udev rules, that may or may not be fixed in the
latest udev. I have udev version 113, which is the latest shipped in
Ubuntu's nightly development snapshots (hardy heron). I see that
version 117 of udev is available on kernel.org, but mine is from the
end of June. One would think that wouldn't be so old as to be a
complete deal breaker. Especially as bcm43xx works fine with my udev.

The b43 code requires the latest firmware, something that isn't quite
obvious from skimming the changelogs. But is in dmesg, so thanks for
that.

With udev rules hand-edited to include the ATTRS{type}==1 Larry
pointed out (thanks Larry), b43 also seems to create an odd extra
device, wmaster0. Same MAC as eth1, my wireless. It's just an odd
thing that wasn't there before with bcm43xx. May be good, may be bad,
dunno.

And yeah, in my opinion, making the kernel play well with up-to-date
userspace actually *is* part of your job, but then again, what do I
know.

Michael, you're a good guy, I believe that. You're doing unglamorous
and mostly thankless work, and I am thankful for it. I'm afraid the
only way I could make it glamorous is to offer to send you a fancy
feathered outfit to wear while coding :-). But try to meet us testers
halfway, okay? Please keep in mind that I'm really only trying to
help.

Now I'm going to go off, sit in the sun, sip some coffee, and think
happy thoughts of kittens playing with yarn for a while.

Ray
