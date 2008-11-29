Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbYK2Xwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbYK2Xwj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 18:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYK2Xw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 18:52:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:24968 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbYK2XwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 18:52:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q2C5Je/2I7DVvxwAoibwDbv3s5CFVLw7aKu9BVtPjOLLBvEFTLJSVR5qFi9uqA//g1
         fMPovO+N4IrxQk8uojfI76agcS/eKrCZ5blESSEyZI6wRZIxZJSKL6byIqBykPfPDhyb
         X9gsPrd/VOBhtTAd1il/LjjdFoRbu8YS/2zu4=
Message-ID: <45a44e480811291552i77878bcdn5fe33f48fc4236eb@mail.gmail.com>
Date: Sun, 30 Nov 2008 07:52:23 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Cc: "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
In-Reply-To: <200811291454.17110.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <200811252015.57870.david-b@pacbell.net>
	 <45a44e480811252151q54580e07xfa73d69596fbfaac@mail.gmail.com>
	 <200811291454.17110.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 6:54 AM, David Brownell <david-b@pacbell.net> wrote:
> If you want to pursue this, I'd like to get the gpio_chip
> proposal in place first:  bitmask read and write, without
> forcing an "all bits are contiguous" policy.  Lightweight.

Yup, yup, I definitely want to pursue it. I want Linux e-paper
displays to be zippy. :-) Agreed, I will do bitmask read and write.
Hey, wait a sec, bitmask write definitely. but bitmask read is
peculiar to me. I can understand the caller would want to do something
like foo = gpio_get_values(gpio, bitwidth). But would they really want
to do foo = gpio_get_values(gpio, bitwidth, bitmask) rather than deal
with it appropriately themselves?

>
> Maybe it should suffice to have a gpio_chip support the
> bitmask ops, instead of just bit-at-a-time ones... so it'd
> be practical to incorporate this by itself, given patches
> to convert a couple gpio_chip implementations.

Ok, you've scared me there. I only have a Gumstix board so I can do it
for the pxa255 but will need help if more platforms are needed.
Exploiting this opportunity for hardware whoring, if anyone wants to
send me free hardware, I'll be ecstatic and will eagerly do support
duty on said platforms. :-)

>
> Then separately two more things:
>
>  - A gpio_* interface proposal for higher-level bitmask calls.
>   This is worth some discussion; the calls should clearly
>   be optional (not everything will implement them), and I
>   can't help but suspect <linux/bitmap.h> interfaces should
>   interoperate smoothly.
>
>  - A gpiolib based implementation, using those new gpio_chip
>   methods as accelerators if they're present.  This should
>   probably also be optional, even at the Kconfig level; many
>   systems won't need to spend memory on these calls.

Understood. I will make it optional. Does
CONFIG_GPIOLIB_MULTIBIT_ACCESS sound okay?

>
> Right now you seem to have smooshed together those three
> things, which probably helped get your sample driver going
> faster but isn't a very good way to move forward.  Don't

Yes, my goal with this was to get started and get feedback early. :-)

> assume gpiolib when defining the interface.

Ok, I didn't understand this part. I think you mentioned a higher
level interface before but I didn't fully understand, if not gpiolib,
then at what level do you recommend?

Thanks,
jaya
