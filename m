Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbXK0BrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbXK0BrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 20:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXK0Bq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 20:46:58 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:26304 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752193AbXK0Bq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 20:46:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tVN//5lAGtyaJ6MvnaSSjByw9v5jPMJKV97x7HN9T6ELzrU76+A9rT2bQkmpXM7iJSqVBXmT0yO5Du5kbqM2dopWAcp7wk9+EyQIba4hJ5SZSRbyGBeLxF00XxFHkasrrYhm0z1iy7aqdtewNY99s9QzgkEPvExOibcA/nB/P34=  ;
X-YMail-OSG: tflseegVM1mW7OJtTtyqatWM_3pV4KCs2wYMNOTbAdVYDTQezLqt42UM6FnQIbsFOwbjgQXR_A--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Mon, 26 Nov 2007 17:46:54 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <f17812d70711132240m359fcd5doac56ab06bfe76f69@mail.gmail.com> <200711132308.48779.david-b@pacbell.net>
In-Reply-To: <200711132308.48779.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711261746.55235.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, David Brownell wrote:
> So the point of these is to make it easier for platforms
> (or even just boards) to make sure the GPIO number space
> is densely packed, rather than loosely so?  Paying about
> 2KBytes for that privilege.  (Assuming a 32 bit system
> with 256 GPIOs.)
> 
> I could see that being a reasonable tradeoff.  I wouldn't
> have started there myself, but you know how that goes!
> 
> Does anyone else have any comments on that issue?

Nobody else seems to have any comments on Eric's series
of patches to add a gpio_desc layer ... whereas, I was
looking at updating one platform, and got annoyed at some
stuff that would have been non-issues with them in place!


Eric, would you feel like rolling an all-in-one patch against
the gpiolib support from 2.6.24-rc3-mm?  Including updated
versions of your patches:

 - [PATCH 2/5] define gpio_chip.requested_str
	(renaming it as "label" to match its usage)
 - [PATCH 3/5] use a per GPIO "struct gpio_desc"
	(but without that needless list; for debug,
	just scan the gpio_desc list for the next
	non-null chip)
 - [PATCH] move per GPIO "is_out" to "struct gpio_desc"
	(i.e. patch 4/5)
 - [PATCH 5/5] move per GPIO "requested" to "struct gpio_desc"
	(and "label" too)

along with removing the ARCH_GPIOS_PER_CHIP symbol, and
reducing ARCH_NR_GPIOS to a value which will waste less
space by default?  (Like maybe 256.)

I think an all-in-one patch will be easier to review
and agree on including (or not).

- Dave
