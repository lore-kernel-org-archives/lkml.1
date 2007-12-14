Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbXLNUPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbXLNUPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXLNUPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:15:23 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:50423 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbXLNUPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:15:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 21:13:08 +0100
User-Agent: KMail/1.9.6
Cc: "Ingo Molnar" <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       "John Linville" <linville@tuxdriver.com>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
References: <20071213003028.676998182@mvista.com> <200712142038.58400.mb@bu3sch.de> <2c0942db0712141155n40ba60agde79e436aa5cb8f2@mail.gmail.com>
In-Reply-To: <2c0942db0712141155n40ba60agde79e436aa5cb8f2@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712142113.09119.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 20:55:43 Ray Lee wrote:
> Oh. My. God.
> 
> Michael. I have a degree in Physics. I placed sixth in the world
> finals of the ACM Collegiate programming contest in 1999, Cal Poly
> Team Gold. ( http://icpc.baylor.edu/past/icpc99/Finals/Tour/Win/Win.html
> , I'm the guy all the way to the right. ) I ported the 2.4 kernel to a
> custom ppc platform, including writing drivers for various hardware on
> it ( http://patinc.com ). I'm the guy who did all the software for a
> linux-based Voice over IP call center (
> http://broncocommunications.com/ ).

Nice. I am one of the main b43 developers and I wrote most of the code.
I know most of the code from the top of my head.
Besides that my weiner is bigger than yours. :P

> To answer your question, it requests the rfkill-input module. But
> under the version I'm trying, rfkill-input is not automatically
> loaded.

It is not an issue. You can even rmmod rfkill-input in FULL operation.
It will not disturb the operation, except that an LED stops working.
Try it! (I _did_ try it).

> I've pointed to the mailing list URL that proves that. So, I 
> loaded rfkill and rfkill-input by hand. Perhaps rfkill wasn't
> necessary, I don't know, and I don't care. But once I did that, *then
> and only then* did your damn b43 driver start printing out any
> messages to dmesg at all, which then let me download the latest
> firmware, and continue moving forward.

The b43 does print _nothing_ on modprobe. That is _correct_ behaviour.
b43 does print the firmware message after "ifconfig up".
Might it be possible that this was coincidence and you messed
with modprobe rfkill and ifconfig up and finally saw the message?

> > You are telling me that I don't understand patches that I sign off
> > and I should not take this personally?
> > That is challenging.
> 
> I'm saying the patch you signed off on has a side-effect that will fix
> my issue. And even if I *were* saying that, the most you should take

Ok. So please revert that patch and try to reproduce the breakage.
Does that work?

> from it is that you are human and sometimes may make mistakes, just

I am inhuman. We all know that.
(That was a joke that you probably don't understand. But you can google
for "bcw vs. bcm43xx" :) )

Ray, I _do_ want to understand what is going on in your machine.
I _have_ to understand it. But I currently do not understand how the
quoted patch could fix modprobe of b43 or rfkill. I'd simply call that
impossible.
Impossible because the patch does change a few function called _inside_
of the b43 module. How could that fix load of the b43 module? (Note that
we are not changing some modprobe magic like the ID table).

So could you please try to reproduce the breakage by reverting that
patch again? Just to make really sure it is this patch fixing the issue
and not just some coincidence.

Thanks for your help.

-- 
Greetings Michael.
