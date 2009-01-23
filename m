Return-Path: <linux-kernel-owner+w=401wt.eu-S1761312AbZAWJX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761312AbZAWJX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZAWJXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:23:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47966 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465AbZAWJXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:23:12 -0500
Date: Fri, 23 Jan 2009 10:23:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Baines <msb@google.com>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
Subject: Re: [PATCH v3] softlockup: remove hung_task_check_count
Message-ID: <20090123092306.GB29820@elte.hu>
References: <20090122083457.GC7438@elte.hu> <20090122195513.GA22146@google.com> <1fe6c7900901221921m586b129dwf8c3446f897b57f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fe6c7900901221921m586b129dwf8c3446f897b57f0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Baines <msb@google.com> wrote:

> On Thu, Jan 22, 2009 at 11:55 AM, Mandeep Singh Baines <msb@google.com> wrote:
> >
> > The unlock and lock could be removed and only compiled in if PREEMPT.
> > If the number of tasks isn't bound, the lock might be held too long.
> >
> 
> This is incorrect. The adding the lock and unlock will not make the
> system more pre-emptive. To be more pre-emptive you'd want to check
> need_resched() as often as possible.
> 
> > It would be kinda funny if hung_task caused a softlockup.
> >
> 
> Again. This is incorrect. Rescheduling if need_resched() will prevent 
> softlockup.
> 
> Not sure what I was thinking this morning;)
> 
> However, I am happy with the patch. To give writers a chance, the lock 
> should held for bounded time. Holding the lock in khungtask (which is 
> running at low scheduler priority) could potentially be delaying 
> important work. The longer the lock is held, the bigger the priority 
> inversion problem.

not sure i like the whole idea of removing the max iterations check. In 
theory if there's a _ton_ of tasks, we could spend a lot of time looping 
there. So it always looked prudent to limit it somewhat.

	Ingo
