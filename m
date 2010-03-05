Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab0CEErS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 23:47:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43064 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab0CEErN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 23:47:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for child processes
Cc: kosaki.motohiro@jp.fujitsu.com,
       Lennart Poettering <lennart@poettering.net>,
       linux-kernel@vger.kernel.org, Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20100304140822.GA458@redhat.com>
References: <20100202120457.GA19605@omega> <20100304140822.GA458@redhat.com>
Message-Id: <20100305134247.EB5E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  5 Mar 2010 13:47:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 02/02, Lennart Poettering wrote:
> >
> > This patch adds a simple flag for each process that marks it as an
> > "anchor" process for all its children and grandchildren. If a child of
> > such an anchor dies all its children will not be reparented to init, but
> > instead to this anchor, escaping this anchor process is not possible. A
> > task with this flag set hence acts is little "sub-init".
> 
> Lennart, this patch adds a noticeable linux-only feature. I see
> your point, but imho your idea needs the "strong" acks. I cc'ed
> some heavyweights, if someone dislikes your idea he can nack it
> right now.
> 
> 
> Security. This is beyond my understanding, hopefully the cc'ed
> experts can help.
> 
> Should we clear ->child_anchor flags when the "sub-init" execs? Or,
> at least, when the task changes its credentials? Probably not, but
> dunno.
> 
> The more problematic case is when the descendant of the "sub-init"
> execs the setuid application. Should we allow the reparenting to
> !/sbin/init task in this case?
> 
> Should we clear ->pdeath_signal after reparenting to sub-init ?
> 
> Do we need the new security_operations->task_reparent() method ?
> Or, perhaps we can reuse ->task_wait() if we add the "parent"
> argument?
> 
> Something else we should think about?

I think changing reparent rule is a bit risky. instead, I propse
that exporting ANCHOR flag via /proc and ps parse it.

What do you think?



