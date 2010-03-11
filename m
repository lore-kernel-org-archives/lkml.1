Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab0CKEPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 23:15:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33765 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab0CKEPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 23:15:03 -0500
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>, Kay Sievers <kay.sievers@vrfy.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for child processes
References: <20100202120457.GA19605@omega> <20100304140822.GA458@redhat.com>
	<20100306001616.GH28657@tango.0pointer.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 10 Mar 2010 20:14:55 -0800
In-Reply-To: <20100306001616.GH28657@tango.0pointer.de> (Lennart Poettering's message of "Sat\, 6 Mar 2010 01\:16\:16 +0100")
Message-ID: <m1wrxjcx4w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: mzxreary@0pointer.de, roland@redhat.com, mtk.manpages@googlemail.com, torvalds@linux-foundation.org, kyle@redhat.com, kosaki.motohiro@jp.fujitsu.com, kay.sievers@vrfy.org, jmorris@namei.org, xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org, oleg@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Poettering <mzxreary@0pointer.de> writes:

> On Thu, 04.03.10 15:08, Oleg Nesterov (oleg@redhat.com) wrote:
>
>> Should we clear ->child_anchor flags when the "sub-init" execs? Or,
>> at least, when the task changes its credentials? Probably not, but
>> dunno.
>
> Since this flag is only useful for a very well defined type of processes
> (i.e. session managers, supervising daemons, init systems) it might make
> sense to reset it automatically when privs are dropped or we exec
> something. After all, I don't see how we'd gain any useful functionality
> when we allow this flag to continue to be set. However we would
> certainly be on the safer side when we reset it, because that way it can
> never leak it to processes that are differently privileged or do not
> expect it.
>
> So, for the sake of being on the safe side, I think we should reset the
> flag on exec()/setuid().
>
>> It is a bit strange that PR_SET_ANCHOR acts per-thread, not per
>> process.
>
> Yes, I agree, this should be per-process indeed.

Have you take a look at the pid namespace?

Except for the fact it requires privilege to create it seems to do
what you want.  It is certainly what I have been using when I want
an inescapable environment.

If nothing else I get the feeling that what you are after is
a generalization of the child_reaper feature in the pid namespace
and yet you haven't touched any of that code.

Eric
