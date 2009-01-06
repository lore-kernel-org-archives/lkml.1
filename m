Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbZAFKeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbZAFKeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZAFKeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:34:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2942 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZAFKeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:34:05 -0500
Date: Tue, 6 Jan 2009 10:33:57 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       davej@redhat.com
Message-ID: <20090106103357.GC6783@sirena.org.uk>
References: <200812011335.43551.david-b@pacbell.net> <1228340921.6529.80.camel@vega.slimlogic.co.uk> <20081204111206.GA8019@sirena.org.uk> <200901051545.24605.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901051545.24605.david-b@pacbell.net>
X-Cookie: The Ranger isn't gonna like it, Yogi.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.28-rc7] regulator: catch some registration errors
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 03:45:24PM -0800, David Brownell wrote:

> Last time I looked, no cpufreq driver tried to use <linux/clk.h>

There's at least these ones kicking about at the minute:

	arch/arm/mach-imx/cpufreq.c
	arch/avr32/mach-at32ap/cpufreq.c
	arch/sh/kernel/cpufreq.c

as well as several out of tree ones I'm aware of (the i.MX31 example I
posted, some other i.MX BSPs and one for the s3c24xx).  There's an
opportunity for generalisation here since they're pretty much all very
similar adaption layers with the actual work in the clock framework.

> calls.  The reason was simple:  the clock framework code sits in
> DRAM, so it can't be executed while changing DRAM clocks.

> Those bits of cpufreq had to live in on-chip SRAM (there's usually
> a few pages of it) and directly update PLL and other clock config
> registers ... then wait for things to stabilize before they returned
> and the CPU executed from DRAM again.

That's a fairly system-specific concern, though, and there's no reason
why the code that does that dance has to live in the cpufreq driver
rather than the clock framework.  On some systems the clock framework
will need to know about what the CPU clock is doing anyway.
