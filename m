Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbXLNQHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbXLNQHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762546AbXLNQGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:06:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:57859 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029AbXLNQGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:06:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=AST5jgW0TiAUV9Up1cTpQ8Ux8TIgbEiZSM1kUK50xXFhwUxPY7JwBQhyZFyPVzpmWYKLciuom61QxbsZRi1qp+6C7KTSmiN1jtFUcRFz10OTeazAA587/Igaepv7D8G+W3RsmwWY/WLFCX+VueUprP5o7ldwxBndqZUNdJ3F3/c=
Message-ID: <2c0942db0712140806p61ec06d5nf3289dab938fd93a@mail.gmail.com>
Date: Fri, 14 Dec 2007 08:06:39 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Ingo Molnar" <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       "John Linville" <linville@tuxdriver.com>
In-Reply-To: <200712141409.00311.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <200712141331.59410.mb@bu3sch.de> <20071214125327.GA10995@elte.hu>
	 <200712141409.00311.mb@bu3sch.de>
X-Google-Sender-Auth: c7f2793dc18465b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all. Perhaps I can inject some facts into this?

On Dec 14, 2007 5:08 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > > This user did get the following messages in dmesg:
> > >
> > > b43err(dev->wl, "Firmware file \"%s\" not found "
> > >        "or load failed.\n", path);
> > > b43err(wl, "You must go to "
> > >        "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
> > >        "and download the correct firmware (version 4).\n");
> > >
> > > I'm not sure how I can improve that even more. There is a full URL
> > > describing how to get the device workin in _full_ detail.

Yes, but only if you load rfkill-input and rfkill by hand, prior.
Without those, dmesg is entirely silent, and nothing works even to the
stage that I got it to last night. I had to search the bcm43xx-dev
archives to find that out, and it was a message from Larry saying that
he'd finally tracked down why it was working for some people and not
others -- some of us build fully modular kernels.

That I'm one of the first people to hit that makes me think that your
testing base so far has been miniscule.

Once I did that, the dmesg after loading did indeed contain the URL,
and thank you for that.

> > well i dont have this hardware, but the following description in this
> > thread seems to contradict that:
> >
> > || Well, doing an `rmmod bcm43xx ; modprobe ssb b43` gives me nothing in
> > || dmesg other than lines related to the bcm43xx driver.
> > || iwconfig/ifconfig do not see the interface either.

See above. Without a modprobe of rfkill, rfkill-input that is the case.

> Let's quote another of Ray's statements:
> "And ifconfig -a does indeed show it, sorry about that."
>
> So if he did then try to initialize that device, that clearly
> _did_ show up in a standard place where network devices are
> expected to show up, he did see the message I quoted.
> Well, what if he did not try to initialize the device by doing
> an "ifconfig wlanX up"? That can hardly be my fault, right?

Heeeeellooooo? I tried that. It failed. What *I'm* talking about here
is that this everyone needs to be aware that this is *not* a drop in
replacement for bcm43xx, and if I'm having problems (not a kernel
hacker, but I make my living writing code), then sheesh, you're gonna
have a flood of people needing hand-holding on this.

I still don't understand why bcm43xx is sane enough to create an eth1
entry, and b43 needs more handholding, but I'm going to hold off on
commenting farther on that until I download the newer firmware. As it
stands, I haven't given b43 an honest test yet.

Please keep in mind that I'm really just trying to report my issues
with the code before others hit the same thing, and trying to do this
in a way that's productive for you all. I actually do understand what
an amazing amount of effort you've poured into bcm43xx and the b43's,
and again, I am thankful. I understand that bcm43xx is effectively
dead, and it has architectural problems (locking, at minimum), that
have been a problem for at least the past two years that *I've* been
using it, probably more.

The goal here is to make sure that your shiny new code will *work* for
everyone, okay? Not to attack you, as I don't think you in any way
deserve an attack. If I come off that way, I'm sorry. But likewise, if
you could give me the benefit of the doubt, this conversation would go
a lot smoother.

Thanks.

Ray
