Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbZFVLzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbZFVLzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZFVLzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:55:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34048 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZFVLzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:55:19 -0400
Date: Mon, 22 Jun 2009 13:55:03 +0200
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
Subject: Re: I.9 - Group reading
Message-ID: <20090622115503.GJ24366@elte.hu>
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
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 9/ Group reading
>
> It is possible to start/stop an event group simply via ioctl() on
> the group leader. However, it is not possible to read all the
> counts with a single with a single read() system call. That seems
> odd. Furhermore, I believe you want reads to be as atomic as
> possible.

If you want an atomic snapshot you can do it: disable the group,
read out the counts, enable the group.

But, as your other comment under I/5 indicates, there are ways to
read out the PMU directly, via RDPMC instructions. Those are not
atomic either if used for multiple counters. Is your argument that
they are thus useless?

But if there is a strong use-case we can add PERF_FORMAT_GROUP.
