Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0CINVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 08:21:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab0CINVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 08:21:31 -0500
Date: Tue, 9 Mar 2010 14:19:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
       Roland McGrath <roland@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
	for child processes
Message-ID: <20100309131935.GA11467@redhat.com>
References: <20100202120457.GA19605@omega> <20100304140822.GA458@redhat.com> <20100304221434.17567187@magilla.sf.frob.com> <ac3eb2511003051051r50468752o607a8a0309d5ce2e@mail.gmail.com> <20100305191816.5EC8ACC@magilla.sf.frob.com> <20100306002414.GJ28657@tango.0pointer.de> <2c0942db1003081645y4063ed29va6763151f53a282a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db1003081645y4063ed29va6763151f53a282a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Ray Lee wrote:
>
> The kernel already offers system-wide process exit notification via
> taskstats (a netlink interface), though unfortunately I believe it's
> optional. It's pretty easy to use (as these things go, anyway -- I was
> able to hack up an arbitrary process exit watcher in about a half hour
> based on Documentation/accounting/getdelays.c).

Or proc connector (optional too). Unlike taskstats it notifies about
fork() as well. But, iirc it doesn't allow to filter out the unwanted pids.

Actually, I don't really understand how PR_SET_ANCHOR task can monitor
several daemons. I mean, when the grandchild dies, the sub-init doesn't
know who forked this child during daemonize().


Cough, can't resist... With utrace it would very simple to create the
module which allows to monitor the child's fork/exit/etc with almost
zero overhead, and this overhead only applies to the "traced" tasks.

Oleg.

