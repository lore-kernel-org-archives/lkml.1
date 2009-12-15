Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbZLOUpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbZLOUpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZLOUpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:45:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53051 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbZLOUpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:45:05 -0500
Date: Tue, 15 Dec 2009 21:44:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091215204457.GM24406@elf.ucw.cz>
References: <4B203575.6050407@bluewatersys.com>
 <20091210172458.GJ19454@elf.ucw.cz>
 <4B2150B7.3040207@bluewatersys.com>
 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
 <20091211221015.GB24456@elf.ucw.cz>
 <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com>
 <20091214064545.GK5114@elf.ucw.cz>
 <BD79186B4FD85F4B8E60E381CAEE19090200E9E6@mi8nycmail19.Mi8.com>
 <20091215194725.GH24406@elf.ucw.cz>
 <4B27F075.5000908@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27F075.5000908@bluewatersys.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-12-16 09:24:21, Ryan Mallon wrote:
> Pavel Machek wrote:
> > Hi!
> > 
> >>> +int gpio_to_irq(unsigned gpio)
> >>> +{
> >>> +	return -EINVAL;
> >>> +}
> >> This should probably just be an inline function in
> >> arch/arm/mach-msm/include/mach/gpio.h
> > 
> > Well, it is not performance critical in any way and it is likely to
> > change in future. I'd leave it here.
> 
> If this function eventually does do something interesting, it would be
> useful to have it as a macro in arch/arm/mach-msm/include/mach/gpio.h
> since it can be used for static/define declarations, ie:
> 
> #define SOME_GPIO_IRQ gpio_to_irq(SOME_GPIO)

gpio_to_irq is defined as a function in Doc*/gpio.txt.

> >> static inline int irq_to_gpio(unsigned irq)
> >> {
> >> 	return -EINVAL;
> >> }
> > 
> > I'd say that would be overdoing it.
> 
> You should implement this if you have gpio_to_irq because it is part of
> the API, see include/linux/gpio.h

I'm implementing it. I just don't want to implement two inline
functions instead of one normal function.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
