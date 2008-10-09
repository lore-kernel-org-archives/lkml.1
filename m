Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbYJIRxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbYJIRxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbYJIRx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:53:26 -0400
Received: from mail91.analogic.com ([208.224.220.31]:48249 "EHLO
	mail01.analogic.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754316AbYJIRxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:53:25 -0400
X-AuditID: 0a770115-a502cbb000001b04-02-48ee4513608e
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
x-originalarrivaltime: 09 Oct 2008 17:53:23.0056 (UTC) FILETIME=[EC2AB700:01C92A37]
Content-class: urn:content-classes:message
Subject: Re: Toggling GPIO at 38Khz
Date: Thu, 9 Oct 2008 13:53:22 -0400
Message-ID: <Pine.LNX.4.61.0810091350430.9446@chaos.analogic.com>
In-Reply-To: <c32efac40810081524q15b0a747oe49de0cf0a2aa2e2@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Toggling GPIO at 38Khz
Thread-Index: AckqN+w0KZ86XPolTLi6C99Iqi8yZQ==
References: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com> <3efb10970810081157s5e0f8034n63856d2da42b3ad3@mail.gmail.com> <c32efac40810081524q15b0a747oe49de0cf0a2aa2e2@mail.gmail.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Dave Hylands" <dhylands@gmail.com>
Cc: "Remy Bohmer" <linux@bohmer.net>, "Jon Smirl" <jonsmirl@gmail.com>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "lkml" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008, Dave Hylands wrote:

>>> So how do I reliably generate 38Khz without destroying latency in the
>>> system? I also don't want to measure the speed of the code I'm
>>> executing - same code has to run on 90Mhz ARM and 3Ghz Core2. If a do
>>> a loop with nanosleep() I need to know how fast my code is to subtract
>>> it's execution time form the sleep time. The existing LIRC code works
>>> this way and measures it's timing loop.
>>> hrtimers look promising, but hrtimers doesn't have a periodic API. Is
>
> The 38 kHz decoders will actually work across a range of frequencies
> usually about +/- 4 kHz.
>
> If you have a spare UART, you could configure it at 76800 baud and
> just send out an appropriate bit pattern (taking into consideration
> start bit, stop bit, parity, etc.
>
> 115200 baud might also work (3 bit times per 1/38400 of a second). It
> won't be a perfect square wave, butI think it would still work.
>
> You could also do something similar if you have a SPI interface. Just
> set the clock to the right frequency and use the bits sent out to
> generate your pulses.
>
> -- 
> Dave Hylands
> Shuswap, BC, Canada
> http://www.DaveHylands.com/

MIDI runs at 31.25 kBaud PC/AT machines do TX/RX through the
audio boards. Drivers for programming these boards are available
for Linux.

These might work fine.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4786.81 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged. Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited. If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
