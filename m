Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbZHXWW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbZHXWW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbZHXWW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:22:28 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:44672 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbZHXWW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:22:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19091.1974.528045.724091@cargo.ozlabs.ibm.com>
Date: Tue, 25 Aug 2009 07:35:50 +1000
From: Paul Mackerras <paulus@samba.org>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perf_counters issue with enable_on_exec
In-Reply-To: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
References: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian writes:

> I am running into an issue trying to use enable_on_exec
> in per-thread mode with an event group.
> 
> My understanding is that enable_on_exec allows activation
> of an event on first exec. This is useful for tools monitoring
> other tasks and which you invoke as: tool my_program. In
> other words, the tool forks+execs my_program. This option
> allows developers to setup the events after the fork (to get
> the pid) but before the exec(). Only execution after the exec
> is monitored. This alleviates the need to use the
> ptrace(PTRACE_TRACEME) call.
> 
> My understanding is that an event group is scheduled only
> if all events in the group are active (disabled=0). Thus, one

Not quite - if the leader is disabled then none of the group goes on.
If the leader is enabled then it and any other group members that are
enabled go on.  If a non-leader member is disabled then it doesn't go
on but it doesn't stop other members from going on.

Paul.
