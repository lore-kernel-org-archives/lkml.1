Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbYGXAHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbYGXAHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbYGXAHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:07:39 -0400
Received: from ns1.spydercomm.com ([69.64.58.82]:58785 "EHLO
	neon.spydercomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbYGXAHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:07:37 -0400
X-Greylist: delayed 2569 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 20:07:37 EDT
Message-ID: <4887BDAA.6040303@queuemail.com>
Date: Wed, 23 Jul 2008 19:24:26 -0400
From: paul s <mactel-linux.org-users@queuemail.com>
Reply-To: mactel-linux.org-users@queuemail.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: roberto@unbit.it
CC: mactel-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Mactel-linux-devel] [PATCH] Support for Intel iMac in applesmc
References: <1216814135.5834.9.camel@sirius>
In-Reply-To: <1216814135.5834.9.camel@sirius>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.1.12 (neon.spydercomm.com [69.64.58.82]); Wed, 23 Jul 2008 19:24:22 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applying these changes manually to the 2.6.25.10 source loads the 
applesmc on the imac 7,1 as well and recognizes the three fans...

cheers
paul



Roberto De Ioris wrote:
> Hi all, this patch (2.6.26 vanilla) add supports for fans and
> temperature sensors on intel iMac.
> 
> Tested on iMac 24" 2.8ghz (iMac8,1), it supports the following sensors:
> 
> cpu A
> ambient
> gpu
> gpu diode
> gpu heatsink
> hd bay 1
> memory controller
> optical drive
> power
> 
> Signed-off-by: Roberto De Ioris <roberto@unbit.it>
> ---
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index aacc0c4..bc616c3 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -98,6 +98,8 @@ static const char* temperature_sensors_sets[][36] = {
>           "TH1P", "TH2P", "TH3P", "TMAP", "TMAS", "TMBS", "TM0P",
> "TM0S",
>           "TM1P", "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S",
> "TM9P",
>           "TM9S", "TN0H", "TS0C", NULL },
> +/* Set 5: iMac */
> +       { "TC0D", "TA0P", "TG0P", "TG0D", "TG0H", "TH0P", "Tm0P",
> "TO0P", "Tp0C", NULL },
>  };
>  
>  /* List of keys used to read/write fan speeds */
> @@ -1223,6 +1225,8 @@ static __initdata struct dmi_match_data
> applesmc_dmi_data[] = {
>         { .accelerometer = 0, .light = 0, .temperature_set = 3 },
>  /* MacPro: temperature set 4 */
>         { .accelerometer = 0, .light = 0, .temperature_set = 4 },
> +/* iMac: temperature set 5 */
> +       { .accelerometer = 0, .light = 0, .temperature_set = 5 },
>  };
>  
>  /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
> @@ -1248,6 +1252,10 @@ static __initdata struct dmi_system_id
> applesmc_whitelist[] = {
>           DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
>           DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
>                 (void*)&applesmc_dmi_data[4]},
> +       { applesmc_dmi_match, "Apple iMac", {
> +         DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> +         DMI_MATCH(DMI_PRODUCT_NAME,"iMac") },
> +               (void*)&applesmc_dmi_data[5]},
>         { .ident = NULL }
>  };
> 
> 
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Mactel-linux-devel mailing list
> Mactel-linux-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/mactel-linux-devel
