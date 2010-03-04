Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0CDWOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:14:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903Ab0CDWOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:14:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Lennart Poettering <lennart@poettering.net>, linux-kernel@vger.kernel.org,
       Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>, Kay Sievers <kay.sievers@vrfy.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
	for child processes
In-Reply-To: Oleg Nesterov's message of  Thursday, 4 March 2010 15:08:22 +0100 <20100304140822.GA458@redhat.com>
References: <20100202120457.GA19605@omega>
	<20100304140822.GA458@redhat.com>
X-Shopping-List: (1) Curious carrion
   (2) Indifferent gravy shoes
   (3) Lunar pencils
   (4) Ambiguous furious travesty
Message-Id: <20100304221434.17567187@magilla.sf.frob.com>
Date: Thu,  4 Mar 2010 14:14:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Security. This is beyond my understanding, hopefully the cc'ed
> experts can help.

There are a few different aspects of behavior change to think about.

1. Who can get a SIGCHLD and wait result they weren't expecting.
2. Who sees some PID for getppid() when they are expecting 1.
3. What ps shows.

When I start thinking through what might be security issues, they are
almost all #1 questions.  There is a hairy nest of many variations of #1
questions.  The #2 question is pretty simple, but it also could be an issue
for security when setuid is involved (or just correctness for any
application).

My impression is that #3 is the only actual motivation for this feature.
So perhaps we should consider an approach that leaves the rest of the
semantics alone and only affects that.

Lennart, am I right that this is all you are looking for?  Does it even
matter to you that this change the PPID that ps groks today?  How about if
it's just an entirely new kind of assocation that ps et al can learn to
display, and not even the traditional PPID field changes?

> To me, it looks more natural if PR_SET_ANCHOR marks the whole process as
> a local reaper, not only the thread which called PR_SET_ANCHOR.

Agreed.  It could probably be a bit in signal_struct.flags,
which also means no memory cost for adding the feature.


Thanks,
Roland
