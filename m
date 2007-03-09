Return-Path: <linux-kernel-owner+w=401wt.eu-S2992893AbXCICSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992893AbXCICSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 21:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992886AbXCICST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 21:18:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58231
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992893AbXCICSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 21:18:18 -0500
Date: Thu, 08 Mar 2007 18:18:18 -0800 (PST)
Message-Id: <20070308.181818.116353410.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: akpm@linux-foundation.org, rschultz@google.com, ak@suse.de,
       mbligh@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix atomicity of TIF update in flush_thread() for
 x86_64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070309021553.GA8387@Krystal>
References: <20070309021553.GA8387@Krystal>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Thu, 8 Mar 2007 21:15:53 -0500

> Fix atomicity of TIF update in flush_thread() for x86_64
> 
> Race :
> 
> parent process executing :
> sys_ptrace()
>  (lock_kernel())
>  (ptrace_get_task_struct(pid))
>  arch_ptrace()
>    ptrace_detach()
>      ptrace_disable(child);
>        clear_singlestep(child);
>          clear_tsk_thread_flag(child, TIF_SINGLESTEP);
>          (which clears the TIF_SINGLESTEP flag atomically from a different
> 	  process)
>  (put_task_struct(child))
>  (unlock_kernel())
> 
> And at the same time, in the child process :
> sys_execve()
>  do_execve()
>    search_binary_handler()
>      load_elf_binary()
>        flush_old_exec()
>          flush_thread()
>            doing a non-atomic thread flag update 
> 
> It applies on 2.6.20.
> 
> Signed-off-by: Rebecca Schultz <rschultz@google.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Please fix all platforms, not just your favorite one, kthx.
:-)
