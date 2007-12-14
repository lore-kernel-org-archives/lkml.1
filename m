Return-Path: <linux-kernel-owner+w=401wt.eu-S935593AbXLNBMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935593AbXLNBMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 20:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757085AbXLNBM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 20:12:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:58314 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbXLNBM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 20:12:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Y2LTKEtYf2VAesD0uzQnjePekM8Gir3buEFmLpYUjYbuqx7kkInqBDZeh87MxPlIBFd9h/CtI5QFlBGxJFAcZj2hmn8bJ5XmwRHBfMgWYPN+W3IcpBvRKrr+7OJfRY0fsM3xeMH3PsNczbRFJNOpzsVQY4IqDd5TEsX2SGxoL9k=
Message-ID: <2c0942db0712131712t6f30ab88g48cc1af27a7a6ce9@mail.gmail.com>
Date: Thu, 13 Dec 2007 17:12:25 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: bcm43xx-dev@lists.berlios.de, "Daniel Walker" <dwalker@mvista.com>,
       akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de,
       "John Linville" <linville@tuxdriver.com>
In-Reply-To: <200712140143.16451.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <200712131445.39770.mb@bu3sch.de>
	 <2c0942db0712131604m41c34da9hf3122b0603f3af96@mail.gmail.com>
	 <200712140143.16451.mb@bu3sch.de>
X-Google-Sender-Auth: b12f37ba08d1eb98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2007 4:43 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 14 December 2007 01:05:00 Ray Lee wrote:
> > Okay, I had to modprobe rfkill-input and rfkill by hand, didn't
> > realize that. Hopefully that'll be automatic soon. Regardless, upon
> > doing so, and loading ssb and b43, it sees my card, but is still not
> > fully functional. iwconfig sees:
> >
> > lo        no wireless extensions.
> > eth0      no wireless extensions.
> > tun0      no wireless extensions.
> > eth1      no wireless extensions.
> > wlan0_rename  IEEE 802.11g  ESSID:""
> >           Mode:Managed  Channel:0  Access Point: Not-Associated
> >           Tx-Power=0 dBm
> >           Retry min limit:7   RTS thr:off   Fragment thr=2346 B
> >           Link Quality:0  Signal level:0  Noise level:0
> >           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> >
> > (eth0 is ethernet, eth1 doesn't exist -- usually it's the wireless.)
> >
> > `ifconfig` doesn't see eth1 or wlan0_rename.
> >
> > What else might I be doing wrong?
>
> I don't know. Try ifconfig -a
> Or tell udev to not crap up your device names.

Uhm, I haven't had to tell udev to not crap up any of my *other*
devices, why is b43 special? I'm using an up-to-date userspace, so I'm
not going to be the only one hitting this problem. And ifconfig -a
does indeed show it, sorry about that. But my understanding is that
udev renames interfaces based on MAC address, so I wouldn't suspect
udev to be at fault here.

Digging a little farther into it, it looks like b43 is barfing partway
through init as the firmware file it's looking for has changed names.
Perhaps that's the issue. I'll take a longer look at this all
tomorrow.

> > Regardless, perhaps scheduling
> > bcm43xx for removal in 2.6.26 is a bit premature.
>
> Oh come on. b43 is more than a year old now. How long should we wait?
> Two or three? Forever?

Well, it only hit the main kernel October 10th. That means no final
point release of the kernel.org kernel has even had it included! So
testing-wise, you still haven't hit the hordes yet. Scheduling a
removal of bcm43xx (as painful as that code is [*]), seems either
premature or very optimistic. So, how about scheduling the removal
once you get a feel for the bug reports that'll come in once 2.6.24 is
released.

   [*] Yeah, even as a user the code is painful. It *still* locks my
keyboard if I happen to disable the wireless while it's scanning. The
sooner bcm43xx is dead, the better. But b43 is quite obviously not a
full replacement for everyone.

I don't mean to come off harsh, I know you put an amazing amount of
work into both b43 and bcm43xx, and I'm thankful for that. But
requiring the end-user to go scan bcm43xx-dev archives to find out
that the b43 module isn't correctly autoloading all of its
dependencies is a sign that the code still hasn't had a lot of
testing, no?

In the meantime I'll keep plugging away at trying to figure out what's wrong.

Ray
