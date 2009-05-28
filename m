Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbZE1DQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbZE1DQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZE1DQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:16:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:35527 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbZE1DQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:16:38 -0400
MIME-Version: 1.0
In-Reply-To: <20090527234801.GP6805@pengutronix.de>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> 
	<ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<20090527150527.GK6805@pengutronix.de> <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com> 
	<20090527162000.GM6805@pengutronix.de> <fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com> 
	<20090527234801.GP6805@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 May 2009 21:16:19 -0600
Message-ID: <fa686aa40905272016i69d8e762v186943ac4121038a@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Timur Tabi <timur@freescale.com>, Janboe Ye <yuan-bo.ye@motorola.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 5:48 PM, Robert Schwebel
<r.schwebel@pengutronix.de> wrote:
> On Wed, May 27, 2009 at 02:35:11PM -0600, Grant Likely wrote:
>> > Unfortunately, it is an incomplete data structure regarding to what
>> > the kernel needs.
>>
>> I don't follow your argument. It's a data structure that uniquely
>> describes your hardware in a way which encourages the most code reuse
>> possible; but is still independent of kernel internal implementation.
>> ie. a FDT blob should be usable not just by Linux, but also by BSD or
>> any of the other OS options. It is not an attempt to eliminate
>> platform specific code; just to reduce it as much as possible. Weird,
>> harry, non-standard stuff probably still needs board specific code to
>> handle.
>
> The oftree by design wants to be a complete hardware description. As you
> mention above, there are cases where you *nevertheless* need ad-hoc
> information about things *not* encoded into the device tree.

That is an oversimplified characterization.  Of course the device tree
is striving to be a complete hardware description; but it cannot and
should not describe everything.  The goal is to make common stuff
common, and still have a mechanism to identify the corner cases.  For
example, most serial ports are described with a single node with
'compatible = "ns16550"' and 'reg', 'interrupts', 'current-speed' and
'clock-frequency' properties to describe the configuration.  This is a
common idiom which doesn't require any additional platform specific
code.  However, for a one-off board specific device which doesn't have
any kind of common description would probably be described simply as:

        data-capture@[address] {
                compatible = "<manufacturer>,<custom-daq-device-name>;
                reg = < [address] [size] >;
                interrupts = < [irq-number] [irq-sense] >;
        }

It it would be assumed that the device driver knows the details about
how the device is wired up.

So, no it does not eliminate platform specific code in all cases
(although I would argue most cases), but it does significantly reduce
it.

> This renders the whole concept ad absurdum. You need a machine number
> again - and if you need that: why not stay with the ARM model, define
> everything with platform data and avoid the whole thing?

That is not the problem being addressed.  It doesn't address
multiplatform kernels, it does not address the duplicate code issue,
and it doesn't address the reduced effort required of board ports.

> Regarding the multi OS argument: I consider it impossible that people
> agree on all micro details of a hardware decision. Will it really be
> possible to get a common agreement about let's say Russell's SMSC
> example between all these people? Remember: if we forget (or don't agree
> on) one single aspect which a driver developer *needs*, he will have to
> work around it -> machine number land.

Even assuming that you are correct; there is greater pressure when
using the device tree to make things work together because it means
less code to maintain.

> My impression is that oftree only works in a perfect world. But we don't
> have one, so the fundamental design decision is broken.

I disagree.  For the things that do work (and there are a lot of them)
it is a net win, and for the corner cases which do not, the mechanism
allows for the ability to handle exceptions at the
platform-support-code level (not at the device driver level).  That's
why I like the device tree model.  It acknowledges that the data
structure will never be perfect and provides the ability to deal with
it gracefully.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
