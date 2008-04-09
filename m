Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbYDIHQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbYDIHQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 03:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYDIHPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 03:15:53 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:60860 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbYDIHPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 03:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k4ridOav/Hwc/wnAhtK5aOnGl2PkITWz+ZJko/Y4vi7J9JDWqxk8xwahZ3Mlrd4leRD+yLZqWWb8MOY9wDfq71O66+0UkvjNk/gjROn/k8cvNQme9OKwAKajMt7QQjnp2DSMb/UN8KjhjPux5k+ShfUDZqG0q7okARUc6lUCVMw=
Message-ID: <bc64b4640804090015m7dd640d5j31c54b99007f09a7@mail.gmail.com>
Date: Wed, 9 Apr 2008 11:15:51 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, lethal@linux-sh.org,
       philipp.zabel@gmail.com, pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
In-Reply-To: <20080408193309.GA18053@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
	 <20080403132402.GA27008@doriath.ww600.siemens.net>
	 <20080407160029.f1f9ce4f.akpm@linux-foundation.org>
	 <20080407230434.GA525@flint.arm.linux.org.uk>
	 <bc64b4640804080247s82ba84chd740c08b2fbb9b1a@mail.gmail.com>
	 <20080408193309.GA18053@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/4/8, Russell King <rmk+lkml@arm.linux.org.uk>:
> On Tue, Apr 08, 2008 at 01:47:35PM +0400, Dmitry wrote:
>  > Yes, it works currently. But there are a few problems: we declare
>  > STUART's UARTCLK with dev=NULL (all other UARTCLKs are declared with
>  > proper devices).  Therefore,  I consider it as a hack and would like
>  > to remove it.
>
>
> I don't consider it a hack at all - it's a work around for the fact
>  that the PXA FIR driver shares the UART, but the FIR driver doesn't
>  bind to the UART itself.

Would you then accept the patch that still contains UARTCLK bound to
pxa uart device, and IrDA requesting clock STUARTCLK?

>  The _real_ issue is with IrDA itself, and is larger than just the
>  clock library.  Any serial port which supports IrDA, even on x86,
>  has to be shared between the serial driver and the IrDA driver -
>  there's no way for them to quietly co-exist and "just work" as
>  requested.

Yes. I wonder how this is solved in other platforms.
>
>  So, let's not work around the short comings of Serial/IrDA interactions
>  by adding additional complexity to random other layers which _shouldn't_
>  even be seeing the issue.
>
>  In addition, the point of the clock framework is that you ask for the
>  device plus clock NAME on _that_ device.  Inventing random other names
>  for the same physical clock on the same physical device is just nonsense -
>  even more so than the existing workaround.

See my proposition above. I highly dislike the UARTCLK w/o device declared.
Once it has already lead me to (small) problems due to messed other
UARTCLKs  declarations on pxa25x.

-- 
With best wishes
Dmitry
