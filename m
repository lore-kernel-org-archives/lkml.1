Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZFHCgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZFHCgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 22:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZFHCga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 22:36:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50972 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbZFHCg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 22:36:29 -0400
Date: Mon, 08 Jun 2009 11:36:01 +0900
From: Minkyu Kang <mk7.kang@samsung.com>
Subject: Re: [PATCH v3] add MAX17040 Fuel Gauge driver
In-reply-to: <5d5443650906060959w678a29acn8200239d35869dca@mail.gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-i2c@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>, kyungmin.park@samsung.com
Message-id: <4A2C7911.80407@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
References: <4A28BC20.3010307@samsung.com>
 <5d5443650906060959w678a29acn8200239d35869dca@mail.gmail.com>
X-OriginalArrivalTime: 08 Jun 2009 02:36:02.0108 (UTC)
 FILETIME=[DD2C0FC0:01C9E7E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Trilok Soni,

Thanks for review

> Hi Minkyu Kang,
> 
> On Fri, Jun 5, 2009 at 12:03 PM, Minkyu Kang<mk7.kang@samsung.com> wrote:
>> The MAX17040 is a I2C interfaced Fuel Gauge systems for lithium-ion batteries
>> This patch adds support the MAX17040 Fuel Gauge
>>
> 
> Thanks for making change. Some more comments.
> 
>>  endif # POWER_SUPPLY
>> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
>> index 2fcf41d..9c48995 100644
>> --- a/drivers/power/Makefile
>> +++ b/drivers/power/Makefile
>> @@ -25,4 +25,5 @@ obj-$(CONFIG_BATTERY_TOSA)    += tosa_battery.o
>>  obj-$(CONFIG_BATTERY_WM97XX)   += wm97xx_battery.o
>>  obj-$(CONFIG_BATTERY_BQ27x00)  += bq27x00_battery.o
>>  obj-$(CONFIG_BATTERY_DA9030)   += da9030_battery.o
>> -obj-$(CONFIG_CHARGER_PCF50633) += pcf50633-charger.o
>> \ No newline at end of file
>> +obj-$(CONFIG_BATTERY_MAX17040))        += max17040_battery.o
> 
> Are we following any alphabetical order in this Makefile?
> 

I'm not sure either. :(
I just grouping with batteries.

>> +static int max17040_suspend(struct i2c_client *client,
>> +               pm_message_t state)
>> +{
>> +       struct max17040_chip *chip = i2c_get_clientdata(client);
>> +
>> +       cancel_delayed_work(&chip->work);
>> +       return 0;
>> +}
>> +
>> +static int max17040_resume(struct i2c_client *client)
>> +{
>> +       struct max17040_chip *chip = i2c_get_clientdata(client);
>> +
>> +       schedule_delayed_work(&chip->work, MAX17040_DELAY);
>> +       return 0;
>> +}
>> +
> 
> Please add #ifdef CONFIG_PM around suspend resume functions.
> 

Ok, I will.
Thanks

---
from, prom.

