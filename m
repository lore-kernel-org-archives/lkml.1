Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbXE3Tzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbXE3Tzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbXE3Tzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:55:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55534
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbXE3Tzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:55:38 -0400
Date: Wed, 30 May 2007 12:55:51 -0700 (PDT)
Message-Id: <20070530.125551.41636333.davem@davemloft.net>
To: kaber@trash.net
Cc: shemminger@linux-foundation.org, akpm@linux-foundation.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] Make net watchdog timers 1 sec jiffy aligned
From: David Miller <davem@davemloft.net>
In-Reply-To: <465DC598.5060407@trash.net>
References: <20070530105936.6c988da5.akpm@linux-foundation.org>
	<20070530112056.0aeb9498@freepuppy>
	<465DC598.5060407@trash.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 30 May 2007 20:42:32 +0200

> Stephen Hemminger wrote:
> >>>Index: linux-2.6.22-rc-mm/net/sched/sch_generic.c
> >>>===================================================================
> >>>--- linux-2.6.22-rc-mm.orig/net/sched/sch_generic.c	2007-05-24 11:16:03.000000000 -0700
> >>>+++ linux-2.6.22-rc-mm/net/sched/sch_generic.c	2007-05-25 15:10:02.000000000 -0700
> >>>@@ -224,7 +224,8 @@
> >>> 	if (dev->tx_timeout) {
> >>> 		if (dev->watchdog_timeo <= 0)
> >>> 			dev->watchdog_timeo = 5*HZ;
> >>>-		if (!mod_timer(&dev->watchdog_timer, jiffies + dev->watchdog_timeo))
> >>>+		if (!mod_timer(&dev->watchdog_timer,
> >>>+			       round_jiffies(jiffies + dev->watchdog_timeo)))
> >>> 			dev_hold(dev);
> >>> 	}
> >>> }
> >>
> >>Please cc netdev on net patches.
> >>
> >>Again, I worry that if people set the watchdog timeout to, say, 0.1 seconds
> >>then they will get one second, which is grossly different.
> >>
> >>And if they were to set it to 1.5 seconds, they'd get 2.0 which is pretty
> >>significant, too.
> > 
> > 
> > Alternatively, we could change to a timer that is pushed forward after each
> > TX, maybe using hrtimer and hrtimer_forward().  That way the timer would
> > never run in normal case.
> 
> 
> It seems wasteful to add per-packet overhead for tx timeouts, which
> should be an exception. Do drivers really care about the exact
> timeout value? Compared to a packet transmission time its incredibly
> long anyways ..

I agree, this change is absolutely rediculious and is just a blind
cookie-cutter change made without consideration of what the code is
doing and what it's requirements are.

