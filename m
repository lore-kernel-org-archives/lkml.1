Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXG0Mti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXG0Mti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbXG0Mtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:49:31 -0400
Received: from thoth.sbs.de ([192.35.17.2]:21981 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706AbXG0Mta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:49:30 -0400
X-Greylist: delayed 1469 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 08:49:30 EDT
Subject: Re: [PATCH] Fix regression caused by typo in lm90.c
From: Rainer Birkenmaier <rainer.birkenmaier@siemens.com>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
In-Reply-To: <20070726230422.2955.70451.sendpatchset@localhost.localdomain>
References: <20070726230422.2955.70451.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Organization: Siemens AG, CT SE 2
Date: Fri, 27 Jul 2007 14:24:23 +0200
Message-Id: <1185539063.6855.2.camel@ella.mchp.siemens.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my original patch for this didn't have that typo, however I had spelled
it in small letters instead of capital letters. So I guess, the typo
sneaked in while switching from small to capital letter.

Main message: I can confirm that it actually is a typo :)

have a great day
/Rainer

Am Freitag, den 27.07.2007, 01:04 +0200 schrieb Guillaume Chazarain:
> Hi,
> 
> The commit http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=32c82a934759b2c9939c9e25865c2d7d1204b9e8
> broke lm90 for my (Asus V6VA) laptop.
> 
> Before 2.6.23-rc1 and with the following patch, I get:
> 
> [g ~]$ sensors
> max6657-i2c-0-4c
> Adapter: SMBus I801 adapter at 0400
> M/B Temp:    +64°C  (low  =    +0°C, high =  +127°C)   
> CPU Temp:  +78.9°C  (low  = +73.2°C, high = +88.2°C)   
> M/B Crit:   +105°C  (hyst =   +95°C)                   
> CPU Crit:   +105°C  (hyst =   +95°C)                   
> 
> Which regressed into:
> 
> [g ~]$ sensors
> No sensors found!
> Make sure you loaded all the kernel drivers you need.
> Try sensors-detect to find out which these are.
> zsh: 2701 exit 1     sensors
> 
> and dmesg contains:
> 
> i2c-adapter i2c-0: Unsupported chip (man_id=0x4D, chip_id=0x4D).
> 
> It seems to be a typo, as address 0X4F is mentionned nowhere else in the file,
> and my chip is actually at 0x4C.
> 
> Thanks.
> 
> Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
> ---
> 
> diff -r 4cad6fced1a8 drivers/hwmon/lm90.c
> --- a/drivers/hwmon/lm90.c	Thu Jul 26 13:44:58 2007 -0700
> +++ b/drivers/hwmon/lm90.c	Tue Jul 24 00:02:52 2007 +0200
> @@ -585,7 +585,7 @@ static int lm90_detect(struct i2c_adapte
>  			 * those of the man_id register.
>  			 */
>  			if (chip_id == man_id
> -			 && (address == 0x4F || address == 0x4D)
> +			 && (address == 0x4C || address == 0x4D)
>  			 && (reg_config1 & 0x1F) == (man_id & 0x0F)
>  			 && reg_convrate <= 0x09) {
>  			 	kind = max6657;
-- 
>>> SIEMENS AG - Corporate Technology (CT SE 2)        <<<
>>> Dipl.-Inf. Rainer Birkenmaier                      <<<
>>>              email: rainer.birkenmaier@siemens.com <<<
>>>     phone: +49-89-636-53725  fax: +49-89-636-45450 <<<

Siemens Aktiengesellschaft: Vorsitzender des Aufsichtsrats: Gerhard Cromme
Vorstand: Peter L�scher, Vorsitzender; Johannes Feldmayer, Heinrich
Hiesinger, Joe Kaeser, Rudi Lamprecht, Eduardo Montes, 
J�rgen Radomski, Erich R. Reinhardt, Hermann Requardt, Uriel J. Sharef,
Klaus Wucherer
Sitz der Gesellschaft: Berlin und M�nchen; Registergericht: Berlin
Charlottenburg, HRB 12300, M�nchen, HRB 6684
WEEE-Reg.-Nr. DE 23691322

