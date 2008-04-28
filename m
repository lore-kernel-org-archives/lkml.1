Return-Path: <linux-kernel-owner+w=401wt.eu-S937056AbYD1Tbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937056AbYD1Tbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933873AbYD1Tbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:31:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45932 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933971AbYD1Tbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:31:44 -0400
Date: Mon, 28 Apr 2008 21:31:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] video: fix SOC_CAMERA_MT9M001 build bug
Message-ID: <20080428193130.GC9907@elte.hu>
References: <20080428120032.GA23847@elte.hu> <Pine.LNX.4.64.0804281944100.10718@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804281944100.10718@axis700.grange>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Mon, 28 Apr 2008, Ingo Molnar wrote:
> 
> > 
> > on latest -git, with this config:
> > 
> >   http://redhat.com/~mingo/misc/config-Mon_Apr_28_13_25_34_CEST_2008.bad
> > 
> >   CONFIG_SOC_CAMERA_MT9M001=y
> >   CONFIG_SOC_CAMERA_MT9V022=y
> >   # CONFIG_I2C is not set
> > 
> > the build fails:
> > 
> > drivers/built-in.o: In function `reg_read':
> > mt9m001.c:(.text+0x140a87): undefined reference to `i2c_smbus_read_word_data'
> > drivers/built-in.o: In function `reg_write':
> > mt9m001.c:(.text+0x140b6e): undefined reference to `i2c_smbus_write_word_data'
> > drivers/built-in.o: In function `reg_read':
> > mt9v022.c:(.text+0x1413a7): undefined reference to `i2c_smbus_read_word_data'
> > drivers/built-in.o: In function `reg_write':
> > mt9v022.c:(.text+0x1414ce): undefined reference to `i2c_smbus_write_word_data'
> > drivers/built-in.o: In function `mt9m001_mod_init':
> > mt9m001.c:(.init.text+0x158a8): undefined reference to `i2c_register_driver'
> > drivers/built-in.o: In function `mt9v022_mod_init':
> > mt9v022.c:(.init.text+0x158b8): undefined reference to `i2c_register_driver'
> > drivers/built-in.o: In function `mt9m001_mod_exit':
> > mt9m001.c:(.exit.text+0x1656): undefined reference to `i2c_del_driver'
> > drivers/built-in.o: In function `mt9v022_mod_exit':
> > mt9v022.c:(.exit.text+0x1666): undefined reference to `i2c_del_driver'
> > 
> > adding the missing I2C dependency fixes it.
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> NAK. SOC-CAMERA doesn't depend on I2C. It is also suitable for 
> cameras, not using i2c. mt9m001 and mt9v022 do both depend on i2c.

as you can see it from the build log above, the compiler disagrees with 
you on whether the driver depends on I2C. I'm just the messenger :)

	Ingo
