Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYCATCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYCATCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYCATCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:02:38 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46188 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506AbYCATCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:02:37 -0500
Date: Sat, 1 Mar 2008 21:01:10 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jean Delvare <khali@linux-fr.org>, takata@linux-m32r.org
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-m32r@ml.linux-m32r.org
Subject: m32r and ISA
Message-ID: <20080301190110.GE25835@cs181133002.pp.htv.fi>
References: <20080227073728.GD10603@cs181133002.pp.htv.fi> <20080228184912.48cde1f3@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080228184912.48cde1f3@hyperion.delvare>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 06:49:12PM +0100, Jean Delvare wrote:
> Hi Adrian,
> 
> On Wed, 27 Feb 2008 09:37:28 +0200, Adrian Bunk wrote:
> > This patch fixes the following compile error on m32r:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC [M]  drivers/i2c/busses/i2c-elektor.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c: In function 'pcf_isa_setbyte':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:80: error: implicit declaration of function 'iowrite8'
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c: In function 'pcf_isa_getbyte':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:90: error: implicit declaration of function 'ioread8'
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c: In function 'pcf_isa_init':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:153: error: implicit declaration of function 'ioport_map'
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:153: warning: assignment makes pointer from integer without a cast
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c: In function 'elektor_probe':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:290: error: implicit declaration of function 'ioport_unmap'
> > make[4]: *** [drivers/i2c/busses/i2c-elektor.o] Error 1
> > 
> > <--  snip  -->
> > 
> > Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> > 
> > ---
> > c8a75f0dd2390ae8c8f91c451ff6b0e113d0ebd0 diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> > index 476b0bb..3bed6b9 100644
> > --- a/drivers/i2c/busses/Kconfig
> > +++ b/drivers/i2c/busses/Kconfig
> > @@ -129,7 +129,7 @@ config I2C_DAVINCI
> >  
> >  config I2C_ELEKTOR
> >  	tristate "Elektor ISA card"
> > -	depends on ISA && BROKEN_ON_SMP
> > +	depends on ISA && HAS_IOPORT && BROKEN_ON_SMP
> >  	select I2C_ALGOPCF
> >  	help
> >  	  This supports the PCF8584 ISA bus I2C adapter.  Say Y if you own
> > 
> 
> Looks weird to me. As you can see, I2C_ELEKTOR already depends on ISA
> and I thought it would be sufficient. Your m32r system has
> CONFIG_HAS_IOPORT=n but CONFIG_ISA=y? I fail to see how a system could
> have ISA slots but not have IO ports.

I don't have any m32r system.

I'm just doing the sisyphus task of getting as many defconfigs as 
possible compiling.

I've added the m32r maintainer as recipient for this email since he 
might be the best person to answer your question.

> Jean Delvare

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

