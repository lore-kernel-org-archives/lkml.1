Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZFFQ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZFFQ7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 12:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZFFQ7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 12:59:05 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:10158 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZFFQ7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 12:59:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gnOX27y6Y+ROBcMZnassHGpIzMFgTF/nez1A7yOyiLci9qURK/EsZP0jWBLuP7ixGc
         dgTc5UBlCMZ+5OJIcajAk5NhMB8iqq2+0VT2xlxRP5RmGwql6pOSqWoKECKu5ibQqHDq
         /6Sq5GDA7N5E/jYldq43Ih7yIwE7OspwqEIlg=
MIME-Version: 1.0
In-Reply-To: <4A28BC20.3010307@samsung.com>
References: <4A28BC20.3010307@samsung.com>
Date: Sat, 6 Jun 2009 22:29:03 +0530
Message-ID: <5d5443650906060959w678a29acn8200239d35869dca@mail.gmail.com>
Subject: Re: [PATCH v3] add MAX17040 Fuel Gauge driver
From: Trilok Soni <soni.trilok@gmail.com>
To: Minkyu Kang <mk7.kang@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-i2c@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minkyu Kang,

On Fri, Jun 5, 2009 at 12:03 PM, Minkyu Kang<mk7.kang@samsung.com> wrote:
> The MAX17040 is a I2C interfaced Fuel Gauge systems for lithium-ion batteries
> This patch adds support the MAX17040 Fuel Gauge
>

Thanks for making change. Some more comments.

>  endif # POWER_SUPPLY
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 2fcf41d..9c48995 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -25,4 +25,5 @@ obj-$(CONFIG_BATTERY_TOSA)    += tosa_battery.o
>  obj-$(CONFIG_BATTERY_WM97XX)   += wm97xx_battery.o
>  obj-$(CONFIG_BATTERY_BQ27x00)  += bq27x00_battery.o
>  obj-$(CONFIG_BATTERY_DA9030)   += da9030_battery.o
> -obj-$(CONFIG_CHARGER_PCF50633) += pcf50633-charger.o
> \ No newline at end of file
> +obj-$(CONFIG_BATTERY_MAX17040))        += max17040_battery.o

Are we following any alphabetical order in this Makefile?

> +static int max17040_suspend(struct i2c_client *client,
> +               pm_message_t state)
> +{
> +       struct max17040_chip *chip = i2c_get_clientdata(client);
> +
> +       cancel_delayed_work(&chip->work);
> +       return 0;
> +}
> +
> +static int max17040_resume(struct i2c_client *client)
> +{
> +       struct max17040_chip *chip = i2c_get_clientdata(client);
> +
> +       schedule_delayed_work(&chip->work, MAX17040_DELAY);
> +       return 0;
> +}
> +

Please add #ifdef CONFIG_PM around suspend resume functions.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
