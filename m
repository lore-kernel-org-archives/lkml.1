Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZADBjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZADBjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 20:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZADBjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 20:39:33 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:42221 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751017AbZADBjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 20:39:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=o43oPkxo5+GyUdu/O5ZN9NYf60O5ckKLNm1JoewiLKo9ipw1XrwbfSSTtPAk/mgxmbIoqFGLuPsO+BkZZYc3HRIWf2MAK8HWj/ljHmluuCcoqrROGl+kvnOB4R7Vtb4DG4xeYduRG7kJ0jp5oZr9n6GsDpojjrO6MGQuKxGWCGk=  ;
X-YMail-OSG: GfWmwlAVM1lKBEv6HbK9evHZxI3N69ScdJ5OfN.eNu0PmUbRKLvd__zl5e_SeDORX92jUQUBXoLEIfr1TaJAqsfY.tg3.G5I.3omsGbbC15uBOv6PJOCyGxThliRf3uFeLxEYj6WiZ54knTnEoKJ8Tg0dZ_ekH3QdAtrzxzo7i2yQbt.xaF2UDNFgUth
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sat, 3 Jan 2009 17:39:27 -0800
User-Agent: KMail/1.9.10
Cc: Rob Landley <rob@landley.net>,
       Matthieu CASTET <matthieu.castet@parrot.com>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901031346.01325.rob@landley.net> <4960068A.3040109@shaw.ca>
In-Reply-To: <4960068A.3040109@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901031739.28517.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009, Robert Hancock wrote:
> Rob Landley wrote:
> > ... some architectures (arm omap and and arm at91) 
> > allow you to enter arbitrary HZ values in kconfig.  (Their help text says that 
> > in many cases values that aren't powers of two won't work, but nothing 
> > enforces this.)
> 
> Is there a good reason that these archs allow you enter arbitrary HZ 
> values?

Power-of-two can be desirable when using a 32 KiHz oscillator, because
other values accumulate rounding errors ... you can't make 100 Hz, or
250 Hz, or 300 Hz, or 1000 Hz, by a binary division of 32 KiHz.

Other values were supported to help work around stupid software making
bad assumptions about HZ.  IMO, enforcing power-of-two would be better;
that software breaks with dyntick anyway, and needs fixing.


> The use case for using custom HZ values at all nowadays seems  
> fairly low now that dynticks is around (if that arch supports it 
> anyway),

A better argument would be that GENERIC_TIME exists (and works
on OMAP and AT91), which avoids some flavors of rounding error.
ISTR those CONFIG_HZ options predate GENERIC_TIME support.

However, the issue remains that most kernel times are measured in
jiffies not ktime_t -- they're easier and more efficient, all
those 64-bit multiplies can hurt on ARM (32-bit, non-GHz) -- so
it's still good to be able to ensure that jiffies-centric logic
won't always be inserting easily avoidable errors.

- Dave
