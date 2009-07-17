Return-Path: <linux-kernel-owner+w=401wt.eu-S934760AbZGQQ51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760AbZGQQ51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 12:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934748AbZGQQ50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 12:57:26 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:53661 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934734AbZGQQ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 12:57:26 -0400
Subject: Re: [RFC PATCH] kmemleak: Scan all thread stacks
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090717164346.GC5131@elte.hu>
References: <20090717093359.8288.45464.stgit@pc1117.cambridge.arm.com>
	 <20090717164346.GC5131@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 17 Jul 2009 17:57:06 +0100
Message-Id: <1247849826.6313.64.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jul 2009 16:57:07.0475 (UTC) FILETIME=[9E3DAE30:01CA06FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 18:43 +0200, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > 2. Is it safe to use rcu_read_lock() and task_lock() when scanning the
> >    corresponding kernel stack (thread_info structure)? The loop doesn't
> >    do any modification to the task list. The reason for this is to
> >    allow kernel preemption when scanning the stacks.
> 
> you cannot generally preempt while holding the RCU read-lock.

This may work with rcupreempt enabled. But, with classic RCU is it safe
to call schedule (or cond_resched) while holding the RCU read-lock?

Thanks.

-- 
Catalin

