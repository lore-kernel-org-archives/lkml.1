Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZG2KY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZG2KY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 06:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZG2KY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 06:24:29 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:40846 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZG2KY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 06:24:28 -0400
Message-ID: <4A702350.8080609@mnementh.co.uk>
Date: Wed, 29 Jul 2009 11:24:16 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>	 <4A6F033B.7030302@mnementh.co.uk> <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>
In-Reply-To: <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:
> Hi Ian,
> 
> That's not a very polite way to begin your email. How about "hey, hi
> or good day"?

Hey, hi, good day.

I dont think I wrote anything impolite and NAK is commonly used on 
kernel mailinglists as simply the opposite of Ack. Please stick to the 
technical issues.

> Half a year ago I posted a set of tmio_mmc patches, and the MMC
> maintainer kindly picked out the bug fixes and merged them.

Yes, I remember acking some patches around then.

> The feature request to allow the driver to work with a single
> memory window (similar to this patch) was NAKed by you in a very
> similar way.
> 
> One of the reasons for NAKing my patches at that time was that you
> didn't have time to review the 100 lines of code. This time you
> dislike it because "it will leave people puzzling".

Just to be clear,  I did later review the code, and I didnt like the 
implementation. I'm reasonably sure I said so then, too.

So, on to the present day:

>> The *right* way to do this is to use the clk API for clocks and provide a
>> small API for power control that the driver will use, if present.
> 
> Yes, I think everyone wants to use the clock API to control clocks.

Good. Talk to Dmitry about his clock API patches. Find out why they 
didnt go upstream. I already said I will help with this. I helped get 
the MFD core code merged in the same way. Just stop writing patches that 
avoid doing this properly.

> However, the clock API does not solve the issue with a single address
> window. That's the issue that this patch and my earlier patches are
> trying to solve. Which is the issue that you keep on ignoring.

No, it doesnt. it solves _half_ that problem. The other half would be 
solved by a patch (which I will happily review / modify / apply) that 
removes power switching from the tmio driver.

So now you have a choice of two areas to work on.

> Regardless of how the clock API is implemented, sooner or later the
> driver needs to support a single address window if it's going to run
> on such hardware. This is not exactly rocket science.

Try not to be insulting. And  this is exactly the reason why I wrote:

>> I will happily take a patch abstracting power control from tmio-mmc,
>> however.

Which is your other 'problem' regarging the second address window.

Once both clocks and power switching are implemented properly, the cnf 
window will dissapear completely from the driver. In the case of TCxx 
and t7lx devices, it'll move to the MFD core. For others, it'll move to 
the platform code, but it _will_ just work.

> I see it as you are blocking progress without any technical reasons.

That you choose to ignore my reasons does not invalidate them.

> It's basically exactly the same as half a year ago. And exactly what
> has happened with clocklib in that time?

How have you helped get the clocklib patches merged during that time?

> I understand that you want to have clocklib so you can manage clocks
> dynamically for your mfd drivers, but in our use case we already have
> working clock framework implementations withing our SoC.

Well, unluckily for you, the driver was written prior to my having any 
knowledge of your SoC. At the time, I thought all tmio devices had a cnf 
area. Im not going to rip the code out (thus breaking 3 devices and 6 
platforms) and I'm not going to apply band-aids because I *know* that if 
I do that it'll be the last anyone hears on the matter and clocklib will 
  never be patched to support this case.

> There is no
> need for any dynamic clock registration and unregistration. With that
> in mind it can't be very difficult to understand that there is no
> point for SoC vendors to work on clocklib. If's mainly an issue for
> mfd.

I dont care who *you* think should do the work. If you want to change 
it, then _do_ something.

> You talk about correctness in the upstream kernel and refuse to
> include things because of your special view of correctness.

The code there now is correct for the hardware it handles. You want it 
to handle new hardware in a way that is a hack and will never be fixed up.

> At the
> same time you suggest Guennadi and me to keep the patches local
> instead of picking up the changes and merging them in your upstream
> driver. This local patch suggestion does not help. If we wanted to
> have local patches then we wouldn't submit things upstream.

I've wanted to submit things upstream before that upstream felt should 
be done another way. Oddly enough, I ended up rewriting them 9 times out 
of 10. Your patches are small, and wont go stale quickly. Which leaves 
you with:

* working hardware.
* time to do it properly.

> Your role as a maintainer is to work with the community. Just NAKing
> and saying you want some highlevel framework merged first is not very
> constructive.

Clocklib is already merged. It needs modifying.

> I recommend you to evaluate your position in the
> communtiy. Use git shortlog to compare your own contributions over
> time with what Guennadi has done.

Im not going to enter a pissing contest over this.

I've made clear the path I'd like people to take if they want to remove 
the second io area from the driver 6 months ago. I've now  seen about 4 
different approaches to doing it as a hack. If the same effort had been 
put into doing it properly, we wouldnt be having this 'discussion'.

-Ian
