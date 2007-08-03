Return-Path: <linux-kernel-owner+w=401wt.eu-S1764225AbXHCVvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764225AbXHCVvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 17:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763329AbXHCVvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 17:51:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763134AbXHCVvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 17:51:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill an obsolete sub-thread-ptrace stuff
In-Reply-To: Oleg Nesterov's message of  Saturday, 4 August 2007 01:04:41 +0400 <20070803210441.GA247@tv-sign.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20070803215101.481DD4D04BC@magilla.localdomain>
Date: Fri,  3 Aug 2007 14:51:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There is a couple of subtle checks which were needed to handle ptracing from
> the same thread group. This was deprecated a long ago, imho this code just
> complicates the understanding.

Looks ok to me.

> And, the "->parent->signal->flags & SIGNAL_GROUP_EXIT" check in exit_notify()
> is not right. SIGNAL_GROUP_EXIT can mean exec(), not exit_group(). This means
> ptracer can lose a ptraced zombie on exec(). Minor problem, but still the bug.

This bug never happens because this check is only in the now-impossible
ptrace-same-group case.  The code can certainly go.


Thanks,
Roland
