Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZHYSPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZHYSPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbZHYSPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:15:09 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:49905 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755648AbZHYSPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:15:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFADPEk0pMROOX/2dsb2JhbACBU9dShBoF
Date: Tue, 25 Aug 2009 14:15:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090825181508.GB2448@Krystal>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090825162004.GA25058@Krystal> <20090825170441.GD2656@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090825170441.GD2656@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:13:53 up 7 days,  5:03,  3 users,  load average: 0.18, 0.25,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Tue, Aug 25, 2009 at 12:20:04PM -0400, Mathieu Desnoyers wrote:
> > 
> > Uh ? kernel threads can invoke a system call. There are rare places
> > where kernel code actually invoke system calls. I don't see why we
> > should not deal with them.
> > 
> > Moreover, the problem you face is more general: if we set the
> > TIF_SYSCALL_FTRACE flag of a standard thread right in the middle of its
> > system call, x86_64 will cause the syscall exit to execute by re-reading
> > the thread flags and run a syscall trace exit.
> > 
> > We could simply initialize the "saved system calls id" number to
> > something like -1, so that if we happen to return from a syscall that
> > did not get its id recorded at syscall entry, we know it because it's
> > not initialized.
> > 
> > We would need to carefully put back the -1 value after clearing the
> > thread flag when we stop tracing too (while still holding a mutex).
> > 
> > Mathieu
> > 
> 
> why can't we have a syscall exit that is unmatched? we calculate
> the exit syscall number for the the pt_regs structure at exit, so we
> don't need to match it up with an entry to know which syscall it is.
> 

Are we certain that it will still be on the pt_regs at system call
exit and not overwritten by the syscall return value ? For every arch ?

Mathieu

> thanks,
> 
> -Jason

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
