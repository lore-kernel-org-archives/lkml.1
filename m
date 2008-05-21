Return-Path: <linux-kernel-owner+w=401wt.eu-S1763375AbYEUC2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375AbYEUC2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbYEUC16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:27:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933709AbYEUC14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:27:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] posix timers: use SIGQUEUE_CANCELLED when the timer is destroyed
In-Reply-To: Oleg Nesterov's message of  Sunday, 18 May 2008 21:15:43 +0400 <20080518171543.GA25855@tv-sign.ru>
References: <20080517151422.GA9502@tv-sign.ru>
	<20080517153140.GA9534@tv-sign.ru>
	<alpine.LFD.1.10.0805171006090.3020@woody.linux-foundation.org>
	<20080518171543.GA25855@tv-sign.ru>
X-Windows: a moment of convenience, a lifetime of regret.
Message-Id: <20080521022750.AD7EF26FA1C@magilla.localdomain>
Date: Tue, 20 May 2008 19:27:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	q->flags |= SIGQUEUE_CANCELLED;
> 	spin_lock_irqsave(lock, flags);
> 	q->flags &= ~SIGQUEUE_PREALLOC;

Just make it:

	spin_lock_irqsave(lock, flags);
	q->flags |= SIGQUEUE_CANCELLED;
	q->flags &= ~SIGQUEUE_PREALLOC;

and we needn't wax philosophical about the meaning of locking rules.  That
patch would have my ACK, but I concur with Linus about the undesireability
of the plain = version.


Thanks,
Roland
