Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYLEKlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYLEKlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYLEKll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:41:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54494 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbYLEKlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:41:40 -0500
Date: Fri, 5 Dec 2008 11:41:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: David Miller <davem@davemloft.net>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, eranian@googlemail.com, dada1@cosmosbay.com,
       robert.richter@amd.com, arjan@infradead.org, hpa@zytor.com,
       a.p.zijlstra@chello.nl, rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Message-ID: <20081205104116.GA5747@elte.hu>
References: <20081204225345.654705757@linutronix.de> <20081204.171233.201039452.davem@davemloft.net> <20081205061012.GA12785@elte.hu> <18744.62865.420502.642345@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18744.62865.420502.642345@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > The 'target' task does not have to be stopped to offer counter 
> > virtualization (counter overcommit or counter scheduling) - or to offer 
> > any of the other performance counter features. Please let us know why it 
> > needs the task to be stopped - we asked about that on lkml in the perfmon 
> > thread and no technical answer was given, and couldnt find any such 
> > technical reason while implementing it ourselves.
> 
> I like this feature of your patchset, in fact, and the code looks 
> pretty clean (as I would expect :).  What I don't like (as I have 
> already said) is having to use an API that splits up the PMU into 
> pieces, plus the requirement that flows from that to have the kernel 
> know about the event selection logic on every CPU model we support.
> 
> One thing I haven't figured out yet is what happens if you have a 
> counter on a task and the task dies.  Can I still use the counter fd 
> after the task has died, and read out the total count?

yes, it will work just the way you'd expect it to work: the counter is 
attached to the fd of the monitoring task, so it does not go away. The 
counter simply stops counting but otherwise can be read even after the 
monitored task has exited.

We are also planning a natural 'the task has died' notification: a -EPIPE 
returned by read(), after the final count has been allowed to be read 
out. With blocking counters this will behave quite smoothly: instead of 
blocking indefinitely, we'd get back -EPIPE. Hm?

	Ingo
