Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbYJQVN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbYJQVN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbYJQVNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:13:18 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:12569 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756560AbYJQVNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:13:17 -0400
Date: Sat, 18 Oct 2008 01:13:14 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 5/7] of/gpio: implement of_dev_gpiochip_{add,remove}
	calls
Message-ID: <20081017211314.GA30061@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <20081016171303.GE5515@oksana.dev.rtsoft.ru> <200810171325.01729.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200810171325.01729.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 01:25:01PM -0700, David Brownell wrote:
> On Thursday 16 October 2008, Anton Vorontsov wrote:
> > +       if (of_gc->chip)
> > +               return of_gc->chip;
> > +       return &of_gc->gc;
> 
> presumably there's a reason not to
> 
> 	of_gc->chip = &of_gc->gc;

Yes, there are two reasons:

1. I need some place to insert the huge comment, which you snipped. ;-)

2. I didn't want to break current users. That is, the line you purpose
   ("of_gc->chip = &of_gc->gc;") should be inserted to every of_gpio
   controller. Most of them use of_mm_gpiochip_add(), so these are easy.
   But some (mcu_mpc8349emitx.c) are doing things by themselves.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
