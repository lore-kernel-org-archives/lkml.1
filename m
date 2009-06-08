Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZFHVAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZFHVAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZFHVAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:00:08 -0400
Received: from ru.mvista.com ([213.79.90.228]:18712 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751203AbZFHVAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:00:07 -0400
Date: Tue, 9 Jun 2009 01:00:07 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Minkyu Kang <mk7.kang@samsung.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org,
       Anton Vorontsov <cbou@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>, kyungmin.park@samsung.com
Subject: Re: [PATCH v3] add MAX17040 Fuel Gauge driver
Message-ID: <20090608210007.GA29332@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <4A28BC20.3010307@samsung.com> <5d5443650906060959w678a29acn8200239d35869dca@mail.gmail.com> <4A2C7911.80407@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A2C7911.80407@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 11:36:01AM +0900, Minkyu Kang wrote:
> Dear Trilok Soni,
> 
> Thanks for review
> 
> > Hi Minkyu Kang,
> > 
> > On Fri, Jun 5, 2009 at 12:03 PM, Minkyu Kang<mk7.kang@samsung.com> wrote:
> >> The MAX17040 is a I2C interfaced Fuel Gauge systems for lithium-ion batteries
> >> This patch adds support the MAX17040 Fuel Gauge
> >>
> > 
> > Thanks for making change. Some more comments.
> > 
> >>  endif # POWER_SUPPLY
> >> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> >> index 2fcf41d..9c48995 100644
> >> --- a/drivers/power/Makefile
> >> +++ b/drivers/power/Makefile
> >> @@ -25,4 +25,5 @@ obj-$(CONFIG_BATTERY_TOSA)    += tosa_battery.o
> >>  obj-$(CONFIG_BATTERY_WM97XX)   += wm97xx_battery.o
> >>  obj-$(CONFIG_BATTERY_BQ27x00)  += bq27x00_battery.o
> >>  obj-$(CONFIG_BATTERY_DA9030)   += da9030_battery.o
> >> -obj-$(CONFIG_CHARGER_PCF50633) += pcf50633-charger.o
> >> \ No newline at end of file
> >> +obj-$(CONFIG_BATTERY_MAX17040))        += max17040_battery.o

There is a typo: "))" should be just ")". I fixed this.

I also fixed "‘max17040_set_rcomp’ defined but not used" warning
(just removed this function).

> > Are we following any alphabetical order in this Makefile?
> > 
> 
> I'm not sure either. :(
> I just grouping with batteries.

It's fine as is. I always wonder when somebody try to sort things
alphabetically. Humans should not bother with sorting, that's what
computers are for! ;-)

> >> +static int max17040_suspend(struct i2c_client *client,
> >> +               pm_message_t state)
> >> +{
> >> +       struct max17040_chip *chip = i2c_get_clientdata(client);
> >> +
> >> +       cancel_delayed_work(&chip->work);
> >> +       return 0;
> >> +}
> >> +
> >> +static int max17040_resume(struct i2c_client *client)
> >> +{
> >> +       struct max17040_chip *chip = i2c_get_clientdata(client);
> >> +
> >> +       schedule_delayed_work(&chip->work, MAX17040_DELAY);
> >> +       return 0;
> >> +}
> >> +
> > 
> > Please add #ifdef CONFIG_PM around suspend resume functions.
> > 
> 
> Ok, I will.

Just did it myself, and queued this patch for 2.6.31.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
