Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbZCYNmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbZCYNmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZCYNmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:42:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbZCYNmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:42:08 -0400
Date: Wed, 25 Mar 2009 09:42:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] ptrace: remove incorrect unlikelys
In-Reply-To: <20090325072129.GB25833@elte.hu>
Message-ID: <alpine.DEB.2.00.0903250941080.5675@gandalf.stny.rr.com>
References: <20090325051920.406564281@goodmis.org> <20090325052022.747507467@goodmis.org> <20090325072129.GB25833@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Ingo Molnar wrote:
> > diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> > index 06ca07f..74a16db 100644
> > --- a/arch/x86/kernel/ptrace.c
> > +++ b/arch/x86/kernel/ptrace.c
> > @@ -1421,7 +1421,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
> >  	    tracehook_report_syscall_entry(regs))
> >  		ret = -1L;
> >  
> > -	if (unlikely(current->audit_context)) {
> > +	if (current->audit_context) {
> 
> i suspect you got this result because you are running Fedora with 
> auditd enabled and running, right? Does SuSE and Ubuntu run with 
> auditing enabled as well? If yes then removing this annotation would 
> be right - otherwise the auditing-enabled case is considered the 
> less likely variant. (despite it being 100% wrong for your 
> particular configuration)

I'm running an old RHEL 5.1 box. I guess we can look at what the other 
distros run.

-- Steve

