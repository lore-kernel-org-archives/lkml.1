Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZIRHuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZIRHuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 03:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZIRHuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 03:50:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37124 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZIRHuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 03:50:16 -0400
Date: Fri, 18 Sep 2009 08:49:51 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alek Du <alek.du@intel.com>, "david-b@pacbell.net" <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] gpio: add Intel Moorestown Platform Langwell chip
	gpio driver
Message-ID: <20090918074951.GA4075@flint.arm.linux.org.uk>
References: <20090703210706.41288a2a@dxy.sh.intel.com> <20090917163644.4783a337.akpm@linux-foundation.org> <20090918091844.6c8a8bd1@dxy.sh.intel.com> <20090917203826.e083746d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917203826.e083746d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 08:38:26PM -0700, Andrew Morton wrote:
> On Fri, 18 Sep 2009 09:18:44 +0800 Alek Du <alek.du@intel.com> wrote:
> 
> > Sorry for the inconvenience. I do not have SPARC64 build env., but I think this patch will fix the build issue, I should include <linux/irq.h> by explicit.
> > 
> > >From 5f0f166b37c4313c27de32f6f200bbd0656603b7 Mon Sep 17 00:00:00 2001
> > From: Alek Du <alek.du@intel.com>
> > Date: Fri, 18 Sep 2009 09:09:19 +0800
> > Subject: [PATCH] gpio: Fix Langwell gpio driver build error
> > 
> > Need to include <linux/irq.h> directly ...
> > 
> > Signed-off-by: Alek Du <alek.du@intel.com>
> > ---
> >  drivers/gpio/langwell_gpio.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
> > index e100583..10a1172 100644
> > --- a/drivers/gpio/langwell_gpio.c
> > +++ b/drivers/gpio/langwell_gpio.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/interrupt.h>
> >  #include <linux/init.h>
> >  #include <linux/io.h>
> > +#include <linux/irq.h>
> >  #include <linux/gpio.h>
> >  
> >  struct lnw_gpio_register {
> 	
> include/linux/irq.h says
> 
> /*
>  * Please do not include this file in generic code.  There is currently
>  * no requirement for any architecture to implement anything held
>  * within this file.
>  *
>  * Thanks. --rmk
>  */
> 
> but
> 
> y:/usr/src/linux-2.6.31> grep -rl 'linux/irq.h' drivers | wc -l
> 101
> 
> Russell, is that rule no longer true?

Ever since ARM was converted over to genirq, I've given up fighting it.
It does still mean that any arch not using genirq is going to have
problems with these drivers.

I suspect that it's still the case that many of these includes should
be linux/interrupt.h and not linux/irq.h

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
