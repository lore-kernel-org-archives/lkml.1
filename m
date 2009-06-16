Return-Path: <linux-kernel-owner+w=401wt.eu-S1761438AbZFPHmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438AbZFPHmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZFPHm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:42:27 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:39159 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752126AbZFPHm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:42:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LiqQmOXLc4POwLVBH27GR6zOhZ3LkPzP409BaMAjZpbmCK57RS4CgBLcOC5TKmNQ8TZcRISIa/bYOP2TGVKJjVciHKPeGH/dQlXNetxy4JUW+044yhxDIRuxFHEfk/PnY0WtuwcjjMfM7ZrokYIBQPwXpbRs4pBRZhaTluy1iDU=  ;
X-YMail-OSG: FIQZ1RAVM1k1snBDQadxFWPJxqx8qBN3HyghtkmFvN5ZjSj4vcpSsoNyEMqRZWkH4PPbENKAMT7up4QZGrMFcrZU28a3lOabFKM8rUOEQUYqEYjUEQFVMDOkCo0QxepyzgHYh7.9vjhkzVQMu8qZ9Wvo0mOCnmF8d8JshyqJFzkMOqvwQ6KAYo.8Uf709TCbuSVanLWRmQsAI3ny_9rLzLvBlkU3W1AC.XyeQVPp1oJq6e1rbw7w2A8qGad7CqDoBjULqROB9.iRNA.JMcMTHJWEbQBZkcnYjCZgm42x20V8Qu0Pe3MPCXzdDDyig8.qYfQAbhAGU1_ZSUOHcSTmt7FvsM2J
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH v5] gpio: driver for PrimeCell PL061 GPIO controller
Date: Tue, 16 Jun 2009 00:42:28 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <1244708976-22122-1-git-send-email-baruch@tkos.co.il> <200906151629.11350.david-b@pacbell.net> <20090616042008.GA2794@jasper.tkos.co.il>
In-Reply-To: <20090616042008.GA2794@jasper.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906160042.28932.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 June 2009, Baruch Siach wrote:
>
> > > +static unsigned int pl061_irq_startup(unsigned irq)
> > > +{
> > > +       if (gpio_request(irq_to_gpio(irq), "IRQ") == 0)
> > > +               pr_warning("%s: warning: GPIO%d has not been requested\n",
> > > +                               __func__, irq_to_gpio(irq));
> > 
> > No, that's the responsibility of whoever is setting this up.
> 
> The gpio_request() here is only for warning. It is expected to fail. Should I 
> remove it? Shouldn't there be an is_gpio_requested() as part of gpiolib?

As I said elsewhere:  yes, remove it; and no, such a call
would be pointless since it's conceptually broken in threaded
environments, like inside the Linux kernel.


> > Normally, platform setup code would request the GPIO since it's
> > being dedicated to some task on the board ... and then pass the
> > gpio_to_irq() value as a device resource, or maybe the GPIO itself
> > (if the driver had to deal with GPIOs per se).
> > 
> > Also, irq_to_gpio() can be problematic in some systems; avoid it.
> 
> I use irq_to_gpio() extensively to implement the enable/disable etc. methods 
> of irq_chip. Is there a way to implement them without irq_to_gpio()?

If it works on your systems, so be it ... it's highly
system-specific whether it works.  But this driver is
not supposed to be system-specific, and shouldn't use it.
(And it doesn't need to use it, as noted.)
  

> > > +
> > > +       pl061_irq_enable(irq);
> > > +
> > > +       return 0;
> > > +}
> > 
> > Remove that gpio_request(), and the irq_to_gpio(), and you get:
> > 
> > Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> Thanks,
> 
> Baruch
> 
> -- 
>                                                      ~. .~   Tk Open Systems
> =}------------------------------------------------ooO--U--Ooo------------{=
>    - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
> 
> 


