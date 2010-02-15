Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0BOIbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 03:31:44 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49068 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab0BOIbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 03:31:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 7/7 -mm] oom: remove unnecessary code and cleanup
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1002111619370.13384@chino.kir.corp.google.com>
References: <20100212091237.adb94384.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002111619370.13384@chino.kir.corp.google.com>
Message-Id: <20100215173046.72A4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Feb 2010 17:31:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 12 Feb 2010, KAMEZAWA Hiroyuki wrote:
> 
> > > Remove the redundancy in __oom_kill_task() since:
> > > 
> > >  - init can never be passed to this function: it will never be PF_EXITING
> > >    or selectable from select_bad_process(), and
> > > 
> > >  - it will never be passed a task from oom_kill_task() without an ->mm
> > >    and we're unconcerned about detachment from exiting tasks, there's no
> > >    reason to protect them against SIGKILL or access to memory reserves.
> > > 
> > > Also moves the kernel log message to a higher level since the verbosity
> > > is not always emitted here; we need not print an error message if an
> > > exiting task is given a longer timeslice.
> > > 
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> > 
> > If you say "never", it's better to add BUG_ON() rather than 
> > if (!p->mm)...
> > 
> 
> As the description says, oom_kill_task() never passes __oom_kill_task() a 
> task, p, where !p->mm, but it doesn't imply that p cannot detach its ->mm 
> before __oom_kill_task() gets a chance to run.  The point is that we don't 
> really care about giving it access to memory reserves anymore since it's 
> exiting and won't be allocating anything.  Warning about that scenario is 
> unnecessary and would simply spam the kernel log, a recall to the oom 
> killer would no longer select this task in case the oom condition persists 
> anyway.

I agree this description is correct and this code is unnecessary.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> 
> > But yes, this patch seesm to remove unnecessary codes.
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> 
> Thanks!
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



