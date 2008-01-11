Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbYAKRAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbYAKRAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759646AbYAKRAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:00:14 -0500
Received: from smtp1.int-evry.fr ([157.159.10.44]:32826 "EHLO
	smtp1.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795AbYAKRAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:00:12 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Marc Pignat <marc.pignat@hevs.ch>
Subject: Re: [RFC, PATCH] watchdog on gpio
Date: Fri, 11 Jan 2008 17:40:25 +0100
User-Agent: KMail/1.9.7
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
References: <200801101611.08867.marc.pignat@hevs.ch>
In-Reply-To: <200801101611.08867.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801111740.25754.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marc,

Your patch looks good to me, and I have been waiting for something like 
this :). Other comments below.

Le jeudi 10 janvier 2008, Marc Pignat a écrit :
> +#include <asm/uaccess.h>
> +#include <asm/arch/gpio.h>

At first sight, this will only work with the platforms which have implemented 
gpiolib, some (like MIPS) still use the old generic GPIO API. So I think the 
include will not work here for anything than ARM, correct me if I am wrong.

> +static int gpio_wdt_keepalive(struct gpio_wdt *wdt)
> +{
> +	gpio_set_value(wdt->pdata->pin, 0);
> +	gpio_set_value(wdt->pdata->pin, 1);
> +	return 0;
> +}

Some watchdog drivers requires you to toggle the full GPIO line, not only one 
bit (I particularly think about the MTX-1 board watchdog).

Did you look into hooking into Wim's uniform watchdog driver :

http://git.kernel.org/?p=linux/kernel/git/wim/linux-2.6-watchdog-experimental.git;a=commit;h=732c54027e6c866f98857c4a6d1c6c466459dcd5

Maybe you can save some code ?



-- 
Cordialement, Florian Fainelli
------------------------------
