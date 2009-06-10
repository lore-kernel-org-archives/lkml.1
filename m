Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZFJHxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZFJHxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 03:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZFJHxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 03:53:24 -0400
Received: from smtp.nokia.com ([192.100.122.230]:51983 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZFJHxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 03:53:23 -0400
Date: Wed, 10 Jun 2009 10:48:39 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Andrew Morton <akpm@linux-foundation.org>
Cc: Baruch Siach <baruch@tkos.co.il>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4] gpio: driver for PrimeCell PL061 GPIO controller
Message-ID: <20090610074839.GB27385@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1244399935-23128-1-git-send-email-baruch@tkos.co.il> <20090609140239.260428eb.akpm@linux-foundation.org> <20090610072229.GC10382@tarshish> <20090610004447.78b84cd5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610004447.78b84cd5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-OriginalArrivalTime: 10 Jun 2009 07:51:20.0743 (UTC) FILETIME=[3E622B70:01C9E9A0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 10, 2009 at 09:44:47AM +0200, ext Andrew Morton wrote:
> On Wed, 10 Jun 2009 10:22:31 +0300 Baruch Siach <baruch@tkos.co.il> wrote:
> 
> > Hi Andrew,
> > 
> > > >  static unsigned int pl061_irq_startup(unsigned irq)
> > > >  {
> > > > -	int ret;
> > > > -
> > > > -	ret = gpio_request(irq_to_gpio(irq), "IRQ");
> > > > -	if (ret < 0) {
> > > > -		pr_warning("%s: warning: gpio_request(%d) returned %d\n",
> > > > -				__func__, irq_to_gpio(irq), ret);
> > > > -		return 0;
> > > > -	}
> > > > +	if (gpio_request(irq_to_gpio(irq), "IRQ") == 0)
> > > > +		pr_warning("%s: warning: GPIO%d has not been requested\n",
> > > > +				__func__, irq_to_gpio(irq));
> > > 
> > > This is wrong, isn't it?  gpio_request() returns 0 on success.
> > 
> > Russell said that gpio configuration is the responsibility of the platform 
> > code. Here I just warn when the gpio has not been requested, and thus 
> > gpio_request() succeeds. I'll add a comment.
> 
> OK.
> 
> If the gpio_request() accidentally succeeded, should we gpio_free() the
> result here?
> 
> Should the gpio core provide a primitive to check that a gpio has been
> properly requested rathe rthan open-coding it here?

how about passing a setup() and cleanup() pointers via platform_data to the driver ?

Then, during probe(), the driver calls setup() which would
gpio_request() and during remove() it calls cleanup() to gpio_free();

would that be ok ?

-- 
balbi
