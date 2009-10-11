Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZJKKSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZJKKSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 06:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbZJKKSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 06:18:16 -0400
Received: from bu3sch.de ([62.75.166.246]:45453 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbZJKKSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 06:18:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: NOHZ: local_softirq_pending 08
Date: Sun, 11 Oct 2009 12:17:30 +0200
User-Agent: KMail/1.9.9
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless <linux-wireless@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
References: <20091011095217.GA2200@darkstar> <1255255735.4095.53.camel@johannes.local>
In-Reply-To: <1255255735.4095.53.camel@johannes.local>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910111217.31883.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 October 2009 12:08:55 Johannes Berg wrote:
> On Sun, 2009-10-11 at 17:52 +0800, Dave Young wrote:
> 
> > With kernel 2.6.32-rc3-00052-g0eca52a I got following KERN_ERR
> > messages just while using firefox:
> > 
> > [  130.527399] NOHZ: local_softirq_pending 08
> 
> > Any idea? or known issue?
> 
> Are you using b43 (or wl12x1)? If so, it's a known issue, but the driver
> was recently left without an active maintainer in a brouhaha about a bug
> fix.
> 
> Cf. http://thread.gmane.org/gmane.linux.kernel.wireless.general/39440
> 
> Absent proof that mac80211 is safe to run with BHs enabled, the correct
> solution is disabling tasklets around the RX function, unlike all the
> proposed patches. However, Michael thinks it's such a bad solution that
> he has refused to implement it.

Ehm, no. That's not exactly true.
We call the non-_irqsafe functions, which by definition are designed to
run in non-irq (soft or hard) context. At least that's how I understand the
documentation, last time I read it.
Why don't you simply do local_bh_disable() in those functions, if they
require bh disabled, instead of depending on the driver doing it?

> FWIW, I believe the bug to be in b43 and wl12x1, and not as Michael
> thinks in the stack.

If mac80211 requires BHs disabled, it should do this.

-- 
Greetings, Michael.
