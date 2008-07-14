Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbYGNJtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbYGNJtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbYGNJsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:48:54 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:62058 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbYGNJsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:48:53 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-5.tower-164.messagelabs.com!1216028932!17847471!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Mon, 14 Jul 2008 11:48:47 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH, RFC] use hrtimer in sched_clock
Message-ID: <20080714094847.GA7478@digi.com>
References: <1215809727-28598-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <alpine.LFD.1.10.0807141123450.3283@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.10.0807141123450.3283@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 14 Jul 2008 09:48:49.0250 (UTC) FILETIME=[D0E3BC20:01C8E596]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

Thomas Gleixner wrote:
> On Fri, 11 Jul 2008, Uwe Kleine-König wrote:
> > This should make it unnecessary to overwrite sched_clock for a higher
> > precision.
> > With this patch I get sub-jiffie timing with CONFIG_PRINTK_TIME=y.
> >
> > Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > ---
> > Hello,
> >
> > I tested the patch on arch-arm/mach-ns9xxx and it seem seams to work.
> > But I admit I didn't test it deeply and I didn't measure if there is any
> > overhead.
> 
> There is lots of overhead and your approach is simply wrong.
I expected to have some overhead, but can you please elaborate on
"simply wrong"?
I will try to measure the actual overhead but cannot promise to find
time for that in the near future.
 
> >  unsigned long long __attribute__((weak)) sched_clock(void)
> 
> The correct way to solve it is to override sched_clock() with a high
> resolution implementation for your hardware platform. sched_clock is a
> weak function to provide a default implementation based on jiffies.
> 
> If you do a grep -r sched_clock arch/arm you'll find a couple of
> examples how to override sched_clock().
I new that and my purpose was to make this unneeded.  Would be nice,
wouldn't it?

Thanks and best regards,
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
