Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZFVMB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZFVMB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZFVMBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:01:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36441 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbZFVMBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:01:49 -0400
Date: Mon, 22 Jun 2009 14:01:33 +0200
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
Subject: Re: IV.5 - Intel Last Branch Record (LBR)
Message-ID: <20090622120133.GT24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 5/ Intel Last Branch Record (LBR)
>
> Intel processors since Netburst have a cyclic buffer hosted in
> registers which can record taken branches. Each taken branch is
> stored into a pair of LBR registers (source, destination). Up
> until Nehalem, there was not filtering capabilities for LBR. LBR
> is not an architected PMU feature.
>
> There is no counter associated with LBR. Nehalem has a LBR_SELECT
> MSR. However there are some constraints on it given it is shared
> by threads.
>
> LBR is only useful when sampling and therefore must be combined
> with a counter. LBR must also be configured to freeze on PMU
> interrupt.
>
> How is LBR going to be supported?

If there's interest then one sane way to support it would be to
expose it as a new sampling format (PERF_SAMPLE_*).

Regarding the constraints - if we choose to expose the branch-type
filtering capabilities of Nehalem, then that puts a constraint on
counter scheduling: two counters with conflicting constraints should
not be scheduled at once, but should be time-shared via the usual
mechanism.

The typical use-case would be to have no or compatible LBR filter
attributes between counters though - so having the conflicts is not
an issue as long as it works according to the usual model.
