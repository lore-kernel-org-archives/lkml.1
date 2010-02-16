Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab0BPSMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 13:12:40 -0500
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:43682 "HELO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933057Ab0BPSMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 13:12:38 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PWM PATCH 2/5] Emulates PWM hardware using a high-resolution timer and a GPIO pin
Date: Tue, 16 Feb 2010 13:12:23 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190902153826@mi8nycmail19.Mi8.com>
In-Reply-To: <4B758153.2060209@billgatliff.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PWM PATCH 2/5] Emulates PWM hardware using a high-resolution timer and a GPIO pin
Thread-Index: AcqsACiyaY4FTyPSTXCdxp8updY7WADMiQ4g
References: <cover.1265094517.git.bgat@billgatliff.com> <2d73f9b2fd175fd3e482920baebcd3028206f02e.1265094517.git.bgat@billgatliff.com> <20100211200702.GB1487@ucw.cz> <4B746A02.9060306@billgatliff.com> <BD79186B4FD85F4B8E60E381CAEE190902153515@mi8nycmail19.Mi8.com> <4B758153.2060209@billgatliff.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Bill Gatliff" <bgat@billgatliff.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, <linux-embedded@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Feb 2010 18:12:24.0201 (UTC) FILETIME=[96D1DF90:01CAAF33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 12, 2010 9:27 AM, Bill Gatliff wrote:
> H Hartley Sweeten wrote:
>>
>> FWIW, the gpiolib API will accept any non-zero value to "set" a gpio pin
>> and a zero value to "clear" the pin.
>>   
>
> It makes me sort of cringe to say this, but I'm going to assume that the
> API is intended to work that way so that I can take advantage of it. 
> But I'd love to someday have the reassurance that gpiolib really *is*
> intended to work that way (might be a bad idea though, see below).  Call
> me paranoid, but I've lost a lot of hair over the years undoing the
> damage of similar failed assumptions.
>
> I've found the Linux kernel code to be refreshingly forgiving of such
> things, however, so I'm willing to risk it this time.  :)
>
>> For that matter, some of the gpiolib drivers end up returning the bit
>> position mask for a given gpio pin and not 1 or 0.  For instance if the
>> gpio pin in question is bit 6 in an 8-bit register and it is set, a
>> __gpio_get_value will end up returning 0x40 and not '1'.
>>   
>
> Who's to say that gpios should always be boolean?  On the output side, a
> "gpio" that's four bits wide might be a useful way of dealing with bar
> graphs, seven-segment displays, etc. (but more specialized abstractions
> might be more appropriate, of course).

I think the original intention of gpiolib was to deal with individual pins.

> A two-bit "gpio" input might make it easier to deal with rotary encoders.

True.  But a two-bit "gpio" is no longer a "pin" it's now a "port".

I have been messing with a "port" extension for gpiolib but it's not even
close to being mergable yet.  But, that's a different topic...

> But for now, GPIOs are assumed to be booleans and that's why I'm
> hesitant to feed the API non-boolean values.  Someday, those values
> might mean something subtly but disastrously different.  And given my
> luck lately with such things...

True.  As such just use ! and !! to make the values boolean.

gpio is bit 6
val = 0x40 -> !(0x40) = 0
val = 0x40 -> !!(0x40) = 1

Just my .02... Regards,
Hartley
