Return-Path: <linux-kernel-owner+w=401wt.eu-S1762253AbYDVTJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762253AbYDVTJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYDVTJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:09:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbYDVTJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:09:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] posix timers: don't discard the signal if the timer was explicitly destroyed
In-Reply-To: Oleg Nesterov's message of  Tuesday, 22 April 2008 19:38:21 +0400 <20080422153821.GA19903@tv-sign.ru>
References: <20080422153821.GA19903@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080422190849.6443E270381@magilla.localdomain>
Date: Tue, 22 Apr 2008 12:08:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am not sure this patch is really needed, please review.

I don't think this is worth doing.

> The previous patch adds the user-visible change. It is not clear to me why
> should we cancel the pending signal sent by the timer after timer_delete().
> Suppose the signal is blocked, pending, the user checks sys_rt_sigpending(),
> destroys the timer and then doesn't see the signal.

So?  POSIX says it's unspecified what happens to such a signal, so an
application can't rely on it one way or the other.  I don't see any reason
to complicate it further.


Thanks,
Roland
