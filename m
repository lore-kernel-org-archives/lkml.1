Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbYBJJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbYBJJ6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYBJJ6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:58:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbYBJJ6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:58:08 -0500
Date: Sun, 10 Feb 2008 17:53:53 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [12/19] ftrace: function tracer
Message-ID: <20080210095353.GA8451@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20080210072046.GM4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210072046.GM4100@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<quote sender="Ingo Molnar">
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This is a simple trace that uses the ftrace infrastructure. It is
> designed to be fast and small, and easy to use. It is useful to
> record things that happen over a very short period of time, and
> not to analyze the system in general.
> 
>  Updates:
> 
>   available_tracers
>      "function" is added to this file.

$ cat available_tracers 
wakeup irqsoff ftrace sched_switch none
               ^^^^^^

I believe "function" refers to "ftrace"?

[...]
>  echo "symonly" > /debugfs/tracing/iter_ctrl
> 
> tracer:
> [   81.479913] CPU 0: bash:3154 register_ftrace_function+0x5f/0x66 <-- _spin_unlock_irqrestore+0xe/0x5a
> [   81.479913] CPU 0: bash:3154 _spin_unlock_irqrestore+0x3e/0x5a <-- sub_preempt_count+0xc/0x7a
> [   81.479913] CPU 0: bash:3154 sub_preempt_count+0x30/0x7a <-- in_lock_functions+0x9/0x24
> [   81.479914] CPU 0: bash:3154 vfs_write+0x11d/0x155 <-- dnotify_parent+0x12/0x78
> [   81.479914] CPU 0: bash:3154 dnotify_parent+0x2d/0x78 <-- _spin_lock+0xe/0x70
> [   81.479914] CPU 0: bash:3154 _spin_lock+0x1b/0x70 <-- add_preempt_count+0xe/0x77
> [   81.479914] CPU 0: bash:3154 add_preempt_count+0x3e/0x77 <-- in_lock_functions+0x9/0x24

I can't seem to echo "symonly" to iter_ctrl.

kerndev: /sys/kernel/debug/tracing$ cat current_tracer 
ftrace
kerndev: /sys/kernel/debug/tracing$ cat tracing_enabled 
1
kerndev: /sys/kernel/debug/tracing$ cat iter_ctrl 
noprint-parent nosym-offset nosym-addr noverbose 
kerndev: /sys/kernel/debug/tracing$ echo symonly > iter_ctrl 
kerndev: /sys/kernel/debug/tracing$ cat iter_ctrl 
noprint-parent nosym-offset nosym-addr noverbose 

How did you get the above output?

Thanks,
Eugene
