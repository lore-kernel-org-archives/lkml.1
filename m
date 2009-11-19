Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZKSIkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZKSIkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 03:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZKSIko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 03:40:44 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:34123 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZKSIko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 03:40:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bo0AiQaIcvt/MnFO9kYpf535kFOeL4a0MqL4pPUav78szbe3AtX9h34LvhVTrns2xh
         dDowuDnp8MA8l9Al9s3tilSKUnRKWcmHfbx6ShWAjgy+YmfSrKKe+R8EOEP3zlfYV26O
         /FhV2UvwpKDFsxsK6M3iEVUep7pCW31Vjr9SQ=
MIME-Version: 1.0
In-Reply-To: <20091118234928.8d86a9f9.akpm@linux-foundation.org>
References: <4B024748.9080001@gmail.com>
	 <20091118142109.ff2c5ef6.akpm@linux-foundation.org>
	 <e68bb3470911182223r28e9bac0lf185c1443168ff52@mail.gmail.com>
	 <20091118234928.8d86a9f9.akpm@linux-foundation.org>
Date: Thu, 19 Nov 2009 16:40:50 +0800
Message-ID: <e68bb3470911190040v2c14bbcfi46177cd58649e1c@mail.gmail.com>
Subject: Re: [PATCH] ARM: Add spi controller driver support for NUC900
From: Wan ZongShun <mcuos.com@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-spi <spi-devel-general@lists.sourceforge.net>,
       David Brownell-sourceforge <dbrownell@users.sourceforge.net>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/19 Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 19 Nov 2009 14:23:49 +0800 Wan ZongShun <mcuos.com@gmail.com> wrote:
>
>> >> +static int __devexit w90p910_spi_remove(struct platform_device *dev)
>> >> +{
>> >> + __ __ struct w90p910_spi *hw = platform_get_drvdata(dev);
>> >> +
>> >> + __ __ platform_set_drvdata(dev, NULL);
>> >> +
>> >> + __ __ spi_unregister_master(hw->master);
>> >> +
>> >> + __ __ clk_disable(hw->clk);
>> >> + __ __ clk_put(hw->clk);
>> >
>> > As far as I can tell, a hardware interrupt could still be pending, or
>> > be under service while the above code is executing?
>> >
>> > If so, I expect bad things will happen?
>>
>> Do you mean that I should put this 'free_irq()' in the front of
>> w90p910_spi_remove___
>>
>> such as:
>> "
>> free_irq(hw->irq, hw);
>>
>> platform_set_drvdata(dev, NULL);
>>
>> spi_unregister_master(hw->master);
>>
>> clk_disable(hw->clk);
>> clk_put(hw->clk);
>
> I don't know, because I don't know what operation the hardware needs to
> stop it from generating interrupts.  Perhaps that's clk_disable()?

The interrupt will be not occur as long as I run clk_disable().

> Once you've stopped the source of interrupts then the code should wait
> for the IRQ handler to complete if it's running on another CPU.  Yes,
> free_irq() does that.

So, regarding my system of single CPU, maybe I need put this
'clk_disable()' in the front of function of w90p910_spi_remove().

right?

> It's only after the clk_disable() and the free_irq() that you can
> guarantee that no interrupt handler will run and attempt to access the
> device and its associated data structures.
>
>



-- 
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
