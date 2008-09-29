Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYI2DsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYI2DsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 23:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYI2DsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 23:48:06 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:46919 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYI2DsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 23:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gqubvyp7EAu4/97l6pHGmd9NO8RUkvGLoTLV+cxnSZf6x9cbFyJ3A/bi3AYwsHuyFv
         v06kg0J6hisr/k2xEZjzUJgwQb3gOHFHAsTHsi0Wtm9sy4yiOQemDbOPE8DiAlH46GkT
         WHCJF6B5Dsk+/dzEJC7laY5Io4AGJxRZfVjl8=
Message-ID: <aec7e5c30809282048x3d9a201j12303091e9d93a49@mail.gmail.com>
Date: Mon, 29 Sep 2008 12:48:02 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch 2.6.27-rc7] gpiolib: request/free hooks
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200809271129.07241.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809241508.11091.david-b@pacbell.net>
	 <aec7e5c30809270800y7a4b59eem8af480d5899a791a@mail.gmail.com>
	 <200809271129.07241.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 3:29 AM, David Brownell <david-b@pacbell.net> wrote:
> On Saturday 27 September 2008, Magnus Damm wrote:
>>
>> Looking good. I'm currently hacking on some pinmuxed gpio code for
>> SuperH, and I'd like to use these request/free callbacks to select
>> proper pinmux state.
>
> I'm not so keen on that particular overloading, but I can
> understand why it might be wanted on systems which have a
> happy one-to-one mapping between GPIOs and pins.

Hm, sounds like you prefer to keep pinmuxing and GPIO code separated?

> If you do that, be ready to provide a pinmux-only interface
> at some point when this "piggybacking" breaks something...

In the SuperH case GPIO pin direction selection is done in the same
way as selecting pin function. So in and out directions can be seen as
two pin functions. And since we want to support GPIO pin direction we
may as well support setting pin functions as well.

But maybe there are better ways to integrate it, I'm not sure.

>> > --- a/drivers/gpio/gpiolib.c
>> > +++ b/drivers/gpio/gpiolib.c
>> > @@ -781,6 +785,7 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
>> >  int gpio_request(unsigned gpio, const char *label)
>> >     ...
>>
>> The code above doesn't catch double gpio_request() user calls
>> properly. Or rather, the user will receive an error but the
>> chip->request() callback may get called twice.
>>
>> What about modifying the gpiolib code to handle that? I think that
>> sounds like a better idea than cover ing that case in the chip code...
>
> Yeah.  Better to test-and-set the flag and then request, and backout
> if it fails, than the other way.  Just who wrote that crap in the
> first place?  Sigh.  (Notice it's done that way already in the code
> path handling implicit requesting ... )

Sounds good.

> I'll send an updated patch along soonish.

Thank you!

/ magnus
