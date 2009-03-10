Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZCJOYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZCJOYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbZCJOY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:24:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47227 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755560AbZCJOYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:24:25 -0400
Date: Tue, 10 Mar 2009 10:24:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 00/11] Hardware Breakpoint interfaces
In-Reply-To: <20090310135117.GC3850@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0903101019570.2962-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Ingo Molnar wrote:

> 
> There's also a few checkpatch warnings that need to be 
> addressed:
> 
> ERROR: do not use assignment in if condition
> #1084: FILE: arch/x86/kernel/ptrace.c:581:
> +	else if ((thbi = alloc_thread_hw_breakpoint(tsk)) == 
> NULL)

Changing this to remove the assignment from within the "if" condition 
would make the code less readable, not more.  It's part of a long 
series of tests; in schematic form:

	if (n == 4 || n == 5)
...
	else if (n == 6) {
...
	}
	else if (!tsk->thread.hw_breakpoint_info && val == 0)
...
	else if ((thbi = alloc_thread_hw_breakpoint(tsk)) == NULL)
...
	else if (n < HB_NUM) {
...
	}
	else
...

If you can suggest a way to change the code without making it worse,
I'm sure Prasad will be happy to adopt it.

Alan Stern

