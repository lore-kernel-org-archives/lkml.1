Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZI1Hzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZI1Hzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 03:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZI1Hzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 03:55:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:7008 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZI1Hzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 03:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PGw4529sClx3Ez7rp9LD3zBhhdpE2RLmdOMKJ/8n0AZzA8OCOAzYQuF7SDOd8RzO9y
         hQMUvy/Yq9XhfrsrC09y/YCSBlzn5TKk/VSEsmJtumoU/mXaWbzm8pBQEAZvi1VI3wa6
         aag831fJFJoE3zvFRoPNK/kvpjg+rsYmhpMj4=
Date: Mon, 28 Sep 2009 11:55:17 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       omegamoon@gmail.com, eric.y.miao@gmail.com, utx@penguin.cz,
       cbou@mail.ru, Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: something wrong in drivers/power
Message-ID: <20090928075517.GA6871@doriath.ww600.siemens.net>
References: <20090926095555.GG1331@ucw.cz>
 <20090926145536.GA8445@doriath.ww600.siemens.net>
 <20090927173516.GB6710@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927173516.GB6710@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 07:35:16PM +0200, Pavel Machek wrote:
> On Sat 2009-09-26 18:55:36, Dmitry Eremin-Solenikov wrote:
> > On Sat, Sep 26, 2009 at 11:55:55AM +0200, Pavel Machek wrote:
> > > 
> > > Tosa battery driver seems to be confused about its own identity.
> > 
> > NAK. Please see the drivers/input/touchscree/wm97xx-core.c
> 
> Could you elaborate? 
> 
> I took a look at touchscreen file, and it does not explain
> anything. Having tosa_battery calling itself wm97xx-battery is at
> least confusing, and there's no explaining comment. Given that we have
> different wm97xx_battery.c driver calling itself "wm97xx-battery"... I
> believe that's a bug.

Tosa has a battery that is hanging on the wm97xx codec (9712 if somebody
cares). The platform device for it is registered in the wm97xx-core and
then used by tosa-battery driver. If you'd like to clean up this mess
properly, you should:

1) add a clean possibility to pass platform data via ac97 bus to wm97xx
core driver (care to check that it should be passable both via regular
ac97 driver and via ASoC).

2) add a possibility to pass device names and platform data to
wm97xx-core child devices (battery, ts , etc.)

> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > 
> > > diff -ur power.ofic/tosa_battery.c power/tosa_battery.c
> > > --- linux/drivers/power.ofic/tosa_battery.c	2009-09-06 08:56:36.000000000 +0200
> > > +++ linux/drivers/power/tosa_battery.c	2009-09-15 15:14:08.000000000 +0200
> > > @@ -459,7 +459,7 @@
> > >  }
> > >  
> > >  static struct platform_driver tosa_bat_driver = {
> > > -	.driver.name	= "wm97xx-battery",
> > > +	.driver.name	= "tosa-battery",
> > >  	.driver.owner	= THIS_MODULE,
> > >  	.probe		= tosa_bat_probe,
> > >  	.remove		= __devexit_p(tosa_bat_remove),
> > > @@ -483,4 +483,4 @@
> > >  MODULE_LICENSE("GPL");
> > >  MODULE_AUTHOR("Dmitry Baryshkov");
> > >  MODULE_DESCRIPTION("Tosa battery driver");
> > > -MODULE_ALIAS("platform:wm97xx-battery");
> > > +MODULE_ALIAS("platform:tosa-battery");
> > > 
> > > 
> > > -- 
> > > (english) http://www.livejournal.com/~pavelmachek
> > > (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> > 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

-- 
With best wishes
Dmitry

