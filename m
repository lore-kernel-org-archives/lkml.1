Return-Path: <linux-kernel-owner+w=401wt.eu-S932284AbZHCWRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbZHCWRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZHCWRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:17:32 -0400
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:44273 "HELO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752884AbZHCWRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:17:32 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] gpio: include <linux/gpio.h> not <asm/gpio.h>
Date: Mon, 3 Aug 2009 18:17:29 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901B77674@mi8nycmail19.Mi8.com>
In-Reply-To: <20090803145050.8049bc20.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] gpio: include <linux/gpio.h> not <asm/gpio.h>
Thread-Index: AcoUhIQ7ZKA5396wRv+g/VlrptoTRAAA1i6w
References: <200907311059.51142.hartleys@visionengravers.com> <20090803145050.8049bc20.akpm@linux-foundation.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <dbrownell@users.sourceforge.net>
X-OriginalArrivalTime: 03 Aug 2009 22:17:30.0951 (UTC) FILETIME=[31591570:01CA1488]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 03, 2009 2:51 PM, Andrew Morton wrote:
>> Drivers should be including <linux/gpio.h> not <asm/gpio.h>.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> 
>> ---
>> 
>> diff --git a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/bt8xxgpio.c
>> index 984b587..fd1c54d 100644
>> --- a/drivers/gpio/bt8xxgpio.c
>> +++ b/drivers/gpio/bt8xxgpio.c
>> @@ -46,8 +46,7 @@
>>  #include <linux/module.h>
>>  #include <linux/pci.h>
>>  #include <linux/spinlock.h>
>> -
>> -#include <asm/gpio.h>
>> +#include <linux/gpio.h>
>
> There's some potential for breakage here.  include/linux/gpio.h has
>
> #ifdef CONFIG_GENERIC_GPIO
> #include <asm/gpio.h>
>
> #else
> 
> ...
>
> #endif
>
>
> So if there's some configuration which forgot to set
> CONFIG_GENERIC_GPIO, the driver will be switched over to use the
> include/linux/gpio.h stubs and will break.
>
> Please convince me that this cannot happen ;)

Can't happen for these drivers.  Everything in drivers/gpio requires
GPIOLIB which selects GENERIC_GPIO.  Please see drivers/gpio/Kconfig.

Thanks,
Hartley


