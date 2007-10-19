Return-Path: <linux-kernel-owner+w=401wt.eu-S932249AbXJSRSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbXJSRSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762965AbXJSRSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:18:08 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:7260 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762765AbXJSRSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:18:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qDcKA+j7je0Jmk5mIbvDMJPvFiRke4CL/OUbpzYzZSNOdF2DcrZ7Y6ZrJkxPQIkFs4Y0jvoHuwBGwtSZfKt2pebksYgVPWhKxKTaIEkL+lxBUNtn9Pw0LhNiHw3GSXsn9vvMkhQml2Q/YrIInMO7HmA7aakLW/3rUCRp+W8ixUw=
Message-ID: <2c0942db0710191018n894a773mc2b0400067c0fdf@mail.gmail.com>
Date: Fri, 19 Oct 2007 10:18:04 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: PROBLEM: 2.6.23.1 Freezes on GB data transfers
Cc: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4718DB8F.3070903@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40710170420m6882ea8eg3b8e6e7db72a0cdd@mail.gmail.com>
	 <2c0942db0710190858n647192d6t270e43b2a3075320@mail.gmail.com>
	 <4718DB8F.3070903@rtr.ca>
X-Google-Sender-Auth: 2930988aa3d4d19f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/07, Mark Lord <lkml@rtr.ca> wrote:
> Ray Lee wrote:
> > On 10/17/07, Giangiacomo Mariotti <gg.mariotti@gmail.com> wrote:
> >> Linux Kernel 2.6.23.1 freezes on GB data transfers.
> >>
> >> Pc completely freezed while transferring 4Gb of data from
> >> dvd(/dev/hdc) to hd(nothing else was happening, cpu general usage at
> >> 5-6%).Except for this,it has been working flawlessly for 1 day,but
> >> when I tried to transfer 4Gb of data from the dvd to the hd,after
> >> having completed 60% of the transfer, the system became completely
> >> freezed,no keyboard,no mouse,no consoles,nothing, and the Caps Lock
> >> LED started to blink.
> >
> > The blinking Caps lock LED means that your system is Oopsing. Please
> > try your test again from a console (not from X), and see if an oops
> > message is printed out. If it is, you'll need to either copy it down
> > or take a photograph of it with a digital camera, then post the text
> > of it or post a link to the image.
>
>
> I believe this is now the forth report of blinking-leds lockup with 2.6.23.1.
>
> I wonder what's causing it?
> My system has this as well, totally random, once every day or so.
> New behaviour since 2.6.23-rc9 (I posted previously about this).

Boy, there's just not a lot between 2.6.23-rc9 and 2.6.23 proper.
There are two things that kinda pop out, but this is at best a WAG.

First, are you on x86-32 and happen to have CONFIG_HIGHPTE set?

Second is another memory thing, where in filemap_fault we now do a
page_cache_release where we didn't before, but that appears to only be
in a case where we send a sigbus, so I wouldn't expect that to be
hitting.

Everything else looks to be for uncommon hardware or relatively safe
(such as a few networking changes).

I'll hunt around for the other reports.

Ray
