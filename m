Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZDRFuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZDRFuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 01:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZDRFuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 01:50:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:33828 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZDRFuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 01:50:04 -0400
MIME-Version: 1.0
In-Reply-To: <20090417170707.B6C95C4004F@mail150-wa4.bigfish.com>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu> 
	<74c0088dfda1816c21914c0a8da0c42908526c5e.1239874968.git.monstr@monstr.eu> 
	<20090417170707.B6C95C4004F@mail150-wa4.bigfish.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 17 Apr 2009 23:49:47 -0600
Message-ID: <fa686aa40904172249m5e261492w48c8d9d8446600e0@mail.gmail.com>
Subject: Re: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig: Enable 
	drivers for Microblaze
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       John Linn <john.linn@xilinx.com>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 11:06 AM, Stephen Neuendorffer
<stephen.neuendorffer@xilinx.com> wrote:
>
> Can we have XILINX_DRIVERS, please?  That way this can also be enabled
> on any architecture that has FPGA peripherals.

I've thought about this more, and I'd really rather not.  The list of
affected drivers is short and is not a large maintenance burden.  I
don't think a list of 2 or 3 architecture selects for each driver is
unreasonable.  A "XILINX_DRIVERS" config item doesn't really help much
anyway.  At any given time one of these drivers may be needed on
another platform.  ie. the SystemACE device is present on at least one
non-virtex, non-spartan platform.

g.

>
> Steve
>
>> -----Original Message-----
>> From: owner-microblaze-uclinux@itee.uq.edu.au
> [mailto:owner-microblaze-uclinux@itee.uq.edu.au] On
>> Behalf Of monstr@monstr.eu
>> Sent: Thursday, April 16, 2009 2:57 AM
>> To: linux-kernel@vger.kernel.org
>> Cc: microblaze-uclinux@itee.uq.edu.au; Michal Simek
>> Subject: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig:
> Enable drivers for Microblaze
>>
>> From: Michal Simek <monstr@monstr.eu>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  drivers/block/Kconfig |    2 +-
>>  drivers/char/Kconfig  |    2 +-
>>  drivers/gpio/Kconfig  |    2 +-
>>  drivers/usb/Kconfig   |    1 +
>>  4 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
>> index ddea8e4..9f1665f 100644
>> --- a/drivers/block/Kconfig
>> +++ b/drivers/block/Kconfig
>> @@ -438,7 +438,7 @@ source "drivers/s390/block/Kconfig"
>>
>>  config XILINX_SYSACE
>>       tristate "Xilinx SystemACE support"
>> -     depends on 4xx
>> +     depends on 4xx || MICROBLAZE
>>       help
>>         Include support for the Xilinx SystemACE CompactFlash
> interface
>>
>> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
>> index 735bbe2..bb1a071 100644
>> --- a/drivers/char/Kconfig
>> +++ b/drivers/char/Kconfig
>> @@ -893,7 +893,7 @@ config DTLK
>>
>>  config XILINX_HWICAP
>>       tristate "Xilinx HWICAP Support"
>> -     depends on XILINX_VIRTEX
>> +     depends on XILINX_VIRTEX || MICROBLAZE
>>       help
>>         This option enables support for Xilinx Internal Configuration
>>         Access Port (ICAP) driver.  The ICAP is used on Xilinx Virtex
>> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>> index edb0253..11f3739 100644
>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -69,7 +69,7 @@ comment "Memory mapped GPIO expanders:"
>>
>>  config GPIO_XILINX
>>       bool "Xilinx GPIO support"
>> -     depends on PPC_OF
>> +     depends on PPC_OF || MICROBLAZE
>>       help
>>         Say yes here to support the Xilinx FPGA GPIO device
>>
>> diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
>> index c6c816b..5eee3f8 100644
>> --- a/drivers/usb/Kconfig
>> +++ b/drivers/usb/Kconfig
>> @@ -22,6 +22,7 @@ config USB_ARCH_HAS_HCD
>>       default y if PCMCIA && !M32R                    # sl811_cs
>>       default y if ARM                                # SL-811
>>       default y if SUPERH                             # r8a66597-hcd
>> +     default y if MICROBLAZE
>>       default PCI
>>
>>  # many non-PCI SOC chips embed OHCI
>> --
>> 1.5.5.1
>>
>> ___________________________
>> microblaze-uclinux mailing list
>> microblaze-uclinux@itee.uq.edu.au
>> Project Home Page :
> http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
>> Mailing List Archive :
> http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
>>
>
>
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
