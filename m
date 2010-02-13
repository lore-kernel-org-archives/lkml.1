Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab0BMVUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 16:20:11 -0500
Received: from mail-bw0-f216.google.com ([209.85.218.216]:44796 "EHLO
	mail-bw0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab0BMVUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 16:20:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=szeDKSI142Q12w+TK0ZWV4VnwPFrnAlqkTgs4nEjeDgYTxZ0oIawB4S4K4wSkJLYH8
         YdBE1wwDUqOWtzR9tI21OzCTBvmJZyZhZ82BN5X7QQQ/7qoOCnN37xfMX5EVHXFGSjPE
         z3m/2/QJL1XCTXhJe8Kt9X7VatfHHRop7FOjs=
MIME-Version: 1.0
In-Reply-To: <4B76D8AE.7040102@jic23.retrosnub.co.uk>
References: <dc6d3181002122148v6451ebffka164de288738485d@mail.gmail.com>
	 <63386a3d1002130548y7c839072y85097a9bcdf66cad@mail.gmail.com>
	 <4B76D8AE.7040102@jic23.retrosnub.co.uk>
Date: Sat, 13 Feb 2010 22:20:06 +0100
Message-ID: <63386a3d1002131320u5afbc35ak2bc3533aab3f1e54@mail.gmail.com>
Subject: Re: [spi-devel-general] SPI-ADC
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: arjun rath <rath.arjun@gmail.com>, spi-devel-general@lists.sourceforge.net,
       linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/13 Jonathan Cameron <kernel@jic23.retrosnub.co.uk>:

>>> can anybody share how to start a spi based ADC linux driver.I am having a
>>> MAXIM 1242 ADC chip.
>>
>> The ḱernel does not contain any generic ADC subsystem abstraction
>> (...)
>
> That's not entirely true.  These are covered by the IIO subsystem which
> is admittedly currently in staging as some elements still need cleaning up.
> (...)
> ADC drivers are under drivers/staging/iio/adc.

Great stuff. I knew about IIO and then it fell out of my mind, how
could I...

What strikes me especially about IIO is the underlying assumption, which I
think ought to be written in clear somewhere where I missed it, and that
is that all IIO drivers are supposed to deliver values and be controller from
userspace with this nice ABI, and nothing's wrong with that of course.

But I'm hinting about a few in-kernel uses: for AB3100 we have a battery
charging mechanism, which use a (calibrated) ADC value supporting the
bulk of the driver in the power/ subsystem.

As it looks today IIO is not intended for the case where another subsystem
needs to grab and use and ADC for its own purposes. Is this correct or did
I get it all wrong?

Would you say it'd be a good idea to hack the IIO ADC interface (for
example) to be used also internally in the kernel, or would that violate
the idea behind IIO?

If these are disparate categories it would warrant a separate adc/
subsystem, see.

> Currently all discussions take place on LKML, but we are working on a more
> focused alternative list which I'll announce once it is sorted out.

LKML is just fine with me, for one.

Yours,
Linus Walleij
