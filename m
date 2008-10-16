Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbYJPRb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbYJPRb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbYJPRPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:15:10 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7181 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753325AbYJPRPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:15:07 -0400
Date: Thu, 16 Oct 2008 21:15:05 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch] gpiolib: fix oops in gpio_get_value_cansleep()
Message-ID: <20081016171505.GA5722@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <200810160845.22281.david-b@pacbell.net> <20081016164330.GB27938@oksana.dev.rtsoft.ru> <200810161006.21276.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200810161006.21276.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 10:06:21AM -0700, David Brownell wrote:
> On Thursday 16 October 2008, Anton Vorontsov wrote:
> > > -     return chip->get(chip, gpio - chip->base);
> > > +     return chip->get ? chip->get(chip, gpio - chip->base) : 0;
> > 
> > Why don't we check the .set in the gpio_set_value? Because
> > we must always call gpio_direction_output()?
> 
> Yes.  The output driver needs to be explicitly enabled,
> to avoid misbehaving electic circuitry.
> 
> 
> > It is not exactly the 
> > same we work with the input direction.. is this documented anywhere?
> 
> In Documentation/gpio.txt since the very first versions.
> 
> See the section on "Spinlock-Safe GPIO access", where
> special cases for reading the value of output GPIOs are
> desribed.  Other aspects are mentioned in other spots.
> 
> For example, open drain signals -- as used with I2C and
> other protocols -- only drive the "low" signal level,
> and if code wants a "high" level it's got to verify that
> nobody else is driving that shared line to low.  By
> reading it back, even though it's configured as output.

I see. Much thanks for the explanations.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
