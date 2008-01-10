Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbYAJOok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbYAJOok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 09:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYAJOod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 09:44:33 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:64365 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYAJOoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 09:44:32 -0500
Date: Thu, 10 Jan 2008 09:43:46 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
In-Reply-To: <20080110134539.GD5886@elte.hu>
Message-ID: <Pine.LNX.4.58.0801100936320.6420@gandalf.stny.rr.com>
References: <1199759244.26343.35.camel@localhost.localdomain>
 <20080108033329.GI2998@bingen.suse.de> <1199911330.975.3.camel@localhost.localdomain>
 <1199916725.975.6.camel@localhost.localdomain> <20080110134539.GD5886@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jan 2008, Ingo Molnar wrote:
> > FYI, I just hit this hang on 2.6.24-rc6 without any extra patches. So,
> > unless 2.6.24-rc7 did anything to fix this issue, this is a high
> > priority bug (IMHO).
>
> i'm wondering why this only triggered now. Is this something new in
> 2.6.24?

It only triggeres with the switching of the idle governors. And not just
one, you need to switch twice. The first loading of a governor does not
call cpu_idle_wait, but the second one does. NO_HZ must also be enabled,
plus this needs to happen when no events or threads are scheduled to run
on a CPU, which limits this to boot up.

Also, this only seems to happen on my 2x2 (4way) and only once in a while.

I'm surprised that I'm the only one so far to report it. I can boot up the
2.6.23 kernel on this box to see if it also hangs sometimes. But, as I
said, it may take several hundreds of tries to see it.

-- Steve

