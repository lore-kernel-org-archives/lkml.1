Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbZFEVBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbZFEVBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbZFEVBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:01:38 -0400
Received: from ottmail.xandros.com ([142.46.212.35]:60972 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZFEVBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:01:37 -0400
Date: Fri, 5 Jun 2009 17:01:29 -0400
From: Woody Suwalski <woodys@xandros.com>
To: Corentin Chary <corentin.chary@gmail.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Message-ID: <4A2987A9.2010202@xandros.com>
In-Reply-To: <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
References: <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corentin Chary wrote:
> On Fri, Jun 5, 2009 at 10:59 AM, Pekka J Enberg<penberg@cs.helsinki.fi> wrote:
>   
>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> If we leave the camera disabled by default, userspace programs (e.g.
>> Skype, Cheese) leave the user out in the cold saying that the machine "has
>> no camera." Therefore, it's better to enable camera by default and let
>> people who really don't want it just disable the thing.
>>
>> Cc: <acpi4asus-user@lists.sourceforge.net>
>> Cc: Len Brown <len.brown@intel.com>
>> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
>> ---
>>  drivers/platform/x86/eeepc-laptop.c |   16 ++++++++++++++++
>>  1 files changed, 16 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
>> index 353a898..c0f8eb1 100644
>> --- a/drivers/platform/x86/eeepc-laptop.c
>> +++ b/drivers/platform/x86/eeepc-laptop.c
>> @@ -334,6 +334,19 @@ static int eeepc_bluetooth_rfkill_state(void *data, enum rfkill_state *state)
>>  }
>>
>>  /*
>> + * Camera helpers
>> + */
>> +
>> +static void eeepc_enable_camera(void)
>> +{
>> +       int err;
>> +
>> +       err = set_acpi(CM_ASL_CAMERA, 1);
>> +       if (err)
>> +               printk(EEEPC_WARNING "Unable to enable camera %d\n", err);
>> +}
>> +
>> +/*
>>  * Sys helpers
>>  */
>>  static int parse_arg(const char *buf, unsigned long count, int *val)
>> @@ -996,6 +1009,9 @@ static int __init eeepc_laptop_init(void)
>>        result = eeepc_hwmon_init(dev);
>>        if (result)
>>                goto fail_hwmon;
>> +
>> +       eeepc_enable_camera();
>> +
>>        /* Register platform stuff */
>>        result = platform_driver_register(&platform_driver);
>>        if (result)
>> --
>> 1.5.6.3
>>
>>
>>     
>
> Hi,
> First, I think a one line
> set_acpi(CM_ASL_CAMERA, 1);
> with a small comment is better. (If it fails, it's because there no
> camera, so we don't mind).
>
> Anyway, I'm not sure it's a good idea to enable the camera by default.
> It depends how many
> power the camera is using (when idle). Coud you check that (with power
> top maybe ?).
>
> Thanks
>   
 From our old measurements:

 idle camera is ~20mA out of ~650mA total power... (measured on 901 model).

Woody

-- 
Woody Suwalski, Xandros, Ottawa, Canada, 1-613-842-3498 x414

