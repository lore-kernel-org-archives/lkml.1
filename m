Return-Path: <linux-kernel-owner+w=401wt.eu-S965197AbXCVAxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197AbXCVAxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 20:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965475AbXCVAxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 20:53:44 -0400
Received: from mail03.syd.optusnet.com.au ([211.29.132.184]:53725 "EHLO
	mail03.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965197AbXCVAxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 20:53:43 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Subject: Re: [PATCH] sched: rsdl improvements
Date: Thu, 22 Mar 2007 11:52:44 +1100
User-Agent: KMail/1.9.5
Cc: Artur Skawina <art_k@o2.pl>, linux list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703220429.45311.kernel@kolivas.org> <4601C44B.9060705@mnsu.edu> <200703221124.59126.kernel@kolivas.org>
In-Reply-To: <200703221124.59126.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703221152.45141.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2007 11:24, Con Kolivas wrote:
> On Thursday 22 March 2007 10:48, Jeffrey Hundstad wrote:
> > Artur Skawina wrote:
> > > Con Kolivas wrote:
> > >> Note no interactive boost idea here.
> > >>
> > >> Patch is for 2.6.21-rc4-mm1. I have not spent the time trying to bring
> > >> other bases in sync.
> > >
> > > I've tried RSDLv.31+this on 2.6.20.3 as i'm not tracking -mm.
> > >
> > >> Further improve the deterministic nature of the RSDL cpu scheduler and
> > >> make the rr_interval tunable.
> > >>
> > >> By only giving out priority slots to tasks at the current runqueue's
> > >> prio_level or below we can make the cpu allocation not altered by
> > >> accounting issues across major_rotation periods. This makes the cpu
> > >> allocation and latencies more deterministic, and decreases maximum
> > >> latencies substantially. This change removes the possibility that
> > >> tasks can get bursts of cpu activity which can favour towards
> > >> interactive tasks but also favour towards cpu bound tasks which happen
> > >> to wait on other activity (such as I/O) and is a net gain.
> > >
> > > I'm not sure this is going in the right direction... I'm writing
> > > this while compiling a kernel w/ "nice -20 make -j2" and X is almost
> >
> > Did you mean "nice -20"?  If so, that should have slowed X quite a bit.
> > Try "nice 19" instead.
> >
> > nice(1):
> >        Run  COMMAND  with an adjusted niceness, which affects process
> > scheduling.  With no COMMAND, print the current  niceness.   Nicenesses
> > range from -20 (most favorable scheduling) to 19 (least favorable).
>
> No he's right. Something scrambled my brain and I've completely left out
> the part where I offer the old bursts as a tunable option as well, which
> unintentionally killed off SCHED_BATCH as an entity. I'll have to put that
> as an additional patch sorry as this by itself is not always a win. Hang in
> there.

Actually, reworking the priority matrix to always have a slot at position 1 
should fix this without needing a tunable. That is a better approach so I'll 
do that.

-- 
-ck
