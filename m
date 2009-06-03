Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbZFCOXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbZFCOXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZFCOXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:23:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60058 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbZFCOXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:23:07 -0400
Date: Wed, 3 Jun 2009 10:23:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: walimis <walimisdev@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] tracing/events: fix output format of kernel stack
In-Reply-To: <1244016090-7814-2-git-send-email-walimisdev@gmail.com>
Message-ID: <alpine.DEB.2.00.0906031022540.14994@gandalf.stny.rr.com>
References: <1244016090-7814-1-git-send-email-walimisdev@gmail.com> <1244016090-7814-2-git-send-email-walimisdev@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, walimis wrote:

> According to "events/ftrace/kernel_stack/format", output format of
> kernel stack should use "=>" instead of "<=".
> 
> The second problem is that we shouldn't skip the first entry in the stack,
> although it seems to be duplicated when used in the "function" tracer,
> but events also use it. If we skip the first one, we will drop the topmost
> entry of the stack.
> 
> The last problem is that if the last entry is ULONG_MAX(0xffffffff), we should
> drop it, otherwise it will print a NULL name line.
> 
> before fix:
> 
>       sh-1072  [000]   26.957239: sched_process_fork: parent sh:1072 child sh:1073
>       sh-1072  [000]   26.957262:
>  <= syscall_call
>  <=
>       sh-1072  [000]   26.957744: sched_switch: task sh:1072 [120] (R) ==> sh:1073 [120]
>       sh-1072  [000]   26.957752:
>  <= preempt_schedule
>  <= wake_up_new_task
>  <= do_fork
>  <= sys_clone
>  <= syscall_call
>  <=
> 
> After fix:
> 
>       sh-1075  [000]    39.791848: sched_process_fork: parent sh:1075  child sh:1076
>       sh-1075  [000]    39.791871:
>  => sys_clone
>  => syscall_call
>       sh-1075  [000]    39.792713: sched_switch: task sh:1075 [120] (R) ==> sh:1076 [120]
>       sh-1075  [000]    39.792722:
>  => schedule
>  => preempt_schedule
>  => wake_up_new_task
>  => do_fork
>  => sys_clone
>  => syscall_call
> 
> Signed-off-by: walimis <walimisdev@gmail.com>

I'll queue this up. Thanks!

-- Steve

