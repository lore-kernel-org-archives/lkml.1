Return-Path: <linux-kernel-owner+w=401wt.eu-S1757145AbZCODhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbZCODhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 23:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbZCODgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 23:36:55 -0400
Received: from phunq.net ([64.81.85.152]:47007 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755210AbZCODgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 23:36:54 -0400
From: Daniel Phillips <phillips@phunq.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Sat, 14 Mar 2009 20:36:50 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, tux3@tux3.org,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903120133.02645.phillips@phunq.net> <87ljraof5u.fsf@devron.myhome.or.jp>
In-Reply-To: <87ljraof5u.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903142036.50335.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, OGAWA Hirofumi wrote:
> Daniel Phillips <phillips@phunq.net> writes:
> >> > > - What's "L"?
> >> > > 
> >> > > 		printf("%Lx-", (L)begin);
> >> > 
> >> > A very handy way of working around 32/64 bit format string issues.  We
> >> > just cast all the messy cases to (long long), aka (L).  All other
> >> > solutions to this messy problem are worse in my opinion, but whatever
> >> > the ruling is, is what we will do.  This is used heavily in tracing and
> >> > dumping code, which can all be turned off with ifdefs, so it doesn't
> >> > affect production kernel text.
> >> 
> >> What format string issues are we talking about here?
> >> 
> >> See, a number of them will be fixed real soon now (geologically
> >> speaking) when various 64-bit architectures switch their s64/u64
> >> implementation from `long' to `long long'.
> >
> > Ah, that would be helpful.  But not done yet?  How long until it
> > happens, and does it make sense to wait, so we can reduce the number
> > of problems cases?  And... will it be all 64 bit arches or just some?
> > Because this issue isn't solved if it isn't fixed for all arches.
> >
> > There are a couple of issues, one is u64 being (long) instead of
> > (long long) as you say, and the other is variable type sizes like
> > loff_t.  That specific one isn't actually a problem, we can just refuse
> > to support 32 bit libc file ops, but there may be others.  We had a
> > world of pain before (L) arrived, then with (L) it was easy.  Maybe
> > just edit them all to (long long) for now, and damn the line length.
> 
> BTW, those are almost because of userland issue. Kernel are more and
> more using same type. But, glibc is not. And we (tux3) are sharing the
> same code with kernel and userland. Some types are depending to
> CONFIG_*, so if we have generic cast type like (L).
> 
> [The fatfs also has own type (llu), if it become generic, fatfs will
> also be happy.]
> 
> Thanks.

Maybe we should argue for some generic flavor of the (L)/(llu) idea
then.  I suppose we should figure out exactly how much of our usage
will remain after the kernel issue is resolved.  One small thing we
could do is make it a typedef instead of a macro.  And spelling it
out completely as (long long) is not so bad, except it loses the
desirable property of being able to grep for the messy thing, and
adds a painful amount of useless line length, given how frequently
the issue shows up.

Regards,

Daniel
