Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYIQVjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYIQVjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYIQVjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:39:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55716 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbYIQVjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:39:14 -0400
Message-ID: <48D178FB.80902@garzik.org>
Date: Wed, 17 Sep 2008 17:39:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, davem@davemloft.net
Subject: Re: warn: Turn the netdev timeout WARN_ON() into a WARN()
References: <200809170259.m8H2xClI020907@hera.kernel.org>	<20080917032708.GA8431@havoc.gtf.org> <20080917064128.2b2f8616@linux.intel.com>
In-Reply-To: <20080917064128.2b2f8616@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] net: WARN_ONCE -> WARN as requested by Jeff Garzik
> 
> Jeff points out that you want to see each and every
> timeout message
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  net/sched/sch_generic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index ec0a083..8772642 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -215,7 +215,7 @@ static void dev_watchdog(unsigned long arg)
>  			    time_after(jiffies, (dev->trans_start +
>  						 dev->watchdog_timeo))) {
>  				char drivername[64];
> -				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit timed out\n",
> +				WARN(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit timed out\n",
>  				       dev->name, netdev_drivername(dev, drivername, 64));
>  				dev->tx_timeout(dev);


ACK, this fixes my objection, thanks

It still seems a bit burdensome to print out a huge, redundant backtrace 
and kernel info each time, though.

The most important information is (a) a timeout occurred and (b) 
hopefully some hardware register dump or similar driver-specific output.

> If all the networking guys agree that the report
> has no value for developers because they're all unfixable hardware bugs,

You misunderstand; reporting and tracking these issues have value, but 
the information you are dumping (specifically the backtrace) does not.

You say your goal here mainly to standardize reporting to permit 
automated collection -- I support that goal too.  But is there a better 
way -- say perhaps just printing the header you need, and _not_ the 
useless backtrace?

I think it would benefit Linux if our bugs announce themselves in a 
standard way, but the backtrace is not a key part of that, and IMO 
should be optional.

	Jeff


