Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab0AOPhT (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 10:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780Ab0AOPhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 10:37:18 -0500
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:49999 "EHLO
	elettra.colt-to.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423Ab0AOPhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 10:37:17 -0500
Date: Fri, 15 Jan 2010 16:37:12 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: lethal@linux-sh.org, Dale Farnsworth <dale@farnsworth.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH] rtc: rtc-max6900: SMBus support.
Message-ID: <20100115163712.3e54861d@linux.lan.towertech.it>
In-Reply-To: <20100114113235.GA20473@linux-sh.org>
References: <20100114113235.GA20473@linux-sh.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 20:32:35 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> The current rtc-max6900 driver only supports getting and setting the time
> through bursting, which requires a controller capable of such. As
> bursting is merely an optimization, we can also opt for the non-burst
> fallback path that pokes at the date/time registers individually.

 almost ok, review below.


> -static int max6900_i2c_read_regs(struct i2c_client *client, u8 *buf)
> +static unsigned int smbus_mode;	/* disabled by default, prefer bursting */

 that one should be per-device.

> +static int max6900_i2c_smbus_read(struct i2c_client *client, u8 *buf)
> +{
> +	int rc = 0, i;

 no need to init rc

> +static int max6900_i2c_smbus_write(struct i2c_client *client, u8 const *buf)
> +{
> +	int rc = 0, i;
> +
> +	for (i = 0; i < MAX6900_REG_LEN; i++)
> +		rc |= i2c_smbus_write_byte_data(client,
> +				MAX6900_REG_WRITE(i), buf[i]);

 please check rc at each write.

 you might want to check if you'll have troubles if you read/write
 when the minutes are changing.

 you might also want to investigate block SMbus messages. 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

