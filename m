Return-Path: <linux-kernel-owner+w=401wt.eu-S1750992AbXDKHmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbXDKHmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXDKHmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:42:25 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3765 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbXDKHmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:42:24 -0400
Date: Wed, 11 Apr 2007 08:42:14 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Juergen Schindele <schindele@nentec.de>
Cc: Paul Sokolovsky <pmiscml@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] gpiodev - API definitions
Message-ID: <20070411074214.GB3752@flint.arm.linux.org.uk>
Mail-Followup-To: Juergen Schindele <schindele@nentec.de>,
	Paul Sokolovsky <pmiscml@gmail.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	linux-kernel@vger.kernel.org
References: <774343545.20070411003058@gmail.com> <200704110847.01107.schindele@nentec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704110847.01107.schindele@nentec.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 08:47:01AM +0200, Juergen Schindele wrote:
> Am Dienstag, 10. April 2007 23:30 schrieb Paul Sokolovsky:
> > +static inline int gpiodev_get_value(struct gpio *gpio)
> > +{
> > +       struct gpiodev_ops *ops = gpio->gpio_dev->dev.platform_data;
> 
> wouldn't it be more sure to verify if xxx function is NOT null
> before using it ?? Perhaps something like that
> 	     BUG_ON(!ops->get);
> 
> > +       return ops->get(&gpio->gpio_dev->dev, gpio->gpio_no);

What does the BUG_ON buy us that oopsing due to a NULL pointer deref
doesn't?  Both cases you end up with a register dump and backtrace.
In fact, on ARM the NULL pointer deref provides a more accurate
register dump and backtrace than BUG_ON() can ever do.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
