Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYC1NmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYC1NmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYC1Nlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:41:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbYC1Nly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:41:54 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
References: <20080327132057.449831367@polymtl.ca>
	<20080327154053.GA5890@elte.hu>
	<2f11576a0803271008t7574ead1s9ea285d8df57ef1@mail.gmail.com>
	<20080328101500.GF30863@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 28 Mar 2008 09:40:06 -0400
In-Reply-To: <20080328101500.GF30863@elte.hu> (Ingo Molnar's message of "Fri, 28 Mar 2008 11:15:00 +0100")
Message-ID: <y0mabkjvufd.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> >  NACK-ed-by: Ingo Molnar <mingo@elte.hu>
>> [...]
>> I wonder why nobody doesn't fix this serious problem until now. [...]

Frankly, the "problem" has not yet been established.  Ingo has failed
to respond to Mathieu's analysis of the actual instruction streams,
which cast doubt on Ingo's technique of simply counting bytes.  So
far, neither Ingo nor Mathieu have published *time measurements* to
quantify the actual (as opposed to speculated) costs.


> [...]  furthermore, and because it's Friday again, let me remind
> folks that SystemTap has an even more significant bloat problem: the
> fact that it needs a huge download: [...the dwarf debugging
> information...]

It's a problem, and there are a few improvements under way or being
contemplated:

- compression of the DWARF data to eliminate more duplication
- support for inserting probes only on function entry/exit points
  without debugging data - relying on symbol tables and raw ABI
- a networked service to allow one machine to serve site-wide
  systemtap needs

At the end of the day, lots of information will still need to be
around for those who need to put probes approximately anywhere and to
pull approximately any data out.


> for heaven's sake, we can have 3 years of _full Linux kernel
> history_, with all 87875 commits, with full changelog and
> dependencies and full source code included, packed into a rather
> tight, 180 MB git repository

It may seem counterintuitive to you, but remember that object code is
recreated from scratch new every build, yet source code only gradually
(?)  changes.  Try checking in 3 years' builds of stripped object
files into a git repo.


- FChE
