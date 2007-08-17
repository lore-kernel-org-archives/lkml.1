Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbXHQU0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbXHQU0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXHQU0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:26:36 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:16307 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbXHQU0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:26:35 -0400
X-IronPort-AV: i="4.19,277,1183348800"; 
   d="scan'208"; a="37384086:sNHT27002983"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Date: Fri, 17 Aug 2007 21:25:45 +0100
Message-ID: <600D5CB4DFD93545BF61FF01473D11AC0D87BDAD@limkexm2.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Thread-Index: AcfhCoVfmYuSSUwqRqiMqXABW/+GbwAAQokQ
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "David Brownell" <david-b@pacbell.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Bryan Wu" <bryan.wu@analog.com>, <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 17 Aug 2007 20:25:48.0452 (UTC) FILETIME=[CC2A2640:01C7E10C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: David Brownell [mailto:david-b@pacbell.net]
>
>On Friday 17 August 2007, Mike Frysinger wrote:
>> On 8/17/07, David Brownell <david-b@pacbell.net> wrote:
>> > ...
>> > Just for the record, this is an unusual way to use these calls.
>> >
>> > Other platforms completely decouple these issues from the
>> > IRQ infrastructure ... doing the pinmux and gpio claiming
>> > separately from the request_irq()/free_irq() paths, mostly
>> > as part of board setup.  Doing all of that "early":
>> >
>> >  - keeps those error returns from causing hard-to-track-down
>> >    runtime bugs;
>> >
>> >  - works always, even on platforms where a given IRQ may
>> >    appear on any of several pins/balls;
>> >
>> >  - makes it easier to cross-check against board schematics,
>> >    by keeping most board-specific setup in one source file;
>> >
>> >  - shrinks the kernel's runtime footprint;
>> >
>> >  - allows the label to be more descriptive ... describeing
>> >    exactly *which* IRQ, so that using the labels for better
>> >    diagnostics actually gives better diagnostics.
>> >
>> > Again, not "wrong"; but probably sub-optimal.  You might
>> > want to move towards earlier binding now, while Linux is
>> > still young on Blackfin and you don't have legacy code to
>> > worry about.
>>
>> in the Blackfin port, if you want to use a pin as an IRQ rather than
>> GPIO, you use the normal request_irq/free_irq API ... those functions
>> will call back into the proper GPIO/PORTMUX code so that the pin is
>> setup properly.  this is done so that code isnt duplicated across
>> files and so that we can easily detect if someone does something
>> incorrect like try to take the same pin and use it as
>> irq/gpio/whatever at the same time ...
>>
>> are you saying that other ports dont unify the backend code paths at
all
>?
>
>Some platforms try to "unify" the pin setup in the boot loader.
>Most of them cope with bogus bootloaders by doing it in the board
>setup code.
>
>I don't know of any who try to do it "late" as you summarized.
>
>See above why "late" unification is not necessarily as good as
>"early" unification.
>
>And then there's the OMAP1 example, where for example you might
>know that you want MPUIO-0 but that's insufficient to tell whether
>you must mux ball F18 or R13 ... so it's impossible to do the kind
>of "late" unification done here, and pinmux *MUST* be separate from
>IRQ setup.

Dave,

We are not talking about PIN routing. One physical PIN/BALL can only
have one dedicated function the same time. It's more about telling about
possible conflicts, on a development board level.

What Mike wants to point out is that a external IRQ is first a GPIO and
needs to be configured like an INPUT GPIO and then a specific bit needs
to be set unmask it as IRQ.

So why not use the GPIO infrastructure to setup this pin as GPIO?

-Michael  

  


>
>- Dave
