Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZI0RfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZI0RfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 13:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZI0RfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 13:35:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57961 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZI0RfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 13:35:17 -0400
Date: Sun, 27 Sep 2009 19:35:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       omegamoon@gmail.com, eric.y.miao@gmail.com, utx@penguin.cz,
       cbou@mail.ru
Subject: Re: something wrong in drivers/power
Message-ID: <20090927173516.GB6710@elf.ucw.cz>
References: <20090926095555.GG1331@ucw.cz> <20090926145536.GA8445@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926145536.GA8445@doriath.ww600.siemens.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-09-26 18:55:36, Dmitry Eremin-Solenikov wrote:
> On Sat, Sep 26, 2009 at 11:55:55AM +0200, Pavel Machek wrote:
> > 
> > Tosa battery driver seems to be confused about its own identity.
> 
> NAK. Please see the drivers/input/touchscree/wm97xx-core.c

Could you elaborate? 

I took a look at touchscreen file, and it does not explain
anything. Having tosa_battery calling itself wm97xx-battery is at
least confusing, and there's no explaining comment. Given that we have
different wm97xx_battery.c driver calling itself "wm97xx-battery"... I
believe that's a bug.

								Pavel

> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > diff -ur power.ofic/tosa_battery.c power/tosa_battery.c
> > --- linux/drivers/power.ofic/tosa_battery.c	2009-09-06 08:56:36.000000000 +0200
> > +++ linux/drivers/power/tosa_battery.c	2009-09-15 15:14:08.000000000 +0200
> > @@ -459,7 +459,7 @@
> >  }
> >  
> >  static struct platform_driver tosa_bat_driver = {
> > -	.driver.name	= "wm97xx-battery",
> > +	.driver.name	= "tosa-battery",
> >  	.driver.owner	= THIS_MODULE,
> >  	.probe		= tosa_bat_probe,
> >  	.remove		= __devexit_p(tosa_bat_remove),
> > @@ -483,4 +483,4 @@
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Dmitry Baryshkov");
> >  MODULE_DESCRIPTION("Tosa battery driver");
> > -MODULE_ALIAS("platform:wm97xx-battery");
> > +MODULE_ALIAS("platform:tosa-battery");
> > 
> > 
> > -- 
> > (english) http://www.livejournal.com/~pavelmachek
> > (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
