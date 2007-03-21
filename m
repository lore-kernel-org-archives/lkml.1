Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbXCUXiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbXCUXiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXCUXiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:38:12 -0400
Received: from dkj137.neoplus.adsl.tpnet.pl ([83.24.13.137]:62842 "EHLO
	dkj137.neoplus.adsl.tpnet.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbXCUXiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:38:10 -0400
X-Greylist: delayed 665 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Mar 2007 19:38:09 EDT
Message-ID: <4601BF45.7070708@o2.pl>
Date: Thu, 22 Mar 2007 00:27:01 +0100
From: Artur Skawina <art_k@o2.pl>
User-Agent: Thunderbird 3.0a1 (X11/20070320)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: linux list <linux-kernel@vger.kernel.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: rsdl improvements
References: <200703220429.45311.kernel@kolivas.org>
In-Reply-To: <200703220429.45311.kernel@kolivas.org>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> Note no interactive boost idea here.
> 
> Patch is for 2.6.21-rc4-mm1. I have not spent the time trying to bring other
> bases in sync.

I've tried RSDLv.31+this on 2.6.20.3 as i'm not tracking -mm.

> Further improve the deterministic nature of the RSDL cpu scheduler and make
> the rr_interval tunable.
> 
> By only giving out priority slots to tasks at the current runqueue's
> prio_level or below we can make the cpu allocation not altered by accounting
> issues across major_rotation periods. This makes the cpu allocation and
> latencies more deterministic, and decreases maximum latencies substantially.
> This change removes the possibility that tasks can get bursts of cpu activity
> which can favour towards interactive tasks but also favour towards cpu bound
> tasks which happen to wait on other activity (such as I/O) and is a net
> gain.

I'm not sure this is going in the right direction... I'm writing
this while compiling a kernel w/ "nice -20 make -j2" and X is almost
unusable -- even the x pointer jumps instead of moving smoothly like
it always did; I had to stop the build to be able to quickly finish
this as the latency is making it hard to properly position the cursor...
Hmm, this is weird; I've tried various nice values for the build and
19 is the only one triggering this, w/ 18 and less the cursor moves
smoothly, but there are short sub-second stalls. nice=0 isn't much
different.
RSDL 0.31 was behaving properly, and only exhibited problems when
the box was overloaded w/ non-niced tasks; Right now even a properly
niced background job kills interactivity completely.

artur
