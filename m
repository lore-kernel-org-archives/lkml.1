Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbYAHDdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbYAHDdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 22:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYAHDdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 22:33:32 -0500
Received: from ns1.suse.de ([195.135.220.2]:53021 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbYAHDdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 22:33:31 -0500
Date: Tue, 8 Jan 2008 04:33:30 +0100
From: Andi Kleen <ak@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       "Brown, Len" <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] kick sleeping idle CPUS on cpu_idle_wait
Message-ID: <20080108033329.GI2998@bingen.suse.de>
References: <1199759244.26343.35.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199759244.26343.35.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 09:27:24PM -0500, Steven Rostedt wrote:
> 
> Sometimes cpu_idle_wait gets stuck because it might miss CPUS that are
> already in idle, have no tasks waiting to run and have no interrupts
> going to them.  This is common on bootup when switching cpu idle
> governors.

I must admit I never liked that cpu idle wait code anyways. Why again
can't normal RCU be used for this? Waiting for two RCU quiescent cycles should
be enough, shouldn't it?

-Andi
