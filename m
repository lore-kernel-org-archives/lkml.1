Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbZLOUPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbZLOUPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761052AbZLOUPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:15:17 -0500
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:42149 "HELO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761030AbZLOUPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:15:16 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: GPIO support for HTC Dream
Date: Tue, 15 Dec 2009 15:15:14 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EBE8@mi8nycmail19.Mi8.com>
In-Reply-To: <20091215194725.GH24406@elf.ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: GPIO support for HTC Dream
Thread-Index: Acp9v3LFMBJCliqPRQOQMi36yE+lYgAAeW4g
References: <20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com> <4B203575.6050407@bluewatersys.com> <20091210172458.GJ19454@elf.ucw.cz> <4B2150B7.3040207@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com> <20091211221015.GB24456@elf.ucw.cz> <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com> <20091214064545.GK5114@elf.ucw.cz> <BD79186B4FD85F4B8E60E381CAEE19090200E9E6@mi8nycmail19.Mi8.com> <20091215194725.GH24406@elf.ucw.cz>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "Ryan Mallon" <ryan@bluewatersys.com>,
       "Daniel Walker" <dwalker@codeaurora.org>,
       "Iliyan Malchev" <malchev@google.com>,
       "Brian Swetland" <swetland@google.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Arve Hj?nnev?g" <arve@android.com>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 15 Dec 2009 20:15:13.0428 (UTC) FILETIME=[4F326D40:01CA7DC3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 15, 2009 12:47 PM, Pavel Machek wrote:
>
> Hi!
>
>>> +int gpio_to_irq(unsigned gpio)
>>> +{
>>> +	return -EINVAL;
>>> +}
>> 
>> This should probably just be an inline function in
>> arch/arm/mach-msm/include/mach/gpio.h
>
> Well, it is not performance critical in any way and it is likely to
> change in future. I'd leave it here.

Comment below..

>>> diff --git a/arch/arm/mach-msm/board-dream.h b/arch/arm/mach-msm/board-dream.h
>>> index 4f345a5..dbd78b9 100644
>>> --- a/arch/arm/mach-msm/board-dream.h
>>> +++ b/arch/arm/mach-msm/board-dream.h
>>> @@ -1,5 +1,58 @@
>>>  
>>> -#define TROUT_CPLD_BASE   0xE8100000
>>> -#define TROUT_CPLD_START  0x98000000
>>> -#define TROUT_CPLD_SIZE   SZ_4K
>>> +#define MSM_SMI_BASE		0x00000000
>>> +#define MSM_SMI_SIZE		0x00800000
...
>>> +#define DREAM_CPLD_BASE   0xE8100000
>>> +#define DREAM_CPLD_START  0x98000000
>>> +#define DREAM_CPLD_SIZE   SZ_4K
>>> +
>>
>> This header might need to be a separate patch.  The only thing in it
>> related to the rest of this is DREAM_CPLD_BASE.
>
> Yep.
>
>>> +#ifndef __ASM_ARCH_MSM_GPIO_H
>>> +#define __ASM_ARCH_MSM_GPIO_H
>>> +
>>> +extern int gpio_to_irq(unsigned gpio);
>> 
>> This should probably be an inline as mentioned above.
>> 
>> For completeness you should probably also add:
>> 
>> static inline int irq_to_gpio(unsigned irq)
>> {
>> 	return -EINVAL;
>> }
>
> I'd say that would be overdoing it.

I only mentioned that one because it is one of the functions listed in
Documentation/gpio.txt.  I'm not sure if that means it's "required".  You
make the call...

>> And, nitpick, move both of them after the gpio_cansleep below.
>
> I'll do the move.
>
>>> +#define DREAM_GPIO_CABLE_IN1		(83)
>>> +#define DREAM_GPIO_CABLE_IN2		(49)
>>> +
>>> +#define DREAM_GPIO_START (128)
>> 
>> Nitpick.  Tab align these three with the ones below.
>
> Ok.
>
>>> +#define DREAM_GPIO_SDMC_CD_N                (DREAM_GPIO_VIRTUAL_BASE + 0)
>>> +#define DREAM_GPIO_END                      (DREAM_GPIO_SDMC_CD_N)
>>> +#define DREAM_GPIO_BANK1_FIRST_INT_SOURCE   (DREAM_GPIO_SDMC_CD_N)
>>> +#define DREAM_GPIO_BANK1_LAST_INT_SOURCE    (DREAM_GPIO_SDMC_CD_N)
>>> +
>>> +#endif
>> 
>> Otherwise, looks good to me.  Just test it to make sure it works :-).
>> 
>> Since I have no way of compiling or testing this...
>> 
>> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> I believe inlining that function would be bad change. Can I still use
> reviewed-by tag?

The reason I suggest making it an inline in the header is you might
eventually want to change both gpio_to_irq and irq_to_gpio into macros
so that they can be used for static initializers.  For right now both
are simple return -EINVAL but when gpio irq's are supported you might
find a need to use one or the other in a platform init...

Regardless, yes you can still use my reviesed-by tag.

Regards,
Hartley
