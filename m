Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0BIR3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:29:30 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:59637 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab0BIR32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:29:28 -0500
MIME-Version: 1.0
In-Reply-To: <4B712DA5.4000802@petalogix.com>
References: <20100205204949.GA2575@oksana.dev.rtsoft.ru> <4B712DA5.4000802@petalogix.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 9 Feb 2010 10:29:07 -0700
X-Google-Sender-Auth: 523352692593502c
Message-ID: <fa686aa41002090929i12b4db72we17ed52aa17bc567@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] Implement refcounting for OF GPIO chips
To: michal.simek@petalogix.com
Cc: avorontsov@ru.mvista.com, David Brownell <dbrownell@users.sourceforge.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 2:40 AM, Michal Simek <michal.simek@petalogix.com> wrote:
> Anton Vorontsov wrote:
>>
>> Hi all,
>>
>> OF GPIO infrastructure is using dynamic GPIO bases, so it is possible
>> that of_get_gpio()'s returned GPIO number will be no longer valid, or
>> worse, it may point to an unexpected GPIO controller.
>>
>> This scenario is possible:
>>
>> driver A:               driver B:              driver C:
>> ---------               ---------              ---------
>>                        gpiochip_add()
>> gpio = of_get_gpio()
>>                        gpiochip_remove()
>>                                               gpiochip_add()
>> gpio_request(gpio);
>> gpio_set_value(gpio);
>>
>> That is, driver A assumes that it is working with GPIO from driver B,
>> but in practice it may disappear and driver C will take its GPIO base
>> number, so it will provide the same GPIO numbers.
>>
>> The above situation is hard to trigger, but the issue is there
>> nonetheless, and so needs fixing.
>
>
> I tested xilinx gpio driver, heartbeat trigger and access through sysfs and
> I haven't found any problem. There is only small part of code for Microblaze
> and it is the same with PowerPC. If is Ben OK with it, I am ok too.

I'm not convinced the changes take the best approach, so I'm not okay
with it yet.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
