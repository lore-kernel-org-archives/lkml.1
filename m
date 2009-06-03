Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbZFCPiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbZFCPiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbZFCPif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:38:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:44623 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589AbZFCPie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vcLO8A8YnGK6UlAlBcF0WiUMsQo6SERiJ4vWX8fAekROZFiLuTqeEd0QYTbE3fTJC2
         Ad8G9ah9R9AeuJGj0wFCKlsNpGenAuk+4B1kvxUtCPyoBPkuB+dW0EgQgRMcw9XfcZL2
         I8wRfFS/0doRBuz3aDZZJB6IZyUbJ3zlGNNXc=
MIME-Version: 1.0
In-Reply-To: <20090603132217.GA18353@oksana.dev.rtsoft.ru>
References: <4A255B21.8040002@gersys.de>
	 <20090602171527.GA8745@oksana.dev.rtsoft.ru>
	 <4A266FB2.2040902@gersys.de>
	 <20090603132217.GA18353@oksana.dev.rtsoft.ru>
Date: Wed, 3 Jun 2009 11:38:35 -0400
Message-ID: <9e4733910906030838o7313c311je3545cd974d3edd5@mail.gmail.com>
Subject: Re: PWM class? (was: Re: MPC52xx simple GPIO support)
From: Jon Smirl <jonsmirl@gmail.com>
To: avorontsov@ru.mvista.com
Cc: Stefan Strobl <nst@gersys.de>, ppc-dev <linuxppc-dev@ozlabs.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 9:22 AM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> On Wed, Jun 03, 2009 at 02:42:26PM +0200, Stefan Strobl wrote:
> [...]
>> The led class provides support for setting the brightness, which
>> obviously the gpio driver doesn't support. The hardware (mpc52xx_gpt)
>> would support it in PWM mode though. I'm now wandering how this could be
>> best implemented.
>>
>> 1) - Create some PWM class similar to the GPIO class
>>    - Add support for PWM mode in mpc52xx_gpt.c that uses that PWM class
>>    - And add an interface for the LED to use the PWM class
>>
>> 2) - Create an LED driver that accesses the mpc52xx_gpt directly.
>>
>> I think I would be overwhelmed trying to implement (1) but am confident
>> to do (2). What do you think is the right approach?
>
> I'd suggest creating a generic PWM class, i.e. PWMLIB, alike to
> GPIOLIB. (2) can be an acceptable approach for now, but for the
> long-term solution (1) is the way to go.

What happened to this one?

http://ozlabs.org/pipermail/linuxppc-dev/2008-October/063562.html


>
> The non-lib PWM API is already there, see include/linux/pwm.h,
> and arch/arm/mach-pxa/pwm.c as an implementation example.
>
> Note that PXA implementation is SOC-specific, which is not very
> good.
>
> So I'd suggest creating drivers/pwm/pwmlib.c, borrowing
> ideas from gpiolib. And then we can reuse drivers/leds/leds-pwm.c
> driver (of course, after adding appropriate OF code into it).
>
> Sure, as you've said, it could be quite boringly to implement,
> could take quite some time to pass all review cycles etc.
> But someday someone will have to do this. :-)
>
> --
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Jon Smirl
jonsmirl@gmail.com
