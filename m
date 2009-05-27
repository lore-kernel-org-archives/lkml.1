Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbZE0BH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbZE0BH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbZE0BHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:07:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105AbZE0BHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:07:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
In-Reply-To: Oleg Nesterov's message of  Monday, 25 May 2009 21:39:32 +0200 <20090525193932.GA22261@redhat.com>
References: <20090525185502.GA20781@redhat.com>
	<20090525193932.GA22261@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090527010612.0264FFC36B@magilla.sf.frob.com>
Date: Tue, 26 May 2009 18:06:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> While this change is correct in any case (I hope), I wonder whether
> we need another one:
[...]
> If the sub-thread is not traced, but ->group_leader is, perhaps it makes
> more sense to notify the leader's tracer, not parent?

I don't think so.

> Not that I think this is really important. Just curious about what was
> the intent.

Here is how I would describe the intent (admittedly this logic is
retrospective, not necessarily articulated as such when the code was
written).  If the the triggering task is ptrace'd, this report is "for
ptrace purposes"--even if it's the CLD_STOPPED case.  Otherwise, what's
being reported is "the whole POSIX process is now stopped as per POSIX
definitions".  The latter properly goes to the parent of the process,
which is the group_leader->real_parent.


Thanks,
Roland
