Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbZFOXdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbZFOXdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 19:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZFOXdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 19:33:01 -0400
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:20430 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751179AbZFOXdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 19:33:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xhJKW7mgIzTcNUykz1goXvY278CE3rcNYOI/SFI84x4oERWCKXxGVTXzF8ffWpoo8D5NKHxPKwo5nsipcG00wvq4KJmICnbWZHAjmMnxgPCS4f2M6MZ6PZk3lM2PPjavRQHw+GAdTM5Qqf3V8Twyy3bgTrWNZo0voIxFJ5HufZI=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: G8BRS1cVM1m9kEySbdE3yYtKNeNkXr6bCKFTwAX1_w71lF7AGoQsx4..3a3JoW1n2jueRIie0q7foTYdQ5uZVsaRudXeE3BkoAUa0aopiFB8W.l6acs4TqetTaP2tocGfbh_rFadXm0aMEVIUPayIN54fmEsxvAPrafVrRWXwDL9jSl21aMl96BSOjPRKs2vDdZ.GR1HKK5hn1SVSR0CKPzF9cH7lfs0PsspSXlk5Zr0r76pqsh9vRWp5_3NmcGeNyudEymLdUYwBQvou1DDQ3poGzh6mhaxkbfu6MBkYWh8VvXa3Tw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH v4] gpio: driver for PrimeCell PL061 GPIO controller
Date: Mon, 15 Jun 2009 16:33:02 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux@arm.linux.org.uk
References: <1244399935-23128-1-git-send-email-baruch@tkos.co.il> <20090610004447.78b84cd5.akpm@linux-foundation.org> <20090610075633.GD10382@tarshish>
In-Reply-To: <20090610075633.GD10382@tarshish>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906151633.03217.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 June 2009, Baruch Siach wrote:
> > Should the gpio core provide a primitive to check that a gpio has been
> > properly requested rathe rthan open-coding it here?
> 
> Probably. 

I happen to strongly dislike primitives that are fundamentally
MT-unsafe, except in non-threaded environments ... so I would
disagree about that.  :)

If you want to see if a GPIO is available, allocate it.
The only answer you can really depend on is "yes, it's
mine now".  You can't rely on other threads not allocating,
or not de-allocating, the GPIO later ... unless they can't,
because it's not theirs.

But that's beside the point, since GPIO drivers shouldn't
be in the business of requesting the GPIOs they manage.
Such layer violations are another sign that you may not be
thinking very clearly about things.

In this case, whoever allocated that GPIO for IRQ purposes
should have done the gpio_request() before handing out
the gpio_to_irq() results to however many drivers ended
up needing to use it.

- Dave
