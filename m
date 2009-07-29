Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZG2Mvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZG2Mvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZG2Mva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:51:30 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:29393 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZG2Mva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JmQ5YAgmGd1ga2bbEcs/5vM/LPdg61TQo6mMhNJw9yIQ6U+TSRI+iSL/SyXVxiapCc
         WDnyJZom774U8t2ATH5fGhGiR2gmXZfWIcavM+PkGkz8oy9fiEsyZDKiP8VLemY0ymCj
         MB2KBxW49nv8FuX3pyZg/5fHijS4WltyHmBXs=
MIME-Version: 1.0
In-Reply-To: <20090729124233.GA12802@rakim.wolfsonmicro.main>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
	 <4A6F033B.7030302@mnementh.co.uk>
	 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>
	 <20090729115817.GA12223@rakim.wolfsonmicro.main>
	 <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>
	 <20090729124233.GA12802@rakim.wolfsonmicro.main>
Date: Wed, 29 Jul 2009 21:51:30 +0900
Message-ID: <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>
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

On Wed, Jul 29, 2009 at 9:42 PM, Mark
Brown<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Jul 29, 2009 at 09:27:54PM +0900, Magnus Damm wrote:
>> On Wed, Jul 29, 2009 at 8:58 PM, Mark
>> Brown<broonie@opensource.wolfsonmicro.com> wrote:
>
>> > While it's true that this doesn't bother SoCs the fact that most clock
>> > API implementations don't allow any off-chip drivers to register clocks
>> > renders the clock API essentially unusable for fairly large parts of the
>
>> Yeah, clocks outside the SoC are not well supported today. From what
>> I've seen, most embedded boards come with external chips for cameras,
>> audio codecs and/or phy devices. These devices often get their clocks
>> from the main SoC. Allowing the drivers for such chips to use the
>> clock framework to register clocks for internal divisors would allow
>> driver writers to write better code which in turn would make life
>> easier for most people hacking on embedded kernels.
>
> That's not actually abundantly clear for the audio stuff, or rather the
> audio stuff would like additional features like constraint based
> configuration.

Without knowing too much about this, wouldn't camera sensors want
similar features?

>> The problem with the clock framework API is that the data structures
>> varies depending on implementation. So the ops callback structure on
>> SuperH is different compared to ARM. I suspect that adding generic
>> clocklib support across the architectures will take quite a bit of
>> time to implement propely.
>
> Indeed.  It's actually much worse than you say, each individual ARM
> architecture has its own clock API implementation of varying quality and
> of course there are architectures that don't do the clock API at all.

Yeah. This is exactly why I don't want to block on the clocklib implementation.

Cheers,

/ magnus
