Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbZIJSYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbZIJSYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZIJSYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:24:10 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:48700 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbZIJSYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OIQW6IPzU1Tjyd/h96hKG1OHIHB7Q5DMNjJ5OIn4uIh5dyE8jxr0SLIKim94gHjQ0R
         zfCzyc/WtYFItZwp+XSw1E01IgZf2Zy7P34ehxtdst5WMYgz+HOs0BMiRxIMM+LTAdIN
         4KJ/d/QWvRS9xgEfEr32XCt5u7rKNyBdWkhXY=
Date: Thu, 10 Sep 2009 20:24:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC GIT PULL] hw-breakpoints: Rewrite on top of perf counters
Message-ID: <20090910182405.GA6421@nowhere>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <19112.53364.51476.9036@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19112.53364.51476.9036@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 08:09:56PM +1000, Paul Mackerras wrote:
> Frederic Weisbecker writes:
> 
> > This is a rewrite of the hardware breakpoints on top of perf counters.
> 
> On powerpc, it doesn't build.  I get:
> 
>   CC      kernel/perf_counter.o
> kernel/perf_counter.c:31:31: error: asm/hw_breakpoint.h: No such file or directory
> kernel/perf_counter.c: In function 'bp_perf_counter_init':
> kernel/perf_counter.c:3964: error: implicit declaration of function 'register_perf_hw_breakpoint'
> kernel/perf_counter.c:3966: error: implicit declaration of function '__register_perf_hw_breakpoint'
> kernel/perf_counter.c:3968: error: 'perf_ops_bp' undeclared (first use in this function)
> kernel/perf_counter.c:3968: error: (Each undeclared identifier is reported only once
> kernel/perf_counter.c:3968: error: for each function it appears in.)
> make[2]: *** [kernel/perf_counter.o] Error 1
> make[1]: *** [kernel] Error 2
> make: *** [sub-make] Error 2
> 
> Seems like every architecture now needs an asm/hw_breakpoint.h.  What
> is the minimum required in that file?  Looks like we would require a
> perf_ops_bp, at least.
> 
> Could you please either arrange things so that architectures that
> don't have hardware breakpoints hooked up to perf_counters don't need
> an asm/hw_breakpoint.h, or add minimal versions of that file for every
> architecture, so as not to break bisection unnecessarily?
> 
> Paul.


I focused so much on the breakpoint <- perf dependency that I've even
forgotten the opposite dependency :)

I'll fix it in the 3rd patch.
We have an <asm-generic/hw-breakpoint.h> so I can just add an
#ifdef HAVE_HW_BREAKPOINT on its top.

Also I'll export the various breakpoints api dependant out of
kernel/perf_counter.c and provide stubs for the off-case.

Thanks.

