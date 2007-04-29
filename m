Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbXD2HRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbXD2HRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbXD2HRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:17:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbXD2HRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:17:49 -0400
Date: Sun, 29 Apr 2007 09:17:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lee Revell <rlrevell@joe-job.com>
Cc: tglx@linutronix.de, matthieu castet <castet.matthieu@free.fr>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: High Resolution Timer DOS
Message-ID: <20070429071743.GA4532@elte.hu>
References: <4633C269.9050806@free.fr> <1177798389.7646.320.camel@localhost.localdomain> <75b66ecd0704281537s54134967ybc3ddef0b87b6bf5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b66ecd0704281537s54134967ybc3ddef0b87b6bf5@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Lee Revell <rlrevell@joe-job.com> wrote:

> > Well, it is not really a DoS. The rescheduling of the process is 
> > limited by the scheduler and the available CPU time (depending on 
> > the number of runnable tasks in the system).
> 
> Shouldn't an unprivileged process be rate limited somehow to avoid 
> flooding the machine with interrupts?  We restrict nonroot users from 
> setting the RTC interrupt rate higher than 64Hz for a similar reason 
> (granted, this limit dates back to the 486 days and should probably be 
> increased to 1024 Hz).

No. An interrupt in this case is really just 'CPU time used up', and an 
unprivileged process can take up as much CPU time as the scheduler 
allows. So it's _not_ a DoS, and neither is any other unprivileged 
infinit loop (or high-rate context-switching task) a DoS.

	Ingo
