Return-Path: <linux-kernel-owner+w=401wt.eu-S1763182AbXK2RRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763182AbXK2RRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758487AbXK2RRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:17:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37740 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758399AbXK2RRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:17:03 -0500
Date: Thu, 29 Nov 2007 18:16:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Dike <jdike@addtoit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: scheduling anomaly on uml (was: -rt doesn't compile for UML)
Message-ID: <20071129171647.GA1326@elte.hu>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu> <20071128182935.GA8048@c2.user-mode-linux.org> <E1IxRv7-0007e8-Dq@dorka.pomaz.szeredi.hu> <E1IxgUe-00011b-Sl@dorka.pomaz.szeredi.hu> <20071129170205.GA7415@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129170205.GA7415@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Dike <jdike@addtoit.com> wrote:

> On Thu, Nov 29, 2007 at 11:19:40AM +0100, Miklos Szeredi wrote:
> >     date-7119  0.... 15636591us!: schedule <bash-502> (0 0)
> >     bash-502   0.... 15643908us!: schedule <date-7119> (0 0)
> >     bash-502   0.... 15646250us!: schedule <date-7120> (0 0)
> 
> How exactly did you end up getting this data?
> 
> And is there something I can read to tell what it means?

the header of /proc/latency_trace explains the format:

                 _------=> CPU#
                / _-----=> irqs-off
               | / _----=> need-resched
               || / _---=> hardirq/softirq
               ||| / _--=> preempt-depth
               |||| /
               |||||     delay
   cmd     pid ||||| time  |   caller
      \   /    |||||   \   |   /
 privoxy-12926 1.Ns1    0us : ktime_get_ts (ktime_get)

'time' is timestamp in microseconds. Then come the caller (and parent, 
or other, special parameters like the task-pid of the scheduled task). 
It's supposed to be easy to read to kernel hackers - let me know if any 
of the details is non-obvious.

for example:

> >     date-7119  0.... 15636591us!: schedule <bash-502> (0 0)

the task 'date' (pid 7119) scheduled at timestamp 15636591us, and 
switched to another task 'bash' (pid 502). Both had a default nice level 
of 0 [the (0 0) arguments].

	Ingo
