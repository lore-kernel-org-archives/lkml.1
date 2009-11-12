Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbZKLOdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbZKLOdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 09:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZKLOc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 09:32:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:26845 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZKLOc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 09:32:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qZqhQCOhMjPV/92eg/4jXoIi+JtN48Ml+dsmQRBITaGzL/DW9mNUQnvPFcUUaPDwjl
         +aQD18yDb8WyxlSnCt9UBKhT3HBrbggl4i696dSzvDQhIUEc+oCSkrTbLdoOKcqwW1Io
         M+HjeW4PKHM9aEsrqlc3pgd2Blrk0kPtA2yv4=
Date: Thu, 12 Nov 2009 15:33:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [GIT PULL v5] hw-breakpoints: Rewrite on top of perf events v5
Message-ID: <20091112143302.GB5237@nowhere>
References: <1257474542-6648-1-git-send-email-fweisbec@gmail.com> <20091108172953.GA4465@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108172953.GA4465@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 10:59:53PM +0530, K.Prasad wrote:
> On Fri, Nov 06, 2009 at 03:28:55AM +0100, Frederic Weisbecker wrote:
> 
> <snipped>
> 
> >  arch/Kconfig                         |    3 +
> >  arch/x86/include/asm/Kbuild          |    1 +
> >  arch/x86/include/asm/debugreg.h      |   11 +-
> >  arch/x86/include/asm/hw_breakpoint.h |   58 +++--
> >  arch/x86/include/asm/processor.h     |   12 +-
> >  arch/x86/kernel/hw_breakpoint.c      |  391 ++++++++++++++--------
> >  arch/x86/kernel/process.c            |    9 +-
> >  arch/x86/kernel/process_32.c         |   26 +--
> >  arch/x86/kernel/process_64.c         |   26 +--
> >  arch/x86/kernel/ptrace.c             |  182 +++++++----
> >  arch/x86/kernel/smpboot.c            |    3 -
> >  arch/x86/kvm/x86.c                   |   18 +-
> >  arch/x86/power/cpu.c                 |    6 -
> >  include/asm-generic/hw_breakpoint.h  |  139 --------
> >  include/linux/hw_breakpoint.h        |  131 ++++++++
> >  include/linux/perf_event.h           |   37 ++-
> >  kernel/exit.c                        |    5 +
> >  kernel/hw_breakpoint.c               |  602 +++++++++++++++++++++-------------
> >  kernel/perf_event.c                  |  136 ++++++++-
> >  kernel/trace/trace.h                 |    1 -
> >  kernel/trace/trace_entries.h         |    6 +-
> >  kernel/trace/trace_ksym.c            |  126 ++++----
> >  kernel/trace/trace_selftest.c        |    4 +-
> >  23 files changed, 1194 insertions(+), 739 deletions(-)
> 
> Please make changes to samples/hw_breakpoint/data_breakpoint.c
> simultaneously....it breaks the build if CONFIG_SAMPLE_HW_BREAKPOINT is
> selected.
> 
> Thanks,
> K.Prasad
> 


Sorry.
I've fixed the sample side in my latest iteration.

