Return-Path: <linux-kernel-owner+w=401wt.eu-S933101AbZJIHDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbZJIHDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZJIHDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:03:19 -0400
Received: from www.tglx.de ([62.245.132.106]:56672 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbZJIHDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:03:18 -0400
Date: Fri, 9 Oct 2009 09:02:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: wu Jianfeng <stormplayer@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: the select system call's implementation may have some bug in
 preempt kernel mode
In-Reply-To: <a5b3ea7b0910082250o659d4fd3l8f319fd6bde24f3d@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0910090849400.9428@localhost.localdomain>
References: <a5b3ea7b0910082242s6ce8275dr7f962ce526e55cd2@mail.gmail.com> <a5b3ea7b0910082250o659d4fd3l8f319fd6bde24f3d@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, wu Jianfeng wrote:
> A process may sleep for ever when he call select system call.
> In detail, if the process was scheduled out just at the point it set
> its state to TASK_INTERRUPTIBLE.
> 
> The events that may cause the process to be scheduled out is(in
> preempt kernel) :
> 1) time interrupt and the process's time slice is exhausted.
> 2) an interrupt accured, and wake up another process with high priority.

Right, but that does not cause the task to be scheduled out for ever.

> 		set_current_state(TASK_INTERRUPTIBLE);   ######## here set the
> interrupt to  TASK_INTERRUPTIBLE state
> 
>                ########### if the process was schedued out here, it
> will can never been waken up .
>                ########### Because the process wasn't attached to any
> file's waitqueue at this point yet

When the task is scheduled out at that point, it is not
deactivated. It is preempted, which means it stays on the run queue
despite of the TASK_INTERRUPTIBLE state and is scheduled back in later
on.

Thanks,

	tglx
