Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZGMJKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZGMJKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZGMJKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:10:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56284 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZGMJKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:10:40 -0400
Date: Mon, 13 Jul 2009 11:10:34 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] move omap_udc's probe function to .devinit.text
Message-ID: <20090713091034.GC10549@pengutronix.de>
References: <20090711170548.GC5205@suse.de> <20090712084734.GA944@flint.arm.linux.org.uk> <20090712131732.GA4406@flint.arm.linux.org.uk> <200907121521.31188.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200907121521.31188.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

On Sun, Jul 12, 2009 at 03:21:30PM -0700, David Brownell wrote:
> On Sunday 12 July 2009, Russell King wrote:
> > 	 David's approach is an enhancement whereas your patches
> > are a bug fix.
> 
> Not an enhancement.  Uwe's current approach causes regressions
> in terms of kernel runtime footprint.  That is, pages will newly
> be made to sit around doing *nothing* forever, when they could
> have been used to get Real Work done.  And, pre-patches, they
> would have been getting Real Work done.
> 
> If it weren't a regression I wouldn't have objected.
IMHO my patches primarily fix possible oopses.  I see your point that
platform_driver_probe has some advantages, but I consider it too
time-consuming to check for each of the initially 60+ patches when the
respecting devices are registered.

My intention is to point out a problem plus provide a safe fix.

> All that adds up.  There's no point to commiting patches that
> do things wrong *and* waste space, then need to fix things up
> again later when it's easy to do it right in the first place.

Obviously it's arguable if it's wrong or not.  I consider it at least
better than doing nothing.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
