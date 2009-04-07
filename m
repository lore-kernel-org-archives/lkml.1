Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbZDGGfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbZDGGfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZDGGe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:34:59 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:45723 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbZDGGe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:34:58 -0400
Date: Tue, 7 Apr 2009 12:04:41 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [Patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090407063441.GA17461@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
	I am sending you the patches with the changes mentioned in the 
Changelog below. Please read the patches in conjunction with my replies
sent to your previous comments.

Let me know your thoughts on this.

Changelog
-----------
- Introduce (un)register_user_hw_breakpoint() which would take two parameters -
  pointer to 'struct task_struct' and 'struct hw_breakpoint'.
- Change the return value behaviour in ptrace(). Return '0' for write in DR0 -
  DR3 (with the exception being when the registered address is not in
  user-space), while restricting error returns for write in DR7. Move memory
  (de)allocation behaviour for 'struct hw_breakpoint' to ptrace related code and
  flush_thread_hw_breakpoint() from unregister_user_hw_breakpoint() code.
- Addition of arch_flush_thread_hw_breakpoint() to zero-out thread->debugreg[n]
  registers.
- Consolidate arch-specific kernel/thread update routines into
  arch_update_kernel_hw_breakpoints() and arch_update_user_hw_breakpoint()
  routines.
- Re-arrange the patchset to enable compilation after application of every
  patch in the patchset.
- hw_breakpoint_handler() modified to:
  - Unconditionally invoke (*trigger) function call
  - Return NOTIFY_DONE only when other bits in DR6 are set or when
    breakpoint originates due to an address in user-space
  - Do an early return if trap bits are not set and we have entered the handler
    because of BT, BS or BD bits in dr6 being set.
- samples/hw_breakpoint/data_breakpoint.c modified to accept module
  parameters

The patchset is based on commit f0e36dc28173b65df2216dfae7109645d97a1bd9 of -tip
tree.

Thanks,
K.Prasad


