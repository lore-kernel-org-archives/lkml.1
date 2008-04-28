Return-Path: <linux-kernel-owner+w=401wt.eu-S934893AbYD1Tl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934893AbYD1Tl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765696AbYD1TlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:41:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:37813 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1765509AbYD1TlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:41:19 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19CsGgVgcdCmDZ/YPcLIIYYOc9bj62kJ+1QDmGmuq
	DO0RfhykKoEjwx
Date: Mon, 28 Apr 2008 21:41:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] video: fix SOC_CAMERA_MT9M001 build bug
In-Reply-To: <20080428193130.GC9907@elte.hu>
Message-ID: <Pine.LNX.4.64.0804282138000.11449@axis700.grange>
References: <20080428120032.GA23847@elte.hu> <Pine.LNX.4.64.0804281944100.10718@axis700.grange>
 <20080428193130.GC9907@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Ingo Molnar wrote:

> * Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > On Mon, 28 Apr 2008, Ingo Molnar wrote:
> > 
> > > 
> > > on latest -git, with this config:
> > > 
> > >   http://redhat.com/~mingo/misc/config-Mon_Apr_28_13_25_34_CEST_2008.bad
> > > 
> > >   CONFIG_SOC_CAMERA_MT9M001=y
> > >   CONFIG_SOC_CAMERA_MT9V022=y
> > >   # CONFIG_I2C is not set
> > > 
> > > the build fails:
> > > 
> > > drivers/built-in.o: In function `reg_read':
> > > mt9m001.c:(.text+0x140a87): undefined reference to `i2c_smbus_read_word_data'
> > > drivers/built-in.o: In function `reg_write':
> > > mt9m001.c:(.text+0x140b6e): undefined reference to `i2c_smbus_write_word_data'
> > > drivers/built-in.o: In function `reg_read':
> > > mt9v022.c:(.text+0x1413a7): undefined reference to `i2c_smbus_read_word_data'
> > > drivers/built-in.o: In function `reg_write':
> > > mt9v022.c:(.text+0x1414ce): undefined reference to `i2c_smbus_write_word_data'
> > > drivers/built-in.o: In function `mt9m001_mod_init':
> > > mt9m001.c:(.init.text+0x158a8): undefined reference to `i2c_register_driver'
> > > drivers/built-in.o: In function `mt9v022_mod_init':
> > > mt9v022.c:(.init.text+0x158b8): undefined reference to `i2c_register_driver'
> > > drivers/built-in.o: In function `mt9m001_mod_exit':
> > > mt9m001.c:(.exit.text+0x1656): undefined reference to `i2c_del_driver'
> > > drivers/built-in.o: In function `mt9v022_mod_exit':
> > > mt9v022.c:(.exit.text+0x1666): undefined reference to `i2c_del_driver'
> > > 
> > > adding the missing I2C dependency fixes it.
> > > 
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > NAK. SOC-CAMERA doesn't depend on I2C. It is also suitable for 
> > cameras, not using i2c. mt9m001 and mt9v022 do both depend on i2c.
> 
> as you can see it from the build log above, the compiler disagrees with 
> you on whether the driver depends on I2C. I'm just the messenger :)

Very sorry, but I don't see it. What I see above, is that mt9m001 and 
mt9v022 cannot be compiled - as I said, _they_ need i2c. And I don't see a 
single line for soc_camera.c. SOC_CAMERA is a generic API, it shouldn't 
have any hardware dependencies at all. Whereas mt9v022 and mt9m001 are 2 
specific i2c cameras.

Thanks
Guennadi
---
Guennadi Liakhovetski
