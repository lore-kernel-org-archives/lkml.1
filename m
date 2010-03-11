Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0CKH4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:56:53 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38508 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0CKH4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:56:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for child processes
Cc: kosaki.motohiro@jp.fujitsu.com, Lennart Poettering <mzxreary@0pointer.de>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <m1wrxjcx4w.fsf@fess.ebiederm.org>
References: <20100306001616.GH28657@tango.0pointer.de> <m1wrxjcx4w.fsf@fess.ebiederm.org>
Message-Id: <20100311165440.9502.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Mar 2010 16:56:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Lennart Poettering <mzxreary@0pointer.de> writes:
> 
> > On Thu, 04.03.10 15:08, Oleg Nesterov (oleg@redhat.com) wrote:
> >
> >> Should we clear ->child_anchor flags when the "sub-init" execs? Or,
> >> at least, when the task changes its credentials? Probably not, but
> >> dunno.
> >
> > Since this flag is only useful for a very well defined type of processes
> > (i.e. session managers, supervising daemons, init systems) it might make
> > sense to reset it automatically when privs are dropped or we exec
> > something. After all, I don't see how we'd gain any useful functionality
> > when we allow this flag to continue to be set. However we would
> > certainly be on the safer side when we reset it, because that way it can
> > never leak it to processes that are differently privileged or do not
> > expect it.
> >
> > So, for the sake of being on the safe side, I think we should reset the
> > flag on exec()/setuid().
> >
> >> It is a bit strange that PR_SET_ANCHOR acts per-thread, not per
> >> process.
> >
> > Yes, I agree, this should be per-process indeed.
> 
> Have you take a look at the pid namespace?
> 
> Except for the fact it requires privilege to create it seems to do
> what you want.  It is certainly what I have been using when I want
> an inescapable environment.
> 
> If nothing else I get the feeling that what you are after is
> a generalization of the child_reaper feature in the pid namespace
> and yet you haven't touched any of that code.

I guess it doesn't fit for gnome-session. because gtop or similar
system monitoring process assume it can see all processes in the system.

thanks.

