Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZIGOHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZIGOHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZIGOHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:07:23 -0400
Received: from dan.rpsys.net ([93.97.175.187]:54761 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbZIGOHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:07:23 -0400
Subject: Re: Zaurus suspend saga
From: Richard Purdie <rpurdie@rpsys.net>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Pavel Machek <pavel@ucw.cz>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
In-Reply-To: <1252329025.1861.6.camel@hammer.suse.cz>
References: <20090906052653.GB1324@ucw.cz>
	 <1252276145.17852.15.camel@dax.rpnet.com>
	 <20090907113132.GM23450@elf.ucw.cz>
	 <1252329025.1861.6.camel@hammer.suse.cz>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 15:07:20 +0100
Message-Id: <1252332440.17852.58.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 15:10 +0200, Stanislav Brabec wrote:
> Pavel Machek wrote: 
> > 
> > > Sadly lack of time means I've lost track of the Zaurus kernels but this
> > > sounds like all accesses to the SSP buses now go through the SPI layer
> > > and when it was converted nobody thought about the impact this would
> > > have on the Zaurus charger code.
> >
> >Unfortunately... Do you have any idea when this conversion took place?
> 
> In past, MAX1111 driver was embedded in the Zaurus specific code. Now
> MAX1111 is a generic SPI driver and spitz_pm.c calls it.
> 
> Maybe it will still work with CONFIG_CORGI_SSP_DEPRECATED.

I was thinking about this. The SSP interface is ridiculously simple and
it might be worth just adding some SSP access code into the Zaurus
offline code so it can access the MAX1111 without the rest of the system
running. That would solve a lot of the problems.

Its not as if any other hardware is going to come along and reuse this
as the Zaurus hardware line is dead.

> - The measurement code should work without turning LED on (bootloader
> can do it). SPITZ_SCP_JK_A should connect dummy load. I guess it should
> be enough for measurement. But comments in the source tree say that is
> did not work. I am not sure why.

If you find out let me know. The need for that still puzzles me but it
wouldn't work without it!

> - It would be nice to have "small travel charger heuristic": Turn fast
> charging on, charger "disappears", switch to slow charging, charger
> "appears" => stay in slow charging mode, and retry after some time, or
> after going to suspend, reset the flag when charger is removed.
> 
> - sysfs interface for charging would be nice. For example: Cyril has an
> external battery pack and he wants to disable charging of internal
> battery from the external battery.

All nice to have if we can get the original code working again first!

Cheers,

Richard



