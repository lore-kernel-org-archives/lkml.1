Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbXCTIDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbXCTIDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 04:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbXCTIDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 04:03:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:59130 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753293AbXCTIDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 04:03:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Rbypp1GoRN6MC86ZlFrrpctfSKJhiRR177ILjLK
	70ZhfLrTH0heOH
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070320061152.GW943@1wt.eu>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca>
	 <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca>
	 <1174322580.30876.72.camel@frg-rhel40-em64t-04>
	 <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
	 <20070320061152.GW943@1wt.eu>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 09:03:07 +0100
Message-Id: <1174377787.9756.21.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 07:11 +0100, Willy Tarreau wrote:

> Also, while I don't agree with starting to renice X to get something usable,
> it seems real that there's something funny on Mike's system which makes it
> behave particularly strangely when combined with RSDL, because other people
> in comparable tests (including me) have found X perfectly smooth even with
> loads in the tens or even hundreds. I really suspect that we will find a bug
> in RSDL which triggers the problem and that this fix will help discover
> another problem on Mike's hardware which was not triggered by mainline.

I don't _think_ there's anything funny in my system, and Con said it was
the expected behavior with my testcase, but I won't rule it out.

Moving right along to the bugs part, I hope others are looking as well,
and not only talking.

One area that looks pretty fishy to me is cross-cpu wakeups and task
migration.  p->rotation appears to lose all meaning when you cross the
cpu boundary, and try_to_wake_up()is using that information in the
cross-cpu case.  In pull_task() OTOH, it checks to see if the task ran
on the remote cpu (at all, hmm), and if so tags the task accordingly.
It is not immediately obvious to me why this would be a good thing
though, because quotas of one runqueue don't appear to have any relation
to quotas of some other runqueue.  (i'm going to it that this old
information is meaningless)

	-Mike

