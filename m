Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZHaSDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZHaSDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZHaSDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:03:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60532 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZHaSDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:03:16 -0400
Date: Sun, 30 Aug 2009 20:01:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk
Message-ID: <20090830190102.GA4235@sirena.org.uk>
References: <20090830103448.GD4334@sirena.org.uk>
 <Pine.LNX.4.44L0.0908301217410.10608-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0908301217410.10608-100000@netrider.rowland.org>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] AB3100 regulator support v1
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 12:27:32PM -0400, Alan Stern wrote:
> On Sun, 30 Aug 2009, Mark Brown wrote:

> > On the face of it (and without having actually looked at a running
> > system or anything yet) I'm rather surprised that platform based MFD
> > drivers aren't running into this issue more often.  CCing in Alan who
> > made the change.

> I'm not at all familiar with the detailed issues involved here.  
> Perhaps because of this, I don't see why there's any reason for
> deadlocking.  __driver_attach() is invoked when a new driver is
> registered; to avoid problems all you have to do is make sure you
> aren't holding any device locks when you register a driver.

Ah, it's platform_driver_probe() that's causing issues.  When it is used
the devices need to have been registered previously since the driver
probe function isn't kept around.  In order to do this for the child
device the driver for the subdevice has to be registered from within the
probe function of the parent, which is itself happening within the
parent device registration.
