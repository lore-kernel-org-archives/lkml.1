Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbYFTGOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbYFTGOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 02:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYFTGNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 02:13:53 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:47245 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYFTGNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 02:13:52 -0400
Date: Fri, 20 Jun 2008 08:13:45 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>
Message-ID: <20080620061345.GA9339@gundam.enneenne.com>
References: <1213794512-8245-1-git-send-email-giometti@linux.it> <20080619233411.GA27198@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619233411.GA27198@zarina>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] power: support for Texas Instruments BQ27x00 battery
	managers.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

before answering to other questions I'd like solve the following
issue.

On Fri, Jun 20, 2008 at 03:34:11AM +0400, Anton Vorontsov wrote:

> To avoid these ifdefs, I would suggest you to reconsider the model
> of this driver. How about:
> 
> - drivers/power/bq27x00_battery.c:
> 
>   Registers two platform_drivers, first is "bq27200-bat" (I2C) and
>   second is "bq27000-bat" (W1). Both are using the same probe and
>   remove methods. This driver will simply register power_supply
>   and will do all battery logic, separated from the underlaying
>   bus.
> 
>   (Two platform drivers are used simply because underlaying
>   I2C/W1 drivers will not know each other, thus will not able to
>   pass uniqe platform_device.id in case of single driver).
> 
> - include/linux/bq27x00-battery.h:
> 
>   Declares
>   struct bq27x00_access_methods {
>   	/*
> 	 * dev argument is I2C or W1 device, battery driver will use
> 	 * platform_device->dev.parent to pass the dev argument.
> 	 */
> 	int (*read)(struct device *dev, u8 reg, int *rt_value, int b_single);
>   };

Where this function should be defined? Can you explain better what you
mean?

> 
> - drivers/i2c/chips/bq27200.c:
> 
>   This driver will do all I2C stuff, and then will register
>   "bq27200-bat" platform device, with .platform_data pointed
>   to the allocated and filled "struct bq27x00_access_methods".
> 
> - drivers/w1/slaves/bq27000.c:
> 
>   This driver will do all W1 stuff, and then will register
>   "bq27000-bat" platform device, with .platform_data pointed
>   to the allocated and filled "struct bq27x00_access_methods".
> 
> Will this (not) work?

As you can see at the top of the file I based this work an previour
work by Texas Instruments people which never goes into linux vanilla
but lives into linux-omap tree. I just fixed some basic issue which
prevent the driver to compile and work properly and repropose the
driver here.

My hardware just uses the I2C chip version so I cannot test the W1 one
at all. If you agree I can remove the W1 code and provide the
bq27200.c driver only.

Maybe, as you suggested above, we can try to write the code in order
that a future W1 driver writer can write few lines. :)

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
