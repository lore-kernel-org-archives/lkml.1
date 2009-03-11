Return-Path: <linux-kernel-owner+w=401wt.eu-S1751636AbZCKALP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbZCKALP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbZCKAK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:10:57 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:39343 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZCKAK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:10:57 -0400
Date: Wed, 11 Mar 2009 01:10:48 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, syrjala@sci.fi, johnpol@2ka.mipt.ru,
       david-b@pacbell.net
Subject: Re: [PATCH] drivers/w1/masters/w1-gpio.c: fix read_bit()
Message-ID: <20090311001048.GA21160@buzzloop.caiaq.de>
References: <1236614530-11153-1-git-send-email-daniel@caiaq.de> <20090309191419.98699220.akpm@linux-foundation.org> <20090310091800.GC3263@buzzloop.caiaq.de> <20090310150059.ce64548a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310150059.ce64548a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 03:00:59PM -0700, Andrew Morton wrote:
> > > We recently merged a patch (I forget where) which fixed one
> > > gpio_get_value() implementation so that it always returns 0 or 1.
> > > 
> > > From which I deduce that the correct fix for <whatever problem you're
> > > seeing> is to fix <whichever driver that is>?
> > 
> > I agree those functions should return 0 and 1 only, but my patch fixes
> > the w1-gpio driver for all platforms at once, so people can use it.
> > 
> > On the other hand, I will submit a patch which modifies PXA's
> > gpio_get_value() and see what the maintainers say, but I can't go thru
> > all the implemenations of all architectures to do this.
> > 
> > So for the time being, the above patch helps many users of that driver.
> > 
> 
> Problem is, the patch will just conceal bugs.

There is a small discussion about that on the arm-linux mailing list and
what people pointed out there is that gpio_get_value() is _not_ supposed
to return 0 or 1 only, also according to Documentation/gpio.txt:

	Use these calls to access such GPIOs:

        /* GPIO INPUT:  return zero or nonzero */
	int gpio_get_value(unsigned gpio);

Hence, any implementation of gpio_get_value() which returns 0 and 1 only
is conform to the docs, but PXA's (which doesn't follow that rule) is as
well. And that means that any driver using that function has to deal
with values > 1 being returned by it, right?

Correct me if I missed the point, but I don't see how my patch will
conceal any bug?

Daniel

