Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbXCZOTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbXCZOTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 10:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXCZOTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 10:19:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:14260 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbXCZOTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 10:19:09 -0400
Date: Mon, 26 Mar 2007 16:19:52 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
Message-ID: <20070326141938.GC6661@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<20070323185028.GR752@stusta.de>
	<1174679344.10840.334.camel@localhost.localdomain>
	<20070325071023.GL17532@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325071023.GL17532@mellanox.co.il>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update: I tested 2.6.21-rc5 with the following settings
# CONFIG_NO_HZ is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_HPET is not set

1. Without additional kernel options

  After systems comes out of suspend to ram, I observed the following
  behaviour (I used s2ram from console):
  1. The first disk access takes much longer than with 2.6.20
  2. System clock does not advance (date always reports the same time)
  3. After an attempt to switch to X, X starts drawing some windows and then hangs
  All 3 issues are new and did not occur under 2.6.20, so this is a regression.

2. Setting clocksource=acpi_pm
After resume from RAM
  1. The first disk access takes much longer than with 2.6.20
  2. System clock seems to advance properly
  3. After an attempt to switch to X, X works correctly

So it seems that clocksource=acpi_pm can be used as a work-around.
What does this tell us?

I'm also not happy with how clocksource=acpi_pm performs -
the system seems to be jerky, stalling for fractions of
seconds now and them.

TODO: test without CONFIG_HPET_TIMER.

-- 
MST
