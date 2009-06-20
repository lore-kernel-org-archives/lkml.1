Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZFTKUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZFTKUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 06:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbZFTKUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 06:20:23 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:40472 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZFTKUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 06:20:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EdCjyq7TTfrMIjigYcE7qJbPQ1tABwS4uLNIRW6WetLYreHCm67pDt7wiMQtThGuEC
         AsGHKBtVhTCxPezwPnBnbdKnMwzNME9N009auGUWh+kp0Ztc+vq8+SBa+t8e9Pp/8WJm
         cCO5Zq+vOwW8yHe+ghRuGiOp+WhI+6jV3o/FI=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
In-Reply-To: <20090612202334.62c032ac@mycelium.queued.net>
References: <20090610001033.27b7f69f@mycelium.queued.net>
	 <17be05570906111152j3ecb0102qfd6f53221c7ae9f9@mail.gmail.com>
	 <20090611160059.6d70f54a@mycelium.queued.net>
	 <17be05570906111311s717f126cyd4edf0847b839eef@mail.gmail.com>
	 <20090611172850.6c418b1d@mycelium.queued.net>
	 <17be05570906111435p3d4dfb52p67669e8a82a1ab56@mail.gmail.com>
	 <20090612202334.62c032ac@mycelium.queued.net>
Date: Sat, 20 Jun 2009 12:20:23 +0200
X-Google-Sender-Auth: 92a5443eaa77113c
Message-ID: <17be05570906200320t5be9393areaa39c7332d381bc@mail.gmail.com>
Subject: Re: [PATCH 1/2] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver 
	support
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: akpm@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>,
       deepak@laptop.org, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       jordan@cosmicpenguin.net, cjb@laptop.org,
       David Brownell <david-b@pacbell.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/13 Andres Salomon <dilinger@collabora.co.uk>:
> On Thu, 11 Jun 2009 23:35:55 +0200
> Tobias Müller <Tobias_Mueller@twam.info> wrote:
>
>> >> /**
>> >> * Some GPIO pins
>> >> *  31-29,23 : reserved (always mask out)
>> >> *  28       : Power Button
>> >> *  26       : PME#
>> >> *  22-16    : LPC
>> >> *  14,15    : SMBus
>> >> *  9,8      : UART1
>> >> *  7        : PCI INTB
>> >> *  3,4      : UART2/DDC
>> >> *  2        : IDE_IRQ0
>> >> *  1        : AC_BEEP
>> >> *  0        : PCI INTA
>> >> *
>> >> * If a mask was not specified, be conservative and only allow:
>> >> *  1,2,5,6,10-13,24,25,27
>> >> */
>> >>
>> >> I'll add this in my patch to clear it out.
>> >>
>> >
>> > But why are you being conservative in the first place?  If
>> > something's using GPIOs, unless they're unmapped, you should allow
>> > it to use them without requiring a boot arg.
>> >
>> > For example, OLPC uses GPIO 7 for its DCON IRQ.  With the masking
>> > scheme, OLPC will need to set that mask from the default.  I don't
>> > see the point of having the mask at all if other drivers in the
>> > kernel are going to be requesting GPIOs (presumably they know what
>> > they're doing).
>> Hmm... OK, this makes sense. So default mask allow everything exept
>> reserved pins and pin 28 (power button).
>>
>> I think the mask is quite useful if you've critical things on GPIO
>> pins and they should be changeable (especially from userspace and when
>> non-root users are allowed to use userspace gpio).
>
> I agree that it would be useful for userspace, just not for
> kernelspace.  Is there a way that you can have it only enforce the
> mask if the request is coming from userspace?

I didn't find a way to find out if a request is coming from userspace, so at
the moment I think it's only possible to set it global.
