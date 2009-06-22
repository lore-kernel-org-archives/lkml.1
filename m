Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbZFVMAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbZFVMAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZFVMAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:00:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43266 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZFVMAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:00:06 -0400
Date: Mon, 22 Jun 2009 13:59:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: IV.2 - Features impacting all counters
Message-ID: <20090622115928.GQ24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2/ Features impacting all counters
>
> On some PMU models, e.g., Itanium, they are certain features which
> have an influence on all counters that are active. For instance,
> there is a way to restrict monitoring to a range of continuous
> code or data addresses using both some PMU registers and the debug
> registers.
>
> Given that the API exposes events (counters) as independent of
> each other, I wonder how range restriction could be implemented.

A solution is to make it a per-counter attribute and fail to 
schedule multiple counters at the same time when these constraints 
differ.

> Similarly, on Itanium, there are global behaviors. For instance,
> on counter overflow the entire PMU freezes all at once. That seems
> to be contradictory with the design of the API which creates the
> illusion of independence.
>
> What solutions do you propose?

We propose the same solution as last time: live with the small
imprecisions caused by such hardware limitations. We submit that
natural workload noise is probably far bigger than any such effect.
We could certainly list it as a platform limitation.
