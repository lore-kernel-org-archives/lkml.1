Return-Path: <linux-kernel-owner+w=401wt.eu-S2992880AbXCICWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992880AbXCICWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 21:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965360AbXCICWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 21:22:11 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:63660 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965267AbXCICWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 21:22:09 -0500
Date: Thu, 8 Mar 2007 21:22:08 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, rschultz@google.com, ak@suse.de,
       mbligh@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix atomicity of TIF update in flush_thread() for x86_64
Message-ID: <20070309022208.GB8387@Krystal>
References: <20070309021553.GA8387@Krystal> <20070308.181818.116353410.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070308.181818.116353410.davem@davemloft.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 21:20:27 up 34 days, 16:28,  5 users,  load average: 1.17, 1.14, 1.33
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date: Thu, 8 Mar 2007 21:15:53 -0500
> 
> > Fix atomicity of TIF update in flush_thread() for x86_64
> > 
> > Race :
> > 
> > parent process executing :
> > sys_ptrace()
> >  (lock_kernel())
> >  (ptrace_get_task_struct(pid))
> >  arch_ptrace()
> >    ptrace_detach()
> >      ptrace_disable(child);
> >        clear_singlestep(child);
> >          clear_tsk_thread_flag(child, TIF_SINGLESTEP);
> >          (which clears the TIF_SINGLESTEP flag atomically from a different
> > 	  process)
> >  (put_task_struct(child))
> >  (unlock_kernel())
> > 
> > And at the same time, in the child process :
> > sys_execve()
> >  do_execve()
> >    search_binary_handler()
> >      load_elf_binary()
> >        flush_old_exec()
> >          flush_thread()
> >            doing a non-atomic thread flag update 
> > 
> > It applies on 2.6.20.
> > 
> > Signed-off-by: Rebecca Schultz <rschultz@google.com>
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> Please fix all platforms, not just your favorite one, kthx.
> :-)

Please be comprehensive of the speed at which fingers can type on my
keyboard. Your quickness at replying to email is impressive though ;)

I am working on it, it won't take long.

Regards,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
