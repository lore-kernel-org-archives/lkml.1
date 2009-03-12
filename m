Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZCLQyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZCLQyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZCLQy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:54:27 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:58660 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZCLQy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:54:27 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Daniel Phillips <phillips@phunq.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, tux3@tux3.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
References: <200903110925.37614.phillips@phunq.net>
	<200903112238.55864.phillips@phunq.net>
	<20090311230713.d4710050.akpm@linux-foundation.org>
	<200903120133.02645.phillips@phunq.net>
Date: Fri, 13 Mar 2009 01:54:21 +0900
In-Reply-To: <200903120133.02645.phillips@phunq.net> (Daniel Phillips's
	message of "Thu, 12 Mar 2009 01:33:02 -0700")
Message-ID: <87ljraof5u.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> writes:

>> > > - What's "L"?
>> > > 
>> > > 		printf("%Lx-", (L)begin);
>> > 
>> > A very handy way of working around 32/64 bit format string issues.  We
>> > just cast all the messy cases to (long long), aka (L).  All other
>> > solutions to this messy problem are worse in my opinion, but whatever
>> > the ruling is, is what we will do.  This is used heavily in tracing and
>> > dumping code, which can all be turned off with ifdefs, so it doesn't
>> > affect production kernel text.
>> 
>> What format string issues are we talking about here?
>> 
>> See, a number of them will be fixed real soon now (geologically
>> speaking) when various 64-bit architectures switch their s64/u64
>> implementation from `long' to `long long'.
>
> Ah, that would be helpful.  But not done yet?  How long until it
> happens, and does it make sense to wait, so we can reduce the number
> of problems cases?  And... will it be all 64 bit arches or just some?
> Because this issue isn't solved if it isn't fixed for all arches.
>
> There are a couple of issues, one is u64 being (long) instead of
> (long long) as you say, and the other is variable type sizes like
> loff_t.  That specific one isn't actually a problem, we can just refuse
> to support 32 bit libc file ops, but there may be others.  We had a
> world of pain before (L) arrived, then with (L) it was easy.  Maybe
> just edit them all to (long long) for now, and damn the line length.

BTW, those are almost because of userland issue. Kernel are more and
more using same type. But, glibc is not. And we (tux3) are sharing the
same code with kernel and userland. Some types are depending to
CONFIG_*, so if we have generic cast type like (L).

[The fatfs also has own type (llu), if it become generic, fatfs will
also be happy.]

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
