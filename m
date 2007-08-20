Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbXHTTF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbXHTTF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXHTTFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:05:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39974 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbXHTTFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:05:18 -0400
Date: Mon, 20 Aug 2007 21:05:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070820190509.GA3714@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <1187629438.8541.40.camel@localhost> <20070820180810.GA25160@elte.hu> <1187634782.4028.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187634782.4028.10.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Mon, 2007-08-20 at 20:08 +0200, Ingo Molnar wrote:
> > For sched_clock()'s behavior while the virtual CPU is idle: my current 
> > idea for that is the patch below (a loosely analoguous problem exists 
> > with nohz/dynticks): it makes sched_clock() valid across idle periods 
> > too and uses wall-clock time for that.
> 
> Ok, that would mean that sched_clock can just return the virtual cpu 
> time and the two hooks starts and stops the idle periods as far as the 
> scheduler is concerned. In this case we can use the patch from Jan 
> with the new implementation for sched_clock and add the two hooks to 
> the places where the cpu-idle notifiers are done (do_monitor_call and 
> default_idle). In fact this could be an idle-notifier. Hmm, I take a 
> closer look tomorrow when I'm back at the office.

ok. Just to make it sure wrt. release-management: you said s390 
sched_clock() is currently at least as precise as stime/utime - so this 
would suggest that there is no regression over v2.6.22? Regardless of 
whether it's a live regression or not, i think we want the nohz 
improvement (and the s390 patch if the callbacks are OK to you) in .23, 
and we want to migrate all users of "raw" sched_clock() [blktrace, 
softlockup-detector, print-timestamps, etc.] over to the better 
cpu_clock() interface.

	Ingo
