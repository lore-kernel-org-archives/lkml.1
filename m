Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZAXCm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZAXCm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 21:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbZAXCmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 21:42:19 -0500
Received: from web15704.mail.cnb.yahoo.com ([202.165.102.71]:33795 "HELO
	web15704.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751996AbZAXCmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 21:42:19 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jan 2009 21:42:18 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=jeI4Wf+9aNY/D8dq24BrH8TN4ZK7vglfe6esMts5jY3evGGO9OPBJMw7P9CdYIreI2vjuK+6iXarEknZtftDy3lSQ8oysDv5vZJFZH0CZjHsFtWCSZODXWWNaJYfSD+eYAJP3A5OpQd09c+xFmZdWCRUA8jdkQ16s0Kexct34lA=;
X-YMail-OSG: ULbNaigVM1k_WBdQ9KYW1dmVmgu_9GYuI7DBgs1tqqUltjgN0Lor2poV
X-Mailer: YahooMailWebService/0.7.260.1
Date: Sat, 24 Jan 2009 10:35:35 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Reply-To: mengsanshui@yahoo.com.cn
Subject: Is this a bug related s3c24xx-spi-gpio driver 
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <494901.35869.qm@web15704.mail.cnb.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

The .name field is different between platform_device and platform_driver

in drivers/spi/spi_s3c24xx_gpio.c 
static struct platform_driver s3c2410_spigpio_drv = {
        .probe          = s3c2410_spigpio_probe,
        .remove         = s3c2410_spigpio_remove,
        .suspend        = s3c2410_spigpio_suspend,
        .resume         = s3c2410_spigpio_resume,
        .driver         = {
                .name   = "spi_s3c24xx_gpio",
                .owner  = THIS_MODULE,
        },
};


but 
in arch/arm/mach-s3c2410/mach-qt2410.c 

static struct platform_device qt2410_spi = {
	.name		  = "s3c24xx-spi-gpio",
	.id		  = 1,
	.dev = {
		.platform_data = &spi_gpio_cfg,
	},
};

in arch/arm/mach-s3c2410/mach-jive.c
static struct platform_device jive_device_lcdspi = {
	.name		= "s3c24xx-spi-gpio",
	.id		= 1,
	.num_resources  = 0,
	.dev.platform_data = &jive_lcd_spi,
};

in  sound/soc/s3c24xx/ smdk2440_wm8956.c 

smdk2440_spi_device = platform_device_alloc("s3c24xx-spi-gpio",-1);


Peter Meng 





      
