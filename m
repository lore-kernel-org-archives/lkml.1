Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZIXSOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZIXSOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZIXSOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:14:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41457 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZIXSOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:14:05 -0400
Date: Thu, 24 Sep 2009 11:13:59 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Message-ID: <20090924181357.GB9082@sirena.org.uk>
References: <1253798645-9493-1-git-send-email-w.sang@pengutronix.de>
 <20090924173904.GA9082@sirena.org.uk>
 <20090924180727.GA6408@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924180727.GA6408@pengutronix.de>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 72.254.11.239
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: add driver for MAX8660/8661
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 08:07:27PM +0200, Wolfram Sang wrote:

> > Forced PWM is normally a power loss - the benefit it gives is the
> > ability to respond to sudden spikes in load without voltage droops.  The
> > power benefit from not having it enabled is usually only apparent at
> > lower loads.

> Understood. Well, as this chip automatically switches PWM on/off depending on
> the load (formula is in the datasheet), it seems to me that the forced-PWM mode
> is mainly used for systems which prefer low-noise on the signal. So, the above
> comment could just be dropped. Liam, could you do this, or shall I resend?

I don't think I've ever seen a regulator that didn't try to scale up so
that under high load they end up as running in forced PWM mode.

The ability to force is there mainly in case the load transients are so
sudden in a systemm that the pulse skipping ends up not responding
quickly enough.  There's also a marginal power saving from not doing the
checks if the load is always high but that's not the common case for the
uses we tend to see in Linux.
