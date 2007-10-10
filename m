Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbXJJMG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbXJJMG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 08:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbXJJMGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 08:06:21 -0400
Received: from spirit.analogic.com ([204.178.40.4]:2577 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbXJJMGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 08:06:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 10 Oct 2007 12:06:06.0939 (UTC) FILETIME=[F018D2B0:01C80B35]
Content-class: urn:content-classes:message
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
Date: Wed, 10 Oct 2007 08:05:56 -0400
Message-ID: <Pine.LNX.4.61.0710100746020.16644@chaos.analogic.com>
In-Reply-To: <m34pgzdii7.fsf@maximus.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
Thread-Index: AcgLNfAiFrCm5/DtQGqdIwzYDm+rFQ==
References: <4706822D.4070509@freescale.com><Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr><470691EB.7020209@freescale.com><AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk><4706A842.9030507@freescale.com><20071009174623.GC4003@csclub.uwaterloo.ca><470BC0D5.70305@freescale.com> <m3fy0kcec4.fsf@maximus.localdomain><470BD266.8020302@goop.org> <m33awkcc2j.fsf@maximus.localdomain><470BF566.6010204@goop.org> <m34pgzdii7.fsf@maximus.localdomain>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Timur Tabi" <timur@freescale.com>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Anton Altaparmakov" <aia21@cam.ac.uk>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Oct 2007, Krzysztof Halasa wrote:

> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>> but the gist is that IBM has
>> traditionally bit 0 for MSB and x for LSB.  It's a pain to work with:
>> for one, bits in the same place in a word (say, control register) are
>> renumbered in 32 vs 64.
>
> I wasn't aware of that, but it doesn't really change the bit order,
> only bit names (numbers actually). Extremely weird BTW but I guess
> these things weren't that obvious to everyone some 50 years ago.
>
>> And I've worked on at least one piece of
>> hardware in which the hardware designer had a brain-fart and first board
>> had bit 0 on the CPU wired to bit 0 on the northbridge - should have
>> been 31 -> 0, 30 -> 1, etc...
>
> I suspect the board wasn't able to run any OS, was it? :-)
> Would make a real example of the different order of bits, though.
> -- 
> Krzysztof Halasa
> -

There are several chips in which bit 0 is the MSB. For instance,
a National Instruments chip used to interface with a GPIB bus,
TNT--something.

Nevertheless, if I write 0x12 to an 8-bit read/write register,
I will read back 0x12, and if I write 0x1234 to an 16-bit
read/write register, I will read back 0x1234. Regardless
of any endian. So, even though the internal 'value' seem
by the chip might not actually be 0x1234, for bit-mapped
registers it doesn't care because you define the function
of each bit.

The only time one would care is if one was setting a
particular value to a divisor of a timer or something
that needed a particular binary value, rather than bits.
In many cases, the value isn't 'pure' anyway. It might
be in BCD or offset-binary or some other perversion
that requires manipulation anyway so, again it is
important --only to the extent the resulting "number"
seen by the chip needs to be correct.

It is instructive to note that RAM is just a bunch
of bits that are uniquely addressable. Often the CPU
can't address one individual bit, but the interface
hardware does and, in particular, modern RAM makes
sure that bits that are adjacent in words are never
adjacent in the physical devices. This is so that
ECC has a chance of working! A nuclear event that
might upset a bit will 'splash' across an area,
upsetting many bits. If they all belonged to the
same few words, the single-bit correction wouldn't
work. The idea in the architecture it to have
nuclear events cause single-bit errors only, so
the bits of a word are never adjacent in physical
space.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
