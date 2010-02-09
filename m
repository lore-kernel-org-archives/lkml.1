Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab0BITQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:16:24 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:41791 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751378Ab0BITQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:16:22 -0500
Date: Tue, 9 Feb 2010 22:16:20 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
Message-ID: <20100209191620.GA24539@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
 <20100205203236.GC1475@oksana.dev.rtsoft.ru>
 <fa686aa41002090913t4c72a3b8o5fda68723bc8d089@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa686aa41002090913t4c72a3b8o5fda68723bc8d089@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 10:13:11AM -0700, Grant Likely wrote:
[...]
> > +static int __init of_gpio_notifier_init(void)
> > +{
> > +       return blocking_notifier_chain_register(&gpio_notifier, &of_gpio_nb);
> > +}
> > +arch_initcall(of_gpio_notifier_init);
> 
> Another concern;  if any gpio chips get registered before this
> arch_initcall (not sure if it is possible or not), then those chips
> won't get registered with the of gpio infrastructure.

Technically, it is possible, but registering usual GPIO controllers
in arch_initcall feels not quite right approach in the first place
(and, btw, it won't work most of the time, because even early drivers
do not register itself earlier than subsys_initcall).

And arch gpio controllers (like QE GPIO) are usually device-less,
and they use of_mm_gpiochip_add(), so we fully control them.

Plus I don't see any reason why we couldn't move
of_gpio_notifier_init() into, say, postcore_initcall, if we ever
need it.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
