Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXE2XC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXE2XC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbXE2XCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:02:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58705
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbXE2XCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:02:20 -0400
Date: Tue, 29 May 2007 16:02:33 -0700 (PDT)
Message-Id: <20070529.160233.45506339.davem@davemloft.net>
To: tglx@linutronix.de
Cc: michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] NOHZ: prevent multiplication overflow - stop timer for
 huge timeouts
From: David Miller <davem@davemloft.net>
In-Reply-To: <1180475259.20546.26.camel@chaos>
References: <465C188F.9000900@googlemail.com>
	<465C222A.8060003@googlemail.com>
	<1180475259.20546.26.camel@chaos>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 29 May 2007 23:47:39 +0200

> get_next_timer_interrupt() returns a delta of (LONG_MAX > 1) in case
> there is no timer pending. On 64 bit machines this results in a
> multiplication overflow in tick_nohz_stop_sched_tick(). 
> 
> Reported by: Dave Miller <davem@davemloft.net>
> 
> Make the return value a constant and limit the return value to a 32 bit
> value.
> 
> When the max timeout value is returned, we can safely stop the tick
> timer device. The max jiffies delta results in a 12 days timeout for
> HZ=1000.
> 
> In the long term the get_next_timer_interrupt() code needs to be
> reworked to return ktime instead of jiffies, but we have to wait until
> the last users of the original NO_IDLE_HZ code are converted.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-off-by: David S. Miller <davem@davemloft.net>
