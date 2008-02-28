Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbYB1Rt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbYB1Rt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbYB1RtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:49:16 -0500
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:58860 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755903AbYB1RtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:49:15 -0500
Date: Thu, 28 Feb 2008 18:49:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] I2C_ELEKTOR must depend on HAS_IOPORT
Message-ID: <20080228184912.48cde1f3@hyperion.delvare>
In-Reply-To: <20080227073728.GD10603@cs181133002.pp.htv.fi>
References: <20080227073728.GD10603@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Wed, 27 Feb 2008 09:37:28 +0200, Adrian Bunk wrote:
> This patch fixes the following compile error on m32r:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  drivers/i2c/busses/i2c-elektor.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c: In function 'pcf_isa_setbyte':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:80: error: implicit declaration of function 'iowrite8'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c: In function 'pcf_isa_getbyte':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:90: error: implicit declaration of function 'ioread8'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c: In function 'pcf_isa_init':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:153: error: implicit declaration of function 'ioport_map'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:153: warning: assignment makes pointer from integer without a cast
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c: In function 'elektor_probe':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:290: error: implicit declaration of function 'ioport_unmap'
> make[4]: *** [drivers/i2c/busses/i2c-elektor.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> 
> ---
> c8a75f0dd2390ae8c8f91c451ff6b0e113d0ebd0 diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 476b0bb..3bed6b9 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -129,7 +129,7 @@ config I2C_DAVINCI
>  
>  config I2C_ELEKTOR
>  	tristate "Elektor ISA card"
> -	depends on ISA && BROKEN_ON_SMP
> +	depends on ISA && HAS_IOPORT && BROKEN_ON_SMP
>  	select I2C_ALGOPCF
>  	help
>  	  This supports the PCF8584 ISA bus I2C adapter.  Say Y if you own
> 

Looks weird to me. As you can see, I2C_ELEKTOR already depends on ISA
and I thought it would be sufficient. Your m32r system has
CONFIG_HAS_IOPORT=n but CONFIG_ISA=y? I fail to see how a system could
have ISA slots but not have IO ports.

-- 
Jean Delvare
