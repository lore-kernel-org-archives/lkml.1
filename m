Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbZAGRi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbZAGRi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759364AbZAGRi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:38:28 -0500
Received: from bsdimp.com ([199.45.160.85]:64771 "EHLO harmony.bsdimp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759128AbZAGRi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:38:27 -0500
Date: Wed, 07 Jan 2009 10:36:45 -0700 (MST)
Message-Id: <20090107.103645.480811344.imp@bsdimp.com>
To: linasvepstas@gmail.com
Cc: mayer@ntp.isc.org, david@lang.hm, hancockr@shaw.ca, kyle@moffetthome.net,
       slashdot@jameshallam.info, goodgerster@gmail.com,
       davidn@davidnewall.com, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, pretzalz@techhouse.org,
       burdell@iruntheinter.net, nick@nick-andrew.net, jeff@kosowsky.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
From: "M. Warner Losh" <imp@bsdimp.com>
In-Reply-To: <3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>
References: <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
	<49642674.9080703@ntp.isc.org>
	<3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message: <3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>
            "Linas Vepstas" <linasvepstas@gmail.com> writes:
: However, during the discussion, the idea came out that
: maybe keeping UTC time in the kernel is just plain stupid.
: So there's this idea floating around that maybe the kernel
: should keep TAI time instead. The hope is that this will
: reduce the complexity in the kernel, and push it out to
: user space, "where it belongs" (to repeat a well-worn
: mantra).

I agree that this is where it belongs, but it is hard to do that in a
POSIX compliant way.  It also becomes hard to timestamp things in
filesystems using UTC rather than TAI.  There are other protocols that
deal with UTC times as well.

: However, *if* we were to kick UTC out of the kernel,
: and push it to user-land, then, of course, there's a
: different problem: how does the kernel know what the
: correct TAI time is?  As your reply makes abundantly
: clear, NTP is not a good source for TAI information.

Agreed.  That's the whole crux of the 'multiple time scales suck'
threads that I've talked about in other forums.  You have to know this
information before you start, have to deal with 'dusty system' problem
for systems that have been off for 6 months or not upgraded.  You also
have to cope with learning after the fact that your initial guess was
wrong.

I've had many systems that would get this information from GPS and
stall the rest of the system until this data came in.  I did this
mostly because there were big issues with the software down stream if
you changed the delta between your putative UTC and TAI after the
fact.

: The comments which you labelled as "non-sense" were
: a mis-understanding of  a discussion of a particular issue
: that would arise if the kernel were to keep TAI -- if it did,
: then user-space systems would need to have a reliable
: source for leap-seconds. Since NTP does not
: provide this, there was discussion about how that
: could be worked-around. This then lead to the comment
: that, "gee, wouldn't the right long-term solution be that
: NTP provide TAI info?"

I've wanted this for a long time...

: Clearly, it would be a lot of work to get the kernel to keep
: TAI instead of UTC, so this is not, at this time, a "serious
: proposal".  But if it were possible, and all the various
: little issues that result were solvable, then it does seem
: like a better long-term solution.

Yes.  The kernel would need to be able to return both UTC and TAI
times to the kernel as well, since there are requirements for NFS to
return timestamps in UTC, not in TAI.  Many file systems specify UTC
time, or have traditionally been implemented that way.

Warner
