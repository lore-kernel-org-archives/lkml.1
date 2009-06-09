Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZFIBNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZFIBNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 21:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZFIBM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 21:12:59 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:40117 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZFIBM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 21:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AqSb2Wf6r9n0UO+Xkb9RGsQESddbbtEThopDt3Zy7P0wawIL+9eNDXHO1j6JFUL3Qe
         l0iLpoBgy4o7NynhchYwJnxbn/6sqQvSUwsaltXdchRWiS9GXt9bLzr8FWS4KYq78QQz
         PNDc7kIZgFq8A9F/3UR0xfe6Ssg8+M780HZD4=
MIME-Version: 1.0
In-Reply-To: <20090608210007.GA29332@oksana.dev.rtsoft.ru>
References: <4A28BC20.3010307@samsung.com>
	 <5d5443650906060959w678a29acn8200239d35869dca@mail.gmail.com>
	 <4A2C7911.80407@samsung.com>
	 <20090608210007.GA29332@oksana.dev.rtsoft.ru>
Date: Tue, 9 Jun 2009 10:12:58 +0900
Message-ID: <1f3430fb0906081812j69f35b18tde3d4ab5d80b504@mail.gmail.com>
Subject: Re: [PATCH v3] add MAX17040 Fuel Gauge driver
From: Minkyu Kang <promsoft@gmail.com>
To: avorontsov@ru.mvista.com
Cc: Minkyu Kang <mk7.kang@samsung.com>, Trilok Soni <soni.trilok@gmail.com>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-i2c@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>, kyungmin.park@samsung.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear, Anton Vorontsov

2009/6/9 Anton Vorontsov <avorontsov@ru.mvista.com>:
> On Mon, Jun 08, 2009 at 11:36:01AM +0900, Minkyu Kang wrote:
>> Dear Trilok Soni,
>>
>> Thanks for review
>>
>> > Hi Minkyu Kang,
>> >
>> > On Fri, Jun 5, 2009 at 12:03 PM, Minkyu Kang<mk7.kang@samsung.com> wrote:
>> >> The MAX17040 is a I2C interfaced Fuel Gauge systems for lithium-ion batteries
>> >> This patch adds support the MAX17040 Fuel Gauge
>> >>
>> >
>> > Thanks for making change. Some more comments.
>> >
>> >>  endif # POWER_SUPPLY
>> >> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
>> >> index 2fcf41d..9c48995 100644
>> >> --- a/drivers/power/Makefile
>> >> +++ b/drivers/power/Makefile
>> >> @@ -25,4 +25,5 @@ obj-$(CONFIG_BATTERY_TOSA)    += tosa_battery.o
>> >>  obj-$(CONFIG_BATTERY_WM97XX)   += wm97xx_battery.o
>> >>  obj-$(CONFIG_BATTERY_BQ27x00)  += bq27x00_battery.o
>> >>  obj-$(CONFIG_BATTERY_DA9030)   += da9030_battery.o
>> >> -obj-$(CONFIG_CHARGER_PCF50633) += pcf50633-charger.o
>> >> \ No newline at end of file
>> >> +obj-$(CONFIG_BATTERY_MAX17040))        += max17040_battery.o
>
> There is a typo: "))" should be just ")". I fixed this.
>
> I also fixed "‘max17040_set_rcomp’ defined but not used" warning
> (just removed this function).

I missed it. thanks.

>> > Are we following any alphabetical order in this Makefile?
>> >
>>
>> I'm not sure either. :(
>> I just grouping with batteries.
>
> It's fine as is. I always wonder when somebody try to sort things
> alphabetically. Humans should not bother with sorting, that's what
> computers are for! ;-)
>
>> >> +static int max17040_suspend(struct i2c_client *client,
>> >> +               pm_message_t state)
>> >> +{
>> >> +       struct max17040_chip *chip = i2c_get_clientdata(client);
>> >> +
>> >> +       cancel_delayed_work(&chip->work);
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static int max17040_resume(struct i2c_client *client)
>> >> +{
>> >> +       struct max17040_chip *chip = i2c_get_clientdata(client);
>> >> +
>> >> +       schedule_delayed_work(&chip->work, MAX17040_DELAY);
>> >> +       return 0;
>> >> +}
>> >> +
>> >
>> > Please add #ifdef CONFIG_PM around suspend resume functions.
>> >
>>
>> Ok, I will.
>
> Just did it myself, and queued this patch for 2.6.31.
>
> Thanks!
>

Ok, I appreciate your help.
Many Thanks :)

-- 
from. prom.
promsoft.net
