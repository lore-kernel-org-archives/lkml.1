Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747Ab0A0QZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0A0QZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522Ab0A0QZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:25:50 -0500
Received: from poutre.nerim.net ([62.4.16.124]:54134 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab0A0QZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:25:49 -0500
Date: Wed, 27 Jan 2010 17:25:46 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       giometti@linux.it
Subject: Re: [PATCH 2/2] als: tsl2550: Remove spurious check against a
 maximum  lux value.
Message-ID: <20100127172546.42e09e1f@hyperion.delvare>
In-Reply-To: <4B60535F.5020400@cam.ac.uk>
References: <4B23D029.9080004@cam.ac.uk>
	<20100126105138.1006aaad@hyperion.delvare>
	<4B5F38A3.1030208@cam.ac.uk>
	<4B5F3961.3090103@jic23.retrosnub.co.uk>
	<4B5F3AFE.7020404@cam.ac.uk>
	<20100127143659.784201ef@hyperion.delvare>
	<4B605000.8050500@jic23.retrosnub.co.uk>
	<4B6052A0.9090907@cam.ac.uk>
	<4B60535F.5020400@cam.ac.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 14:53:19 +0000, Jonathan Cameron wrote:
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
> 
> As Jean Delvare observed, this check is ineffective so lets clear it out whilst
> we are working on this driver.
> 
>  drivers/als/tsl2550.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/als/tsl2550.c b/drivers/als/tsl2550.c
> index b911e9c..27745a5 100644
> --- a/drivers/als/tsl2550.c
> +++ b/drivers/als/tsl2550.c
> @@ -116,8 +116,6 @@ static int tsl2550_get_adc_value(struct i2c_client *client, u8 cmd)
>   * of infrared level and visible light levels.
>   */
>  
> -#define	TSL2550_MAX_LUX		1846
> -
>  static const u8 ratio_lut[] = {
>  	100, 100, 100, 100, 100, 100, 100, 100,
>  	100, 100, 100, 100, 100, 100, 99, 99,
> @@ -187,8 +185,7 @@ static int tsl2550_calculate_lux(u8 ch0, u8 ch1)
>  	else
>  		return -EAGAIN;
>  
> -	/* LUX range check */
> -	return lux > TSL2550_MAX_LUX ? TSL2550_MAX_LUX : lux;
> +	return lux;
>  }
>  
>  /*


-- 
Jean Delvare
