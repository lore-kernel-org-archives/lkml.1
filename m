Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZFEDcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZFEDcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZFEDcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:32:00 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:40778 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbZFEDcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:32:00 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 23:32:00 EDT
Message-ID: <4A288F85.6010809@tlinx.org>
Date: Thu, 04 Jun 2009 20:22:45 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: ionice priority "none: prio 0" v. "none: prio 1" v. best-effort v.
 idle?
X-Stationery: 0.4.8.14
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<-- vim: se sts=4 sw=4 ts=8 nosi sc ai: /--> I was looking at the output 
of ionice on the various processes
running.

Other than one I set for 'best-effort' (-c2), the rest all had
priorities of
    1) "none: prio 0"
OR
    2) "none: prio 4"

Out of 183 process:

  79 had "none: prio 0"   and
103 had "none: prio 4"
(1 had "best effort, prio 4").

Where does priority class  'none' fit in?  above or below 'idle'?

Or is 'none' equal to 'best effort' (which is logical in once sense, but
strictly, I could argue 'none' is at least below 'best effort', and possibly
below idle, as 'idle' at least has been assigned a scheduling priority
(vs. processes that have not -- BUT, but definition, idle is clearly meant
to be lower precedence, so that would argue, logically, that 'none' is
above idle and below 'best_effort' (since processes with no assigned
priority would logically be below those assigned as 'best effort'.

Within 'besteffort', 0=high, and 7=low.

Is the same true in 'none', or are the values 'meaningless'?
(In which case, why do they all exist at either 4 or 0?)

Since the iopriority DOES NOT correlate with either
the cpu priority nor 'nice' value, then how are different
processes assigned different priority values? 

They *seem* to be mostly fixed, but very rarely I'll see maybe
1 process toggle from 0 to 4 or back (but its usually fixed).

So why is everything in the 'none' class at either "highest level" (prio
0), OR the mid level of prio=4?  Um...found exception on a 32-bit i386
based kernel, all prio's are "none: prio 0". But two different x86_64 bit
kernels have "a split", majority in none:prio 4, and a minority of
25-44% in 'none:prio 4'.

I'm using the cfq scheduler on all 3 machines.

So what is it with 'schedclass'=none?  Is it lower than 'best effort'?  
(I'd hope so, or like to see it that way, but wants are nice...:-))...

If they *ARE* the same, why are 44% running at highest priority
(regardless of cpu prio, 'nice' value, user-id, and the rest at 'mid')?

Why so random, but worse, why put any at 'highest' (unless they
ask for it).  Wouldn't 'mid' priority be consistent with 'mid-cpu-nice' 
value of 0 (out of +/-19)?

FWIW -- I thought once the priorities varied dynamically based on
cpu-nice levels (for cfq, anyway)...it would be VERY nice to see that
reflected in the readable ionice data for those processes.

Thanks for clarification/enlightenment...
Linda



