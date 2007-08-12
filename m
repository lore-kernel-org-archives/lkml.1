Return-Path: <linux-kernel-owner+w=401wt.eu-S938614AbXHLXES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938614AbXHLXES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 19:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933778AbXHLXEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 19:04:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763328AbXHLXEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 19:04:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 3/4] signalfd: fix interaction with posix-timers
In-Reply-To: Oleg Nesterov's message of  Sunday, 12 August 2007 21:05:30 +0400 <20070812170530.GA4302@tv-sign.ru>
X-Zippy-Says: Will it improve my CASH FLOW?
Message-Id: <20070812230350.A6F874D057D@magilla.localdomain>
Date: Sun, 12 Aug 2007 16:03:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This only affects signalfd and so the core change seems ok vs status quo.

I think it would be better overall not to have anyone like signalfd calling
dequeue_signal in its current form at all.  (The function is too much an
internal piece of the core signals code.  The SIGNAL_STOP_DEQUEUED code
applying for signalfd calls is probably another problem, for example.)


Thanks,
Roland
