Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbYGNKEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbYGNKEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 06:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbYGNKDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 06:03:55 -0400
Received: from www.tglx.de ([62.245.132.106]:47616 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbYGNKDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 06:03:55 -0400
Date: Mon, 14 Jul 2008 12:03:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH, RFC] use hrtimer in sched_clock
In-Reply-To: <20080714094847.GA7478@digi.com>
Message-ID: <alpine.LFD.1.10.0807141156090.3283@apollo.tec.linutronix.de>
References: <1215809727-28598-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <alpine.LFD.1.10.0807141123450.3283@apollo.tec.linutronix.de> <20080714094847.GA7478@digi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1726309952-1216029822=:3283"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1726309952-1216029822=:3283
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 14 Jul 2008, Uwe Kleine-König wrote:
> > > I tested the patch on arch-arm/mach-ns9xxx and it seem seams to work.
> > > But I admit I didn't test it deeply and I didn't measure if there is any
> > > overhead.
> > 
> > There is lots of overhead and your approach is simply wrong.
> I expected to have some overhead, but can you please elaborate on
> "simply wrong"?

It's wrong because it has a locking problem vs. xtime lock. Try
printk() in a code region which has xtime_lock write locked.

> > If you do a grep -r sched_clock arch/arm you'll find a couple of
> > examples how to override sched_clock().
> I new that and my purpose was to make this unneeded.  Would be nice,
> wouldn't it?

It would be nice, but it's simply not possible as each hardware
platform has a different hardware which is used for that. Also your
approach enforces that the hardware which is used for sched_clock is
the same as the one which is used for timekeeping. That's not
necessarily a good idea as we can use a less accurate and less
reliable hardware for sched_clock() than for timekeeping and we want
to do that when the sched_clock() hardware is faster to access.

Thanks,

	tglx
--8323328-1726309952-1216029822=:3283--
