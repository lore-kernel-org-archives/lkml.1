Return-Path: <linux-kernel-owner+w=401wt.eu-S1761628AbZCYNcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628AbZCYNcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757653AbZCYNcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:32:04 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:50371 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215AbZCYNcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:32:02 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/5] ptrace: remove incorrect unlikelys
Date: Wed, 25 Mar 2009 14:31:09 +0100
User-Agent: KMail/1.9.9
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>
References: <20090325051920.406564281@goodmis.org> <20090325052022.747507467@goodmis.org> <20090325072129.GB25833@elte.hu>
In-Reply-To: <20090325072129.GB25833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251431.09662.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 25 March 2009 08:21:29 schrieb Ingo Molnar:
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

Auditd can be enabled/disabled via kernel command line, no? In that case
there should be no unlikely and no likely. We should not optimize for a specific
value at compile time if the value can be changed at runtime.

This patch makes a lot of sense to me.



