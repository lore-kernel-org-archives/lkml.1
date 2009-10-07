Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZJGFOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZJGFOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 01:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZJGFOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 01:14:36 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:54968 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbZJGFOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 01:14:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DSnhVbxD302mVham2J1gDNXw8OumsnvuM9au1V5DEGZJIJlcTiJEEbVL7J4EZhjPv+
         51U9W3H43hZtLVKT9cjmTUN0K0TEX4gICXPKZ/fnfws4i/N4XPZIMprmfSGWGen8aibR
         kdV9LdA3p8hpgpEO8kUV+sz/yyBFD/vBLS9Wk=
MIME-Version: 1.0
In-Reply-To: <5d5443650910061135t68d004e3r30715da062b74750@mail.gmail.com>
References: <20091006074533.GA28889@july>
	 <5d5443650910061135t68d004e3r30715da062b74750@mail.gmail.com>
Date: Wed, 7 Oct 2009 14:13:57 +0900
X-Google-Sender-Auth: bc025396de955119
Message-ID: <9c9fda240910062213j12ff18d7x787041ef2217552a@mail.gmail.com>
Subject: Re: [PATCH] Haptic class support (v2)
From: Kyungmin Park <kmpark@infradead.org>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 7, 2009 at 3:35 AM, Trilok Soni <soni.trilok@gmail.com> wrote:
> Hi Kyungmin,
>
> On Tue, Oct 6, 2009 at 1:15 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>> This patch includes two haptic devices, isa1000 and isa1200
>> ISA1000 is gpio based haptic, but isa1200 is based on I2C
>> Both are working on Samsung SoCs and tested.
>>
>> To enable the haptic, echo 1 > /sys/class/haptic/${name}/enable
>> You can adjust the level by echo ${level} > /sys/class/haptic/${name}/enable
>> or
>> With oneshot feature, echo ${msec time} > /sys/class/haptic/${name}/oneshot
>>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> Many thanks for the posting the update and example drivers. Here are
> my suggestions to make it mainlined fast:
>
> 1. split these patches - probably in following order would be good
>   a) haptics class
>   b) haptics samsung pwm driver
>   c) isa1200 haptics driver
>   d) add maintainers entry in MAINTAINERS file under your name for haptics :)
>   d) please add short documentation under Documentation/haptics ?
> directory describe what haptics class is all about, and atleast
> userspace interfaces which you are providing using sysfs file. We can
> use led class documentation as example here. Short documentation is
> fine to begin with.

Thank you for suggestion. I will split the patches. and resend.

>   e) if possible create your own git haptics project tree at
> kernel.org and add it to linux-next, but I would also suggest that as
> no. of updates to these framework will be not so frequent, so we can
> also follow -mm route and let Andrew pick up your patches and get them
> cooked under -mm.

I think no need to create new haptic tree. it's simple class to handle
haptic drivers.

>
>>
>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>> index 48bbdbe..d44a601 100644
>> --- a/drivers/Kconfig
>> +++ b/drivers/Kconfig
>> @@ -62,6 +62,8 @@ source "drivers/power/Kconfig"
>>
>>  source "drivers/hwmon/Kconfig"
>>
>> +source "drivers/haptic/Kconfig"
>> +
>>  source "drivers/thermal/Kconfig"
>>
>>  source "drivers/watchdog/Kconfig"
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index 6ee53c7..16b8f67 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -77,6 +77,7 @@ obj-$(CONFIG_PPS)             += pps/
>>  obj-$(CONFIG_W1)               += w1/
>>  obj-$(CONFIG_POWER_SUPPLY)     += power/
>>  obj-$(CONFIG_HWMON)            += hwmon/
>> +obj-$(CONFIG_HAPTIC)           += haptic/
>>  obj-$(CONFIG_THERMAL)          += thermal/
>>  obj-$(CONFIG_WATCHDOG)         += watchdog/
>>  obj-$(CONFIG_PHONE)            += telephony/
>> diff --git a/drivers/haptic/Kconfig b/drivers/haptic/Kconfig
>> new file mode 100644
>> index 0000000..9acb02a
>> --- /dev/null
>> +++ b/drivers/haptic/Kconfig
>> @@ -0,0 +1,31 @@
>> +menuconfig HAPTIC
>> +       bool "HAPTIC support"
>> +       help
>> +         Say Y to enalbe haptic support. It enables the haptic and controlled
>
> s/enalbe/enable

Fixed.

>
>> +         from both userspace and kernel
>
> Please explain how from kernel? We are only providing sysfs interface
> for this framework, and I don't see in-kernel control of haptics
> driver in your patch. Also I don't see any need of in-kernel control
> of them though.

It's wrong description. It's handled from userspace not kernel.

>
>> +
>> +if HAPTIC
>> +
>> +config HAPTIC_CLASS
>> +       tristate "Haptic Class Support"
>> +       help
>> +         This option enables the haptic sysfs class in /sys/class/haptic.
>> +
>> +comment "Haptic drivers"
>> +
>> +config HAPTIC_SAMSUNG_PWM
>> +       tristate "Haptic Support for SAMSUNG PWM-controlled motor (ISA1000)"
>> +       depends on HAPTIC_CLASS && (ARCH_S3C64XX || ARCH_S5PC1XX)
>> +       help
>> +         This options enables support for haptic connected to GPIO lines
>> +         controlled by a PWM timer on SAMSUNG CPUs.
>> +
>> +comment "Haptic chips"
>> +
>> +config HAPTIC_ISA1200
>> +       tristate "Haptic Motor"
>> +       depends on HAPTIC_CLASS && I2C
>> +       help
>> +         The ISA1200 is a high performance enhanced haptic motor driver
>
> This chip also seems to support external pwm mode like isa1000, so you
> could explicitly add that this driver is about controlling it through
> i2c only, but there could be a possibility of writing the same through
> external pwm mode also.

Actually it supports both internal and external. but in my hardware it
connects with external.
So I implement it as previous isa1000 does.
Someone can implement it as internal.

>
>> +
>> +static int samsung_pwm_haptic_probe(struct platform_device *pdev)
>> +{
>
> __devinit?

Fixed.

>
>> +       struct haptic_platform_data *pdata = pdev->dev.platform_data;
>> +       struct samsung_pwm_haptic *haptic;
>> +       int ret;
>> +
>> +       haptic = kzalloc(sizeof(struct samsung_pwm_haptic), GFP_KERNEL);
>> +       if (!haptic) {
>> +               dev_err(&pdev->dev, "No memory for device\n");
>> +               return -ENOMEM;
>> +       }
>> +static int samsung_pwm_haptic_remove(struct platform_device *pdev)
>> +{
>
> __devexit

Fixed

>
>> +
>> +static int __devexit isa1200_remove(struct i2c_client *client)
>> +{
>> +       return 0;
>
> nothing to remove?

Sorry I'm not yet implemented. Will fix it.

>
>> +}
>> +
>> +static int isa1200_suspend(struct i2c_client *client, pm_message_t mesg)
>> +{
>> +       struct isa1200_chip *chip = i2c_get_clientdata(client);
>> +       isa1200_chip_power_off(chip);
>> +       return 0;
>> +}
>> +
>> +static int isa1200_resume(struct i2c_client *client)
>> +{
>> +       isa1200_setup(client);
>> +       return 0;
>> +}
>
> #ifdef CONFIG_PM checks please.

Of course.

Thank you,
Kyungmin Park
