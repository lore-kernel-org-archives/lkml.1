Return-Path: <linux-kernel-owner+w=401wt.eu-S1423030AbXDTI21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423030AbXDTI21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXDTI21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:28:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50067 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754076AbXDTI20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:28:26 -0400
Date: Fri, 20 Apr 2007 10:27:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [PATCH 7/7] [RFC] APM emulation driver for class batteries
Message-ID: <20070420082746.GA22992@elf.ucw.cz>
References: <20070411232644.GG20095@zarina> <20070413135005.GE20618@zarina> <20070416202421.GC19713@flint.arm.linux.org.uk> <20070416210829.GA5107@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416210829.GA5107@zarina>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +static void (*old_apm_get_power_status)(struct apm_power_info*);
> > > +
> > > +static int __init apm_battery_init(void)
> > > +{
> > > +	printk(KERN_INFO "APM Battery Driver\n");
> > > +
> > > +	old_apm_get_power_status = apm_get_power_status;
> > > +	apm_get_power_status = apm_battery_apm_get_power_status;
> > > +	return 0;
> > > +}
> > > +
> > > +static void __exit apm_battery_exit(void)
> > > +{
> > > +	apm_get_power_status = old_apm_get_power_status;
> > > +	return;
> > > +}
> > 
> > Utterly unsafe.  What happens if some other module gets loaded which
> > does this, and then this module is unloaded followed by the other
> > module.  Result: Oops.
> 
> Right. And loading two modules which changing apm_get_power_status
> is a race already. Thus, APM interface needs a mutex.
> 
> Or pda_power should be marked "bool" in Kconfig, as it is done
> in arch/arm/common/sharpsl_pm.c. Sharpsl_pm is safe only because it
> can't be a module.

Just mark it bool, when you fix it with mutex, you can go back to
tristate.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
