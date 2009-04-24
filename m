Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZDXDNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZDXDNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 23:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZDXDND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 23:13:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50903 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbZDXDNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 23:13:01 -0400
Message-ID: <49F12DEA.6070404@redhat.com>
Date: Thu, 23 Apr 2009 23:11:38 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tim Abbott <tabbott@MIT.EDU>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Anders Kaseorg <andersk@MIT.EDU>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jeffrey B Arnold <jbarnold@MIT.EDU>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au> <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu> <20090422091645.GB18226@elte.hu> <alpine.DEB.1.10.0904221250280.24280@vinegar-pot.mit.edu> <49EFA0DE.9070407@redhat.com> <alpine.DEB.2.00.0904221901190.7725@vinegar-pot.mit.edu> <20090423195754.GA24963@Krystal> <alpine.DEB.1.10.0904231612180.28329@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0904231612180.28329@vinegar-pot.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott wrote:
> The reason that we want to export text_mutex is that it can be useful for 
> the Ksplice core (still kernel/ksplice.c) to be built as a module.  This 
> is desirable when a different version of the kernel/ksplice.c code is 
> needed in order to apply a particular update (e.g. because there was a bug 
> in Ksplice).

Ah, OK. Certainly, Ksplice can't patch itself. It might be a good reason for
exporting text_mutex.


> I agree that great care should be taken when writing code that patches the 
> kernel's text.  However, I don't think failing to export text_mutex to GPL 
> modules helps ensure that.  In particular, not exporting text_mutex 
> doesn't prevent modules from patching the kernel text.  It just prevents 
> any modules that do so from grabbing the appropriate lock.

What I'm concerned about exporting locking staffs is that may cause
a dead lock. However, we've already exported module_mutex.
I don't think that exporting text_mutex is more considerable than that. :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

