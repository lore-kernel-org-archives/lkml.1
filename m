Return-Path: <linux-kernel-owner+w=401wt.eu-S1764343AbXLNTz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764343AbXLNTz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXLNTzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:55:48 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:51717 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbXLNTzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:55:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=S7FY5JICyVwKjI1rm7g8oqfg0vaIy0dz3elgnNMoa74y5RTxrzuptSjSeCwJ4uHZdCCohrGyYsJnu7G4FP/oUp8DeOW5tFyhMFvEz7BFqXNWZVx4AITLniP3dqDfWdbM4xRB/duvCwuJlvrqDvY2EEvCfGDRqPS3VoDl7ZcV7TE=
Message-ID: <2c0942db0712141155n40ba60agde79e436aa5cb8f2@mail.gmail.com>
Date: Fri, 14 Dec 2007 11:55:43 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Ingo Molnar" <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       "John Linville" <linville@tuxdriver.com>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <200712142038.58400.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <200712142005.21375.mb@bu3sch.de>
	 <2c0942db0712141125g65422bc5r83c83a2ce81cc58a@mail.gmail.com>
	 <200712142038.58400.mb@bu3sch.de>
X-Google-Sender-Auth: 815d476d972b6e53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 11:38 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 14 December 2007 20:25:39 Ray Lee wrote:
> > > I'm sorry. The patch that _you_ quoted fixes a blinking LED
> > > and nothing else.
> >
> > Well, you're wrong. Sorry, but that's just the way it is. See below.
> >
> > > It does _not_ fix loading of rfkill or b43 in any way.
> > > It does, however, fix loading of rfkill-input. But the b43 module
> > > operation does _not_ depend in any way on the rfkill-input module, except
> > > the tiny LED that doesn't blink if it's not loaded.
> > > I hope you understood now that the thread on bcm43xx-dev was NOT about
> > > your requirement to load rfkill before b43.
> >
> > *AGAIN*, please read your message here, in particular item number
> > seven on Larry's list:
> >
> > https://lists.berlios.de/pipermail/bcm43xx-dev/2007-December/006472.html
> >
> > For the last fscking time, if rfkill and rfkill-input are not loaded,
> > not one line comes out in dmesg when b43 and ssb are loaded. In
> > particular, your pretty little message about needing newer firmware
> > also does not print. So, yeah, not loading rfkill{,-input} *does*
> > cause issues with b43 working, as there's no damn way to find out
> > what's broken!
>
> Guy... .
> I KNOW what the patch above does.
> What do you think does the following line?
>         err = request_module("rfkill-input");
> Does it load the "rfkill-input" or the "rfkill" module.
> That's the million dollar question. You only have one try.

Oh. My. God.

Michael. I have a degree in Physics. I placed sixth in the world
finals of the ACM Collegiate programming contest in 1999, Cal Poly
Team Gold. ( http://icpc.baylor.edu/past/icpc99/Finals/Tour/Win/Win.html
, I'm the guy all the way to the right. ) I ported the 2.4 kernel to a
custom ppc platform, including writing drivers for various hardware on
it ( http://patinc.com ). I'm the guy who did all the software for a
linux-based Voice over IP call center (
http://broncocommunications.com/ ).

So, *now* do you believe I'm not an idiot?

To answer your question, it requests the rfkill-input module. But
under the version I'm trying, rfkill-input is not automatically
loaded. I've pointed to the mailing list URL that proves that. So, I
loaded rfkill and rfkill-input by hand. Perhaps rfkill wasn't
necessary, I don't know, and I don't care. But once I did that, *then
and only then* did your damn b43 driver start printing out any
messages to dmesg at all, which then let me download the latest
firmware, and continue moving forward.

> You are telling me that I don't understand patches that I sign off
> and I should not take this personally?
> That is challenging.

I'm saying the patch you signed off on has a side-effect that will fix
my issue. And even if I *were* saying that, the most you should take
from it is that you are human and sometimes may make mistakes, just
like the rest of us. There's nothing challenging in that statement.

I've provided the bug report as many ways as I can think to. If you
don't agree, then I guess you'll just have to get the bug report from
someone else who can figure out exactly how to sugar coat the message
so that you'll listen to it.

Me, I'm done.
