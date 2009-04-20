Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbZDTO4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbZDTO4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 10:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbZDTO4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 10:56:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37825 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756292AbZDTO43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:56:29 -0400
Date: Mon, 20 Apr 2009 15:56:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] voltage/current regulator consumer interface
Message-ID: <20090420145627.GA5281@rakim.wolfsonmicro.main>
References: <49EC8775.8060609@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC8775.8060609@compulab.co.il>
X-Cookie: Enjoy yourself while you're still old.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 05:32:21PM +0300, Mike Rapoport wrote:

> It is the most simple and straight forward solution. However, I have several
> questions and I cannot answer them myself:

Some initial thoughts:

>   Should the driver handle single or several supplies at once?

I'd expect that it should be able to cope with that - a lot of hardware
takes multiple supplies.

>   If the driver handles several supplies how to define attributes per-supply?
>   What attributes will be exposed? Would it be simple 'state' that can be
> enabled or disabled? Or the entire set of micorvolts/microamps etc?

I'd expect that if you're getting into much more than a simple enable
for the entire device it'd be getting to the point where it's worth
considering writing an actual driver for the device.  That said, it's a
fairly natural extension to support more fine grained stuff if someone
does actually end up wanting it.

> - Extend regulator framework so that regulator_consumer_supply entities will
> gain their own representation in sysfs. Depending on machine constraints the
> supply attributes can be either read-only or writable. I haven't dedicated much
> thought to it, so a cannot state any pros and cons.

I'd expect making them writable to be very fragile if there is an active
consumer driver - I'd expect reference counts to get lost with enable
and disable and I'd expect drivers managing voltages and currents to get
confused if their own configuration gets changed under them.  The core
already needs to arbitrate between multiple users so it seems to make
sense to have userspace represented as other users are to the core.

Being able to read back the consumer status doesn't seem unreasonable,
though.
