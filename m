Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZHWJWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZHWJWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbZHWJWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:22:18 -0400
Received: from mx0.towertech.it ([213.215.222.73]:51320 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755941AbZHWJWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:22:16 -0400
Date: Sun, 23 Aug 2009 11:22:14 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: akpm@linux-foundation.org, deepak@laptop.org, Tobias_Mueller@twam.info,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       cjb@laptop.org, linux-geode@lists.infradead.org
Subject: Re: [PATCH 1/3] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver
 support
Message-ID: <20090823112214.3adca590@i1501.lan.towertech.it>
In-Reply-To: <20090818175314.16c81ca4@mycelium.queued.net>
References: <20090818175314.16c81ca4@mycelium.queued.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 17:53:14 -0400
Andres Salomon <dilinger@collabora.co.uk> wrote:

> 
> This creates a CS5535/CS5536 GPIO driver which uses a gpio_chip backend
> (allowing GPIO users to use the generic GPIO API if desired) while also
> allowing architecture-specific users directly (via the cs5535_gpio_*
> functions).
> 
> Tested on an OLPC machine.  Some Leemotes also use CS5536 (with a mips
> cpu), which is why this is in drivers/gpio rather than arch/x86.
> Currently, it conflicts with older geode GPIO support; once MFGPT support
> is reworked to also be more generic, the older geode code will be removed.
> 
> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>

 fwiw,

 Reviewed-by: Alessandro Zummo <a.zummo@towertech.it>

> +	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%llx\n", GPIO_BAR,
> +			(unsigned long long) cs5535_gpio_chip.base);

 shouldn't this be dev_dbg ?

> 
> +	/* finally, register with the generic GPIO API */
> +	err = gpiochip_add(&cs5535_gpio_chip.chip);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to register gpio chip\n");

 gpiochip_add already uses pr_err for error conditions, there's no need
 to report twice.

> +		goto release_region;
> +	}
> +
> +	printk(KERN_INFO DRV_NAME ": GPIO support successfully loaded.\n");

 I'd use dev_xxx here, maybe it's worth to have a generic one
 in gpiochip_add .


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

