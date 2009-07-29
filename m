Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZG2Csx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZG2Csx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 22:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZG2Csx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 22:48:53 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:46775 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZG2Csw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 22:48:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wwUhVjPgp0m/GoUAllI8Hbnnmt2TGRd6XlhhMSl689zh7bBTZF4L8YrLJj/QM3AHiZ
         l/bI4hjJlVyrAMo3G9M4gGmRVWMB7FsY/V0iEun1682cL5f2exPw0k4h3M+MbW7SeANt
         GmRIwHaou/0RPJ2MXnUS8ODOws5A3V8bCKJnQ=
MIME-Version: 1.0
In-Reply-To: <4A6F033B.7030302@mnementh.co.uk>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
	 <4A6F033B.7030302@mnementh.co.uk>
Date: Wed, 29 Jul 2009 11:48:51 +0900
Message-ID: <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>
Subject: Re: MMC: Make the configuration memory resource optional
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Tue, Jul 28, 2009 at 10:55 PM, Ian Molton<ian@mnementh.co.uk> wrote:
> Guennadi Liakhovetski wrote:
>>
>> Add support for tmio_mmc hardware configurations, that lack the cnf io
>> area, like SuperH SoCs. With this patch such hardware can pass a single ctl
>> io area with the platform data.
>
> NAK

That's not a very polite way to begin your email. How about "hey, hi
or good day"?

> I dont like this approach - although it involves minimal changes to the
> driver, it will leave people puzzling over why their accesses to the cnf
> registers do nothing when debugging.

Half a year ago I posted a set of tmio_mmc patches, and the MMC
maintainer kindly picked out the bug fixes and merged them. No problem
there. The feature request to allow the driver to work with a single
memory window (similar to this patch) was NAKed by you in a very
similar way.

One of the reasons for NAKing my patches at that time was that you
didn't have time to review the 100 lines of code. This time you
dislike it because "it will leave people puzzling".

> The cnf area is basically clock and power control for devices that have it.
> If I had known of the existence of other tmio devices that didnt do it that
> way when I wrote the driver, it would never have been put in there directly.
>
> The *right* way to do this is to use the clk API for clocks and provide a
> small API for power control that the driver will use, if present.

Yes, I think everyone wants to use the clock API to control clocks.

However, the clock API does not solve the issue with a single address
window. That's the issue that this patch and my earlier patches are
trying to solve. Which is the issue that you keep on ignoring.

> If people want to change the situation in TMIO re: clocks, as I have said
> before, they should start a discussion on how to adapt the clk API.  so that
> more than just the CPU can use it. This will make everyone happy all in one
> go.

Regardless of how the clock API is implemented, sooner or later the
driver needs to support a single address window if it's going to run
on such hardware. This is not exactly rocket science.

> I will happily take a patch abstracting power control from tmio-mmc,
> however.

I see it as you are blocking progress without any technical reasons.
It's basically exactly the same as half a year ago. And exactly what
has happened with clocklib in that time?

I understand that you want to have clocklib so you can manage clocks
dynamically for your mfd drivers, but in our use case we already have
working clock framework implementations withing our SoC. There is no
need for any dynamic clock registration and unregistration. With that
in mind it can't be very difficult to understand that there is no
point for SoC vendors to work on clocklib. If's mainly an issue for
mfd.

You talk about correctness in the upstream kernel and refuse to
include things because of your special view of correctness. At the
same time you suggest Guennadi and me to keep the patches local
instead of picking up the changes and merging them in your upstream
driver. This local patch suggestion does not help. If we wanted to
have local patches then we wouldn't submit things upstream.

Your role as a maintainer is to work with the community. Just NAKing
and saying you want some highlevel framework merged first is not very
constructive. I recommend you to evaluate your position in the
communtiy. Use git shortlog to compare your own contributions over
time with what Guennadi has done.

/ magnus
