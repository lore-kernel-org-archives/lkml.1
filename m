Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZG2M1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZG2M1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZG2M1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:27:55 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:17426 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbZG2M1y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:27:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E0ZHdEZJ+dxDcN7bQ9sceB8zSzZCTkTm5BQIgvuI2qNmMpRbrHus79OEeISs76NyVt
         ftP/26bmE/+wyhWpg5XDkHEfk480W9zJ26oA+pNepYV8hgnmg3YzjOpp9JWybM+ZGjCU
         LmSktC7gcEMOZ77SjfsdL3VqhS5PaopYN6Fgs=
MIME-Version: 1.0
In-Reply-To: <20090729115817.GA12223@rakim.wolfsonmicro.main>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
	 <4A6F033B.7030302@mnementh.co.uk>
	 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>
	 <20090729115817.GA12223@rakim.wolfsonmicro.main>
Date: Wed, 29 Jul 2009 21:27:54 +0900
Message-ID: <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>
Subject: Re: MMC: Make the configuration memory resource optional
From: Magnus Damm <magnus.damm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ian Molton <ian@mnementh.co.uk>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 8:58 PM, Mark
Brown<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Jul 29, 2009 at 11:48:51AM +0900, Magnus Damm wrote:
>
>> I understand that you want to have clocklib so you can manage clocks
>> dynamically for your mfd drivers, but in our use case we already have
>> working clock framework implementations withing our SoC. There is no
>> need for any dynamic clock registration and unregistration. With that
>> in mind it can't be very difficult to understand that there is no
>> point for SoC vendors to work on clocklib. If's mainly an issue for
>> mfd.
>
> While it's true that this doesn't bother SoCs the fact that most clock
> API implementations don't allow any off-chip drivers to register clocks
> renders the clock API essentially unusable for fairly large parts of the
> kernel.  This is especially problematic where the clocks cross from
> the SoC domain to the off-SoC domain and clocks from each domain may be
> used interchangably.

Yeah, clocks outside the SoC are not well supported today. From what
I've seen, most embedded boards come with external chips for cameras,
audio codecs and/or phy devices. These devices often get their clocks
from the main SoC. Allowing the drivers for such chips to use the
clock framework to register clocks for internal divisors would allow
driver writers to write better code which in turn would make life
easier for most people hacking on embedded kernels.

So I'm all for working towards allowing off-chip drivers to register
and unregister clocks.

The problem with the clock framework API is that the data structures
varies depending on implementation. So the ops callback structure on
SuperH is different compared to ARM. I suspect that adding generic
clocklib support across the architectures will take quite a bit of
time to implement propely.

> Looking at the original patch I'm not sure exactly why it runs into
> clock API issues so I'm not sure if this is a relevant concern or not
> here but I'm mentioning it since I'd kind of expect an impact on the
> SoCs from addressing it due to the way the clock API functions are
> currently provided.

In my opinion this patch has nothing to do with the clock framework.

But fixing up clocklib properly would certainly be beneficial for
everyone. Holding the driver hostage until clocklib is upstream
however, that's just silly.

Cheers,

/ magnus
