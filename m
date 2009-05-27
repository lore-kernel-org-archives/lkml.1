Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbZE0DGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbZE0DGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbZE0DGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:06:35 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62133 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342AbZE0DGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:06:34 -0400
Message-Id: <200905270306.n4R36OD8055752@www262.sakura.ne.jp>
Subject: Re: [2.6.30-rcX] Some ftrace debug option is consuming memory?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 27 May 2009 12:06:24 +0900
References: <200905250533.n4P5XGx6042820@www262.sakura.ne.jp> <alpine.DEB.2.00.0905262222060.27902@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905262222060.27902@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 26052009 #2038151, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Steven Rostedt wrote:
> I should have noticed this before. I bet if you disable the branch tracers 
> you will boot again. The branch tracers makes a table of _all_ branches in 
> the kernel. But the change we did between 29 and 30 is that we also make 
> it per cpu. On big boxes the cache line hits were so bad that the 
> interrupts would take so long that they would live lock the machine.
> 
> You configured 2 CPUS so you doubled the size of that table.
> 
> To test if this is your issue you can try changing NR_CPUS to 1, or just 
> disabled the BRANCH_PROFILERs.

I disabled CONFIG_TRACE_BRANCH_PROFILING and it boots now.

  # diff config-2.6.30-rc7-ng .config
  4c4
  < # Mon May 25 13:28:39 2009
  ---
  > # Wed May 27 11:52:49 2009
  1546,1549c1546
  < CONFIG_TRACE_BRANCH_PROFILING=y
  < CONFIG_PROFILE_ALL_BRANCHES=y
  < CONFIG_TRACING_BRANCHES=y
  < CONFIG_BRANCH_TRACER=y
  ---
  > # CONFIG_TRACE_BRANCH_PROFILING is not set

Thank you.
