Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0BIJnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 04:43:20 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:62948 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0BIJnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 04:43:19 -0500
Message-ID: <4B712DA5.4000802@petalogix.com>
Date: Tue, 09 Feb 2010 10:40:53 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH RFC 0/3] Implement refcounting for OF GPIO chips
References: <20100205204949.GA2575@oksana.dev.rtsoft.ru>
In-Reply-To: <20100205204949.GA2575@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> Hi all,
> 
> OF GPIO infrastructure is using dynamic GPIO bases, so it is possible
> that of_get_gpio()'s returned GPIO number will be no longer valid, or
> worse, it may point to an unexpected GPIO controller.
> 
> This scenario is possible:
> 
> driver A:               driver B:              driver C:
> ---------               ---------              ---------
>                         gpiochip_add()
> gpio = of_get_gpio()
>                         gpiochip_remove()
>                                                gpiochip_add()
> gpio_request(gpio);
> gpio_set_value(gpio);
> 
> That is, driver A assumes that it is working with GPIO from driver B,
> but in practice it may disappear and driver C will take its GPIO base
> number, so it will provide the same GPIO numbers.
> 
> The above situation is hard to trigger, but the issue is there
> nonetheless, and so needs fixing.


I tested xilinx gpio driver, heartbeat trigger and access through sysfs 
and I haven't found any problem. There is only small part of code for 
Microblaze and it is the same with PowerPC. If is Ben OK with it, I am 
ok too.

Thanks,
Michal


> 
> Thanks,
> 
> p.s. The patches are based on top of
>      '[PATCH v2 0/4] OF GPIO integration for I2C/SPI GPIO chips'
>      http://lkml.org/lkml/2010/2/5/243
> 


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
