Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZCEOZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZCEOZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZCEOZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:25:30 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:48826 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZCEOZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:25:29 -0500
Date: Thu, 5 Mar 2009 15:25:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] lm90: Support the MAX6648/6692 chips
Message-ID: <20090305152517.4e0b8983@hyperion.delvare>
In-Reply-To: <20090302210106.GD6550@plum>
References: <20090302210106.GD6550@plum>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick

On Mon, 2 Mar 2009 13:01:06 -0800, Darrick J. Wong wrote:
> The max6648 chip has nearly the same register set as the 6657 and
> seems to have a working manufacturer/chip id so we can detect it.
> This patch adds support for it.  Tested on a Nvidia Quadro FX 1500
> card.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/hwmon/Kconfig |    4 ++--
>  drivers/hwmon/lm90.c  |    7 ++++++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 8c312c6..7da49d3 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -550,8 +550,8 @@ config SENSORS_LM90
>  	help
>  	  If you say yes here you get support for National Semiconductor LM90,
>  	  LM86, LM89 and LM99, Analog Devices ADM1032 and ADT7461, and Maxim
> -	  MAX6646, MAX6647, MAX6649, MAX6657, MAX6658, MAX6659, MAX6680 and
> -	  MAX6681 sensor chips.
> +	  MAX6646, MAX6647, MAX6649, MAX6657, MAX6658, MAX6659, MAX6680,
> +	  MAX6648, MAX6692 and MAX6681 sensor chips.
>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called lm90.
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index 96a7018..1802366 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -776,7 +776,12 @@ static int lm90_detect(struct i2c_client *new_client, int kind,
>  			 && (reg_config1 & 0x3f) == 0x00
>  			 && reg_convrate <= 0x07) {
>  				kind = max6646;
> -			}
> +			} else
> +			/* The MAX6648/6692 chips have a working man/chip id
> +			 * and the same register set as the 6657.
> +			 */
> +			if (chip_id == 0x59 && address == 0x4C)
> +				kind = max6657;
>  		}
>  
>  		if (kind <= 0) { /* identification failed */

I am confused. According to my notes, the MAX6648/MAX6692 is the same
chip as the MAX6646/MAX6647/MAX6649 (same chip ID of 0x59), the only
difference being the I2C address (0x4c for the MAX6646, 0x4e for the
MAX6647 and 0x4d for the MAX6648/MAX6649/MAX6692). So the current code
should _already_ detect your MAX6648 or MAX6692 as kind = max6646.

Can you please test the latest version of the sensors-detect script [1]
and let me know if your chip is properly detected? If not, please
provide a dump of your chip.

[1] http://www.lm-sensors.org/svn/lm-sensors/trunk/prog/detect/sensors-detect

-- 
Jean Delvare
