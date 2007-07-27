Return-Path: <linux-kernel-owner+w=401wt.eu-S1764130AbXG0IZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764130AbXG0IZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 04:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbXG0IZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 04:25:21 -0400
Received: from zone4.gcu.info ([217.195.17.234]:53756 "EHLO
	zone4.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbXG0IZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 04:25:18 -0400
X-Greylist: delayed 992 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 04:25:18 EDT
Date: Fri, 27 Jul 2007 10:07:45 +0200 (CEST)
To: guichaz@yahoo.fr, mhoffman@lightlink.com
Subject: Re: [PATCH] Fix regression caused by typo in lm90.c
X-IlohaMail-Blah: khali@localhost
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.14 (On: mail.gcu-squad.org)
Message-ID: <BbJeFUOL.1185523665.8121830.khali@localhost>
In-Reply-To: <20070726230422.2955.70451.sendpatchset@localhost.localdomain>
From: "Jean Delvare" <khali@linux-fr.org>
Bounce-To: "Jean Delvare" <khali@linux-fr.org>
CC: "Rainer Birkenmaier" <rainer.birkenmaier@siemens.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Guillaume,

On 7/26/2007, "Guillaume Chazarain" <guichaz@yahoo.fr> wrote:
>The commit http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=32c82a934759b2c9939c9e25865c2d7d1204b9e8
>broke lm90 for my (Asus V6VA) laptop.
>
>Before 2.6.23-rc1 and with the following patch, I get:
>
>[g ~]$ sensors
>max6657-i2c-0-4c
>Adapter: SMBus I801 adapter at 0400
>M/B Temp:    +64°C  (low  =    +0°C, high =  +127°C)
>CPU Temp:  +78.9°C  (low  = +73.2°C, high = +88.2°C)
>M/B Crit:   +105°C  (hyst =   +95°C)
>CPU Crit:   +105°C  (hyst =   +95°C)
>
>Which regressed into:
>
>[g ~]$ sensors
>No sensors found!
>Make sure you loaded all the kernel drivers you need.
>Try sensors-detect to find out which these are.
>zsh: 2701 exit 1     sensors
>
>and dmesg contains:
>
>i2c-adapter i2c-0: Unsupported chip (man_id=0x4D, chip_id=0x4D).
>
>It seems to be a typo, as address 0X4F is mentionned nowhere else in the
>file, and my chip is actually at 0x4C.

You are right :( Sorry for missing it.

>Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
>---
>
>diff -r 4cad6fced1a8 drivers/hwmon/lm90.c
>--- a/drivers/hwmon/lm90.c	Thu Jul 26 13:44:58 2007 -0700
>+++ b/drivers/hwmon/lm90.c	Tue Jul 24 00:02:52 2007 +0200
>@@ -585,7 +585,7 @@ static int lm90_detect(struct i2c_adapte
> 			 * those of the man_id register.
> 			 */
> 			if (chip_id == man_id
>-			 && (address == 0x4F || address == 0x4D)
>+			 && (address == 0x4C || address == 0x4D)
> 			 && (reg_config1 & 0x1F) == (man_id & 0x0F)
> 			 && reg_convrate <= 0x09) {
> 			 	kind = max6657;

Signed-off-by: Jean Delvare <khali@linux-fr.org>

Mark, please apply.

--
Jean Delvare
