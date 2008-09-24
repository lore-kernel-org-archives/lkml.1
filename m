Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbYIXVk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbYIXVk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYIXVks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:40:48 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:45560 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750875AbYIXVkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:40:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eqUAm/ehYX6eUEaEhQHLHzm+fEZHpvdjcVqoiLsRcbnHSFVOmk8lfZTPlDUG9YkjceemSj7vG+B+YFE3CxAI9uhBfw41/JKtVuii9KEvC6AIAsNq+FEdG+WJA9RDGfqMXpGIGim+KGmpv2IkuYd4q78tzznlbEb01IbPr7ShYek=  ;
X-YMail-OSG: DEG.hBcVM1muH.Z51H8K5Kz9L9feX7b7.Rkq3RESE1_qgq.c2jzhvwFZoEFWtTdI3uHoi2g.vujJrCgsub6zIoOJNdJHZ16m7.7n5rSMa0tA6FPVVYvfzzz5KpiwRKDDMmE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 1/4] gpiolib: make gpio_to_chip() public
Date: Wed, 24 Sep 2008 14:40:43 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, linuxppc-dev@ozlabs.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080924182027.GA11180@oksana.dev.rtsoft.ru> <20080924182113.GA25744@oksana.dev.rtsoft.ru>
In-Reply-To: <20080924182113.GA25744@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241440.43978.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2008, Anton Vorontsov wrote:
> We'll need this function to write platform-specific hooks to deal
> with pin's dedicated functions. Quite obviously this will work only
> for the platforms with 1-to-1 GPIO to PIN mapping.
> 
> This is stopgap solution till we think out and implement a proper
> api (pinlib?).
> 
> p.s. This patch actually exports gpio_desc and places gpio_to_chip
> into the asm-generic/gpio.h as `static inline'. This is needed
> to not cause function calls for this trivial translation.
> 
> Also, the patch does not export FLAG_*s... the names are too
> generic, and nobody is using them outside of gpiolib.c.

For the record:  NAK, still.  The concept has problems,
there is no "need" for this.  I sketched a cleaner way
to address the issues of the QE USB driver; I'm sure it
would only take an hour or two to code, using what's
already present.

And if I were to approve something like this it would
be a lot simpler, not exposing internals, and with
appropriate kerneldoc.  Simpler such as

	struct gpio_chip *gpio_to_gpiochip(unsigned gpio)
	{
		return gpio_to_chip(gpio);
	}
	EXPORT_SYMBOL_NOTREALLY(gpio_to_gpiochip);

with a declaration in a header.  It's not like THIS
version would be performance-critical (unlike the one
inside gpiolib).

- Dave
