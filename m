Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbZE1WdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbZE1WdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZE1Wc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:32:59 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:37316 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZE1Wc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <20090528103745.GA19523@sirena.org.uk>
References: <20090527234801.GP6805@pengutronix.de> <4A1DD3A0.3010501@freescale.com> 
	<20090528000707.GR6805@pengutronix.de> <20090527.171525.204909140.davem@davemloft.net> 
	<20090528103745.GA19523@sirena.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 28 May 2009 16:32:40 -0600
Message-ID: <fa686aa40905281532l76996593ocdc36760eb468e04@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Miller <davem@davemloft.net>, r.schwebel@pengutronix.de,
       scottwood@freescale.com, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       yuan-bo.ye@motorola.com, timur@freescale.com, rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 4:37 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, May 27, 2009 at 05:15:25PM -0700, David Miller wrote:
>> From: Robert Schwebel <r.schwebel@pengutronix.de>
>
>> > It works badly for corner cases, and embedded land is full
>> > of it. The effort to get the oftree stuff right is often more than a
>> > magnitude of order higher than the effort for the actual functionality.
>> > That should be an alarm sign that something is wrong.
>
>> And here you speak about the negatives purely in generalities that
>> cannot be discussed concretely.
>
>> And, sadly, I think this is on purpose.
>
> A concrete example that was mentioned elsewhere in the thread is audio
> subsystems.  The audio subsystem for an embedded system will contain
> multiple chips - a mobile phone could have the CPU, an audio CODEC,
> bluetooth and GSM for example.  These will be interconnected by a
> combination of analogue and digital links.  The digital links consist of
> six wires (data, sync clock and bit clock for each of transmit and
> recieve), some of which may be tied together in hardware.  Some of these
> links may be shared either with switches or using TDM.  The devices will
> also have master clocks from various sources and will often have PLLs or
> FLLs able to generate clocks if the inputs aren't directly usable.  Each
> clock domain within the audio subsystem will need some level of
> synchronisation of the clocks and there may be multiple clock domains
> within the system.
>
> In principle we could describe the links between the devices, provide
> some additional use case based constraints then take this information
> and figure out a suitable runtime configuration automatically; this is
> probably the only viable OS neutral way of doing things.  In practice
> we're nowhere near having a clock framework which is able to support
> implementing this.
>
> The current approach is to write custom code that knows a suitable way
> to set things up in a given system (which is a much more tractable
> problem).  The PowerPC people have mostly accepted using this approach
> but they're really not happy with it and it's been difficult to get the
> general community understanding that it's hard to cope with this in the
> device tree.

I should clarify my position.  I want to make sure the simple things
are described in the device tree and have a generic block of code in
the kernel that can wire them up (the whole simple-of thing is a hacky
and half-assed example of this).  However, when it comes to complex
configurations that cannot be easily described, I'm all for using
platform specific code.

In fact, I may have been premature in pursuing the generic description
and generic fabric driver approach for the MPC5200 audio driver.  It
may have been better to get a few similar MPC5200 boards under our
belt before trying to identifying the common cases.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
