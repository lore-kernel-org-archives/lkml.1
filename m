Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYIWFVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYIWFVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 01:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYIWFVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 01:21:32 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:38119 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751505AbYIWFVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 01:21:32 -0400
In-Reply-To: <20080922141051.GA252@tv-sign.ru>
References: <20080922040404.10477.24678.sendpatchset@localhost.localdomain> <20080922040417.10477.35834.sendpatchset@localhost.localdomain> <20080922141051.GA252@tv-sign.ru>
Subject: Re: [PATCH 1/2]: workqueue: Implement the kernel API
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Lotus Notes Release 8.0.1 February 07, 2008
Message-ID: <OF5B8F9145.E318A14A-ON652574CD.0011584E-652574CD.001D5C8F@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Tue, 23 Sep 2008 10:50:42 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 7.0.2FP2HF300 | September
 14, 2007) at 09/23/2008 10:53:38
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> wrote on 09/22/2008 07:40:51 PM:

Thanks for your review comments, Oleg.

> > + * Passing delay=0 will result in immediate queueing of the entry,
whether
> > + * queue'd earlier or otherwise.
>
> The comment doesn't match the code ;)

Right! The delay=0 doesn't result in immediate queueing of the entry iff
the
current time has just hit the expiry time (or the timer has not fired yet).
The intention was to allow the existing code handle the timer/queueing in
this case, but I agree the comment has to be changed to explain that.

> > +       * Already present in workqueue. Check if the timer expiry is
> > +       * the same. Also, optimize in case requests are within one
> > +       * jiffy beyond the set expiry.
> > +       */
> > +      if (time_in_range(jiffies + delay, timer->expires,
> > +              timer->expires + 1))
> > +         return;
>
> Not that I argue, but do we really need to optimize this very unlikely
case?

Agree.

> This way the fast path is really fast, and the patch becomes simpler.
>
> What do you think? We can optimize the code (the usage of
cancel_work_sync)
> further, but perhaps this is enough.

Thanks for the suggestion. I will code it up and get some testing numbers.
Can I run
this by you?

Thanks,

- KK

