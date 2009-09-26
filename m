Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZIZLYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZIZLYt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 07:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZIZLYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 07:24:48 -0400
Received: from poutre.nerim.net ([62.4.16.124]:62298 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbZIZLYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 07:24:48 -0400
Date: Sat, 26 Sep 2009 13:24:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: lm-sensors@lm-sensors.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [lm-sensors] [PATCH] hwmon: Fix spurious section mismatch
 warning  in sht15.c
Message-ID: <20090926132448.2374507c@hyperion.delvare>
In-Reply-To: <b9df5fa10909230701u128fbec2x78bb433e3a2f42b@mail.gmail.com>
References: <b9df5fa10909230701u128fbec2x78bb433e3a2f42b@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabik,

On Wed, 23 Sep 2009 20:01:47 +0600, Rakib Mullick wrote:
> Fix spurious section mismatch warnings, caused due to reference from
> variable sht_drivers to
>  __devinit/__devexit functions sht15_probe()/remove().
> 
>  We were warned by the following warnings:
> 
>   LD      drivers/hwmon/built-in.o
> WARNING: drivers/hwmon/built-in.o(.data+0x264a0): Section mismatch in
> reference from the variable sht_drivers to the function
> .devinit.text:sht15_probe()
> The variable sht_drivers references
> the function __devinit sht15_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> WARNING: drivers/hwmon/built-in.o(.data+0x264a4): Section mismatch in
> reference from the variable sht_drivers to the function
> .devexit.text:sht15_remove()
> The variable sht_drivers references
> the function __devexit sht15_remove()
> If the reference is valid then annotate the
> variable with __exit* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> WARNING: drivers/hwmon/built-in.o(.data+0x264f0): Section mismatch in
> reference from the variable sht_drivers to the function
> .devinit.text:sht15_probe()
> The variable sht_drivers references
> the function __devinit sht15_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> WARNING: drivers/hwmon/built-in.o(.data+0x264f4): Section mismatch in
> reference from the variable sht_drivers to the function
> .devexit.text:sht15_remove()
> The variable sht_drivers references
> the function __devexit sht15_remove()
> If the reference is valid then annotate the
> variable with __exit* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> WARNING: drivers/hwmon/built-in.o(.data+0x26540): Section mismatch in
> reference from the variable sht_drivers to the function
> .devinit.text:sht15_probe()
> The variable sht_drivers references
> the function __devinit sht15_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> WARNING: drivers/hwmon/built-in.o(.data+0x26544): Section mismatch in
> reference from the variable sht_drivers to the function
> .devexit.text:sht15_remove()
> The variable sht_drivers references
> the function __devexit sht15_remove()
> If the reference is valid then annotate the
> variable with __exit* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> WARNING: drivers/hwmon/built-in.o(.data+0x26590): Section mismatch in
> reference from the variable sht_drivers to the function
> .devinit.text:sht15_probe()
> The variable sht_drivers references
> the function __devinit sht15_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> -------
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linus/drivers/hwmon/sht15.c	2009-09-22 16:28:07.000000000 +0600
> +++ rakib/drivers/hwmon/sht15.c	2009-09-23 14:47:48.000000000 +0600
> @@ -619,8 +619,12 @@ static int __devexit sht15_remove(struct
>  	return 0;
>  }
> 
> -
> -static struct platform_driver sht_drivers[] = {
> +/*
> + * sht_drivers simultaneously refers to __devinit and __devexit function
> + * which causes spurious section mismatch warning. So use __refdata to
> + * get rid from this.
> + */
> +static struct platform_driver __refdata sht_drivers[] = {
>  	{
>  		.driver = {
>  			.name = "sht10",

Looks sane, applied, thanks. Jonathan, no objection?

-- 
Jean Delvare
