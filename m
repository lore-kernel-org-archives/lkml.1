Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab0BLQ0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:26:42 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:46431 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab0BLQ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:26:41 -0500
Message-ID: <4B758153.2060209@billgatliff.com>
Date: Fri, 12 Feb 2010 10:26:59 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Pavel Machek <pavel@ucw.cz>, linux-embedded@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 2/5] Emulates PWM hardware using a high-resolution
 timer and a GPIO pin
References: <cover.1265094517.git.bgat@billgatliff.com> <2d73f9b2fd175fd3e482920baebcd3028206f02e.1265094517.git.bgat@billgatliff.com> <20100211200702.GB1487@ucw.cz> <4B746A02.9060306@billgatliff.com> <BD79186B4FD85F4B8E60E381CAEE190902153515@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190902153515@mi8nycmail19.Mi8.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
>
> FWIW, the gpiolib API will accept any non-zero value to "set" a gpio pin
> and a zero value to "clear" the pin.
>   

It makes me sort of cringe to say this, but I'm going to assume that the
API is intended to work that way so that I can take advantage of it. 
But I'd love to someday have the reassurance that gpiolib really *is*
intended to work that way (might be a bad idea though, see below).  Call
me paranoid, but I've lost a lot of hair over the years undoing the
damage of similar failed assumptions.

I've found the Linux kernel code to be refreshingly forgiving of such
things, however, so I'm willing to risk it this time.  :)

> For that matter, some of the gpiolib drivers end up returning the bit
> position mask for a given gpio pin and not 1 or 0.  For instance if the
> gpio pin in question is bit 6 in an 8-bit register and it is set, a
> __gpio_get_value will end up returning 0x40 and not '1'.
>   

Who's to say that gpios should always be boolean?  On the output side, a
"gpio" that's four bits wide might be a useful way of dealing with bar
graphs, seven-segment displays, etc. (but more specialized abstractions
might be more appropriate, of course).

A two-bit "gpio" input might make it easier to deal with rotary encoders.

But for now, GPIOs are assumed to be booleans and that's why I'm
hesitant to feed the API non-boolean values.  Someday, those values
might mean something subtly but disastrously different.  And given my
luck lately with such things...


b.g.

-- 
Bill Gatliff
Embedded systems training and consulting
http://billgatliff.com
bgat@billgatliff.com

