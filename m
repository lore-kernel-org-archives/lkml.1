Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbZKXJoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbZKXJoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbZKXJoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:44:22 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42829 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbZKXJoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:44:21 -0500
Date: Tue, 24 Nov 2009 15:14:21 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [GIT PULL v6] hw-breakpoints: Rewrite on top of perf events v6
Message-ID: <20091124094421.GA3468@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 04:28:54PM +0100, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the tracing/hw-breakpoints branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/hw-breakpoints
>

Hi Frederic, Ingo,
		Here are a few concerns (roughly in decreasing order of
priority) about the perf-events integrated hw-breakpoint feature.

- Freeze the breakpoint interfaces: Owing to the many current/potential
users of hw-breakpoint feature it is important to provide a stable
interface to the end-user. Changes underneath the interface can be done
in due course in a manner that does not affect the end-user's behaviour
or function signature. The present breakpoint interface requires
parameters that are best embedded in a structure for extensibility.

- Proposed migration of register allocation logic to arch-specific files
from kernel/hw_breakpoint.c. This is best done early to help easy
porting of code to other architectures (we have an active interest in
bringing support for PPC64 and S390). If done later, it will entail
additional effort in porting for each architecture.

- Fix ptrace bugs that potentially alter the semantics of ptrace.

- Bring either true system_wide support or atleast workaround the
side-effects of iterative per-cpu registration using single atomic
enablement of all per-cpu breakpoints. This can avoid stray exceptions
which would get delivered to the end-user even for failed breakpoint
requests.

Thanks,
K.Prasad
 
