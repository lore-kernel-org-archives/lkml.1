Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbYAIWNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbYAIWNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYAIWM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:12:59 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45404 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYAIWM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:12:58 -0500
Subject: Re: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <1199911330.975.3.camel@localhost.localdomain>
References: <1199759244.26343.35.camel@localhost.localdomain>
	 <20080108033329.GI2998@bingen.suse.de>
	 <1199911330.975.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 17:12:05 -0500
Message-Id: <1199916725.975.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 15:42 -0500, Steven Rostedt wrote:
> This patch is different than the first patch I sent out.
> This one just sends an IPI to all CPUS that don't check in after 1 sec.
> 
> 
> Sometimes cpu_idle_wait gets stuck because it might miss CPUS that are
> already in idle, have no tasks waiting to run and have no interrupts
> going to them.  This is common on bootup when switching cpu idle
> governors.
> 
> This patch gives those CPUS that don't check in an IPI kick.

FYI, I just hit this hang on 2.6.24-rc6 without any extra patches. So,
unless 2.6.24-rc7 did anything to fix this issue, this is a high
priority bug (IMHO).

-- Steve


