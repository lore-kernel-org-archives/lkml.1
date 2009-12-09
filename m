Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbZLIXkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbZLIXkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 18:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758705AbZLIXkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 18:40:04 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:36754 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758697AbZLIXkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 18:40:03 -0500
Message-ID: <4B203575.6050407@bluewatersys.com>
Date: Thu, 10 Dec 2009 12:40:37 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
References: <20091208102842.GH12264@elf.ucw.cz>	<4B1EB57D.6070408@bluewatersys.com>	<20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com>
In-Reply-To: <4B1ECEEE.3000209@bluewatersys.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Mallon wrote:
> Pavel Machek wrote:
>> Add GPIO support for HTC Dream.
>>
>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>>
>> +int register_gpio_chip(struct gpio_chip *new_gpio_chip)
>> +{

...

> 
> This is still really screwy. Why are you creating your own version of
> struct gpio_chip in addition to the one in include/asm-generic/gpio.h
> (which you also appear to include in some places). It makes the code
> extremely confusing. Other architectures use wrapper structures. Can you
> have something like this instead:
> 
> 	struct dream_gpio_chip {
> 		struct gpio_chip chip;
> 
> 		/* Dream specific bits */
> 	};
> 
> The name of this function also needs to be changed to something less
> generic since it is being exported globally.
> 
> I also think this function is doing way to much work for what it is.
> Does it really need to be this complicated?

Further to this, I think it is worth doing the work to make this gpiolib
now. Most of the other ARM chips now support gpiolib, so it would seem a
bit of a step backwards to start adding new chips which don't. I think
that adding the gpiolib support will also cleanup the mess that is
register_gpio_chip, since this is all already handled by the gpiolib core.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
