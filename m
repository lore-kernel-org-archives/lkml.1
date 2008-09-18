Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYIRJc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYIRJc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 05:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYIRJcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 05:32:47 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:61814 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840AbYIRJcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 05:32:46 -0400
Date: Thu, 18 Sep 2008 11:32:42 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net, ralf@linux-mips.org,
       linux-mips@linux-mips.org, g.liakhovetski@pengutronix.de,
       greg@kroah.com, kay.sievers@vrfy.org, rmk+kernel@arm.linux.org.uk
Subject: Re: [PATCH] gpio_free might sleep, mips architecture
Message-ID: <20080918093242.GA7627@informatik.uni-freiburg.de>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, david-b@pacbell.net,
	ralf@linux-mips.org, linux-mips@linux-mips.org,
	g.liakhovetski@pengutronix.de, greg@kroah.com, kay.sievers@vrfy.org,
	rmk+kernel@arm.linux.org.uk
References: <1216884515-12084-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1221508963-27259-1-git-send-email-ukleinek@informatik.uni-freiburg.de> <1221508963-27259-2-git-send-email-ukleinek@informatik.uni-freiburg.de> <1221508963-27259-3-git-send-email-ukleinek@informatik.uni-freiburg.de> <20080917143955.2d3727e5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080917143955.2d3727e5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
> > diff --git a/include/asm-mips/mach-rc32434/gpio.h b/include/asm-mips/mach-rc32434/gpio.h
> > index f946f5f..9b4722e 100644
> > --- a/include/asm-mips/mach-rc32434/gpio.h
> > +++ b/include/asm-mips/mach-rc32434/gpio.h
> > @@ -13,6 +13,7 @@
> >  #ifndef _RC32434_GPIO_H_
> >  #define _RC32434_GPIO_H_
> >  
> > +#include <linux/kernel.h>
> >  #include <linux/types.h>
> >  
> >  struct rb532_gpio_reg {
> > @@ -88,6 +89,7 @@ static inline int gpio_request(unsigned gpio, const char *label)
> >  static inline void gpio_free(unsigned gpio)
> >  {
> >  	/* Not yet implemented */
> > +	might_sleep();
> >  }
> >  
> 
> There is no gpio_free() in linux-next's include/asm-mips/mach-rc32434/gpio.h
This is OK.  This machine type is converted to GPIO lib in linus-next.
So just drop the two hunks for this file.  (Note, you only dropped the
addition of might_sleep, but then including linux/kernel.h isn't needed
either.)

Best regards and thanks
Uwe

-- 
Uwe Kleine-König

exit vi, lesson II:
: w q ! <CR>

NB: write the current file
