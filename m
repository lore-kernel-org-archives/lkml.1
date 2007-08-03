Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbXHCWAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbXHCWAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761886AbXHCWAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:00:35 -0400
Received: from mail.screens.ru ([213.234.233.54]:45407 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbXHCWAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:00:35 -0400
Date: Sat, 4 Aug 2007 02:00:48 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill an obsolete sub-thread-ptrace stuff
Message-ID: <20070803220048.GA277@tv-sign.ru>
References: <20070803210441.GA247@tv-sign.ru> <20070803215101.481DD4D04BC@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803215101.481DD4D04BC@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Roland McGrath wrote:
>
> > There is a couple of subtle checks which were needed to handle ptracing from
> > the same thread group. This was deprecated a long ago, imho this code just
> > complicates the understanding.
> 
> Looks ok to me.

Thanks!

> > And, the "->parent->signal->flags & SIGNAL_GROUP_EXIT" check in exit_notify()
> > is not right. SIGNAL_GROUP_EXIT can mean exec(), not exit_group(). This means
> > ptracer can lose a ptraced zombie on exec(). Minor problem, but still the bug.
> 
> This bug never happens because this check is only in the now-impossible
> ptrace-same-group case.

This means that changelog is wrong and should be changed.

However, I disagree. exit_notify() doesn't check the ptrace-same-group case. So,
unless I missed something, we set EXIT_DEAD in any case, even if ptracer doesn't
belong to our thread group.

No?

Oleg.

