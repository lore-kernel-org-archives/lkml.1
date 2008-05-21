Return-Path: <linux-kernel-owner+w=401wt.eu-S932744AbYEUCZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbYEUCZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbYEUCZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:25:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757509AbYEUCZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:25:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] signals: introduce SIGQUEUE_CANCELLED
In-Reply-To: Oleg Nesterov's message of  Saturday, 17 May 2008 19:14:21 +0400 <20080517151421.GA9499@tv-sign.ru>
References: <20080517151421.GA9499@tv-sign.ru>
X-Shopping-List: (1) Prestigious contraptions
   (2) Oligarchical cushion buttons
   (3) Chic ablutions
   (4) Gorgeous caustic persuaders
Message-Id: <20080521022440.8B23726FA1C@magilla.localdomain>
Date: Tue, 20 May 2008 19:24:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Introduce SIGQUEUE_CANCELLED flag. If it is set, the pending signal should be
> ignored and collect_signal() should return 0.

Acked-by: Roland McGrath <roland@redhat.com>

> Note that the new flag is completely orthogonal to SIGQUEUE_PREALLOC, and it
> can be set without ->siglock held.

I think to keep things easier to understand, we should say the rule is that
touching q->flags is always controlled by siglock when q is on a queue.
Before it's queued or after it's been dequeued (i.e. list_empty(&q->list)
with siglock held), then the "owner" of the struct sigqueue of course needs
noone's siglock.


Thanks,
Roland
