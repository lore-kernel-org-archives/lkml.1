Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZKSJtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZKSJtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 04:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZKSJtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 04:49:17 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:54168 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZKSJtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 04:49:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NK/Y5qwtHqUiVnDxrdPiwc/T9A3veqIETjs7hVH7U5ZscvIg6I0Dxtu+5stHCNjtuA
         KHtSe5J1fQswjD8tECQzJowcc6jsw8iTMDUt9KaeGEicGg7m88AlLCfKffR5oc+lMfIA
         IduZkQTMwImC6+OJYFS6O8pSgPg+2RTFRYUkg=
MIME-Version: 1.0
In-Reply-To: <20091119090204.GB13376@n2100.arm.linux.org.uk>
References: <4B024748.9080001@gmail.com>
	 <20091118142109.ff2c5ef6.akpm@linux-foundation.org>
	 <e68bb3470911182223r28e9bac0lf185c1443168ff52@mail.gmail.com>
	 <20091118234928.8d86a9f9.akpm@linux-foundation.org>
	 <e68bb3470911190040v2c14bbcfi46177cd58649e1c@mail.gmail.com>
	 <20091119090204.GB13376@n2100.arm.linux.org.uk>
Date: Thu, 19 Nov 2009 17:49:22 +0800
Message-ID: <e68bb3470911190149k3bc77ef6h26475bc7272784b8@mail.gmail.com>
Subject: Re: [PATCH] ARM: Add spi controller driver support for NUC900
From: Wan ZongShun <mcuos.com@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-spi <spi-devel-general@lists.sourceforge.net>,
       David Brownell-sourceforge <dbrownell@users.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/19 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Thu, Nov 19, 2009 at 04:40:50PM +0800, Wan ZongShun wrote:
>> 2009/11/19 Andrew Morton <akpm@linux-foundation.org>:
>> > I don't know, because I don't know what operation the hardware needs to
>> > stop it from generating interrupts.  Perhaps that's clk_disable()?
>>
>> The interrupt will be not occur as long as I run clk_disable().
>>
>> > Once you've stopped the source of interrupts then the code should wait
>> > for the IRQ handler to complete if it's running on another CPU.  Yes,
>> > free_irq() does that.
>>
>> So, regarding my system of single CPU, maybe I need put this
>> 'clk_disable()' in the front of function of w90p910_spi_remove().
>>
>> right?
>
> Depending on the hardware, that's not the right answer.  If turning off
> the clock also causes register accesses to the device to abort, it is
> a very dangerous thing to do.
>
> It can also be dangerous if the clock is used to synchronise the interrupt
> output - it can lead to the output being permanently asserted if the clock
> is turned off with it asserted.
>
> Normally devices have an "interrupt enable" register.  You should disable
> all interrupts from the device using this register after unregistering
> the driver from the (SPI) subsystem.

sir, so I need implement a API to disable spi device interrupt by
"interrupt enable" register?
but I did not find the operation in other ARM platform when they close
your spi driver.

or something I missed?

>



-- 
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
