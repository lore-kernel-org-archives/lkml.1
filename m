Return-Path: <linux-kernel-owner+w=401wt.eu-S934756AbZGQRB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756AbZGQRB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 13:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934743AbZGQRB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 13:01:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36533 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933676AbZGQRB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 13:01:27 -0400
Subject: Re: [RFC PATCH] kmemleak: Scan all thread stacks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Paul E. McKenney" <paulmck@us.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1247849826.6313.64.camel@pc1117.cambridge.arm.com>
References: <20090717093359.8288.45464.stgit@pc1117.cambridge.arm.com>
	 <20090717164346.GC5131@elte.hu>
	 <1247849826.6313.64.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 19:01:09 +0200
Message-Id: <1247850069.6522.91.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 17:57 +0100, Catalin Marinas wrote:
> On Fri, 2009-07-17 at 18:43 +0200, Ingo Molnar wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > 2. Is it safe to use rcu_read_lock() and task_lock() when scanning the
> > >    corresponding kernel stack (thread_info structure)? The loop doesn't
> > >    do any modification to the task list. The reason for this is to
> > >    allow kernel preemption when scanning the stacks.
> > 
> > you cannot generally preempt while holding the RCU read-lock.
> 
> This may work with rcupreempt enabled. But, with classic RCU is it safe
> to call schedule (or cond_resched) while holding the RCU read-lock?

No.

