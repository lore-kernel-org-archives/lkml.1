Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZFFIEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZFFIEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbZFFIEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:04:23 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:62731 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbZFFIET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=P8M8D0+uAejcKUzSQ+/8rHwp05ZWi/wU9DApM6utdseI+xBiVU87IoKIPdHSY/5bJb
         SVJ9Q16X3B6CmSJq66ztzulKK8g7MYyzdnN0X8tajLbzx1KQIzDFgI/RvMNO7DwBOqJb
         XbN34G0Hy6Dcaux66SdUtMcLRjdFZLVUjvspg=
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <71cd59b00906060012w6bc6f302o76fea3c8a570840e@mail.gmail.com>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
	 <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
	 <4A2987A9.2010202@xandros.com>
	 <71cd59b00906060012w6bc6f302o76fea3c8a570840e@mail.gmail.com>
Date: Sat, 6 Jun 2009 09:04:20 +0100
Message-ID: <9b2b86520906060104q62ebdfcdv7af63cf1dee416db@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Woody Suwalski <woodys@xandros.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/09, Corentin Chary <corentin.chary@gmail.com> wrote:
> On Fri, Jun 5, 2009 at 11:01 PM, Woody Suwalski<woodys@xandros.com> wrote:
>> Corentin Chary wrote:
>>>
>>> On Fri, Jun 5, 2009 at 10:59 AM, Pekka J Enberg<penberg@cs.helsinki.fi>
>>> wrote:
>>>
>>>>
>>>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>>>
>>>> If we leave the camera disabled by default, userspace programs (e.g.
>>>> Skype, Cheese) leave the user out in the cold saying that the machine
>>>> "has
>>>> no camera." Therefore, it's better to enable camera by default and let
>>>> people who really don't want it just disable the thing.
>>>>
>>>> Cc: <acpi4asus-user@lists.sourceforge.net>
>>>> Cc: Len Brown <len.brown@intel.com>
>>>> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
>>>> ---
>>>>  drivers/platform/x86/eeepc-laptop.c |   16 ++++++++++++++++
>>>>  1 files changed, 16 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/platform/x86/eeepc-laptop.c
>>>> b/drivers/platform/x86/eeepc-laptop.c
>>>> index 353a898..c0f8eb1 100644
>>>> --- a/drivers/platform/x86/eeepc-laptop.c
>>>> +++ b/drivers/platform/x86/eeepc-laptop.c
>>>> @@ -334,6 +334,19 @@ static int eeepc_bluetooth_rfkill_state(void *data,
>>>> enum rfkill_state *state)
>>>>  }
>>>>
>>>>  /*
>>>> + * Camera helpers
>>>> + */
>>>> +
>>>> +static void eeepc_enable_camera(void)
>>>> +{
>>>> +       int err;
>>>> +
>>>> +       err = set_acpi(CM_ASL_CAMERA, 1);
>>>> +       if (err)
>>>> +               printk(EEEPC_WARNING "Unable to enable camera %d\n",
>>>> err);
>>>> +}
>>>> +
>>>> +/*
>>>>  * Sys helpers
>>>>  */
>>>>  static int parse_arg(const char *buf, unsigned long count, int *val)
>>>> @@ -996,6 +1009,9 @@ static int __init eeepc_laptop_init(void)
>>>>       result = eeepc_hwmon_init(dev);
>>>>       if (result)
>>>>               goto fail_hwmon;
>>>> +
>>>> +       eeepc_enable_camera();
>>>> +
>>>>       /* Register platform stuff */
>>>>       result = platform_driver_register(&platform_driver);
>>>>       if (result)
>>>> --
>>>> 1.5.6.3
>>>>
>>>>
>>>>
>>>
>>> Hi,
>>> First, I think a one line
>>> set_acpi(CM_ASL_CAMERA, 1);
>>> with a small comment is better. (If it fails, it's because there no
>>> camera, so we don't mind).
>>>
>>> Anyway, I'm not sure it's a good idea to enable the camera by default.
>>> It depends how many
>>> power the camera is using (when idle). Coud you check that (with power
>>> top maybe ?).
>>>
>>> Thanks
>>>
>>
>> From our old measurements:
>>
>> idle camera is ~20mA out of ~650mA total power... (measured on 901 model).
>>
>> Woody
>>
>> --
>> Woody Suwalski, Xandros, Ottawa, Canada, 1-613-842-3498 x414
>>
>>
>
> Do also have some results with
> echo -n auto > /sys/bus/usb/drivers/uvcvideo/*:*/../power/level
>
> ?

Can I also ask if you tested with

CONFIG_NO_HZ=y

?  IIRC, the kernel shipped on my old Eee didn't have NOHZ.  Without
NOHZ, it won't save much _cpu_ power; cutting 10 wakeups/s off >100
won't make much difference.

Ta
Alan
