Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbXGCM6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbXGCM6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 08:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbXGCM6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 08:58:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:40903 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbXGCM6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 08:58:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Py1xo+ddJkynr/3zUPJNYUOJvBU/FJAdiCon9XsbQCkD5oOkxFkAl+scKhgzkYVSSPOSqr6E2xO3M4jnbwdrj+ViHPPkjUingKS5oN5X1B12jJtsuL3IjnV2LVzb5RlHzBJGJlsgA1ClVBAjzt99ASYlGDF9Ec6HMNhPBofvDSA=
Message-ID: <8d6898730707030558o5e110b0v257ffc6350c76069@mail.gmail.com>
Date: Tue, 3 Jul 2007 18:28:40 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: "Midhun Agnihotram" <agnimidhun@gmail.com>
Subject: Re: platform_driver_register() ??
Cc: linux-kernel@vger.kernel.org, "Pierre Ossman" <drzeus-mmc@drzeus.cx>
In-Reply-To: <4dde4acb0707030028p2c078a22jd537853f145c2518@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4dde4acb0707030028p2c078a22jd537853f145c2518@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Midhun,
    I think mmc driver is layered modules, only top block driver
registers driver under  "mmc_bus_type" bus, see
drivers/mmc/mmc_sysfs.c and mmc_block.c. I think they are creating a
tree of devices of same characteristics under that bus.
I think your driver is linux/drivers/mmc/imxmmc.c where it registers a
driver for device of type "platform_bus_type". This module will come
under above mentioned block driver.
Corresponding platform device is registered in
linux/arch/arm/mach-imx/generic.c see platform_device imx_mmc_device.

Nobin Mathew




On 7/3/07, Midhun Agnihotram <agnimidhun@gmail.com> wrote:
> Hi All,
>
>  I have an MMC driver for my kit (i.MX21 based cogent board
> CSB535FS), which is supplied by Cogent (Kernel version 2.6.16).
>
>   The original driver (linux/drivers/mmc/mmc_block.c) uses
> mmc_register_driver() method to register the driver but the one
> supplied by Cogent uses platform_driver_register() method. What is the
> difference between the two?
>
>
> Thanks,
> Midhun.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
