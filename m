Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZDVW6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZDVW6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZDVW62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:58:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44267 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZDVW61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:58:27 -0400
Message-ID: <49EFA0DE.9070407@redhat.com>
Date: Wed, 22 Apr 2009 18:57:34 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tim Abbott <tabbott@MIT.EDU>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Jeffrey B Arnold <jbarnold@MIT.EDU>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au> <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu> <20090422091645.GB18226@elte.hu> <alpine.DEB.1.10.0904221250280.24280@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0904221250280.24280@vinegar-pot.mit.edu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott wrote:
> On Wed, 22 Apr 2009, Ingo Molnar wrote:
> 
>> I suspect ksplice could make use of text_mutex?
> 
> Yes, this is what I was imagining.  Thanks for pointing this out!  I plan 
> to make Ksplice use this for the next version of the Ksplice patch series.

Could you also add "use text_poke() on x86" to your plan? :-)

> However, since Ksplice can be built as a module, we'll want to 
> EXPORT_SYMBOL_GPL(text_mutex).  The comment above text_mutex's definition 
> suggests some people would prefer not to have modules patching the kernel 
> text, and so this point might be contentious.  I've found support for 
> building Ksplice as a module to be a useful feature in case one needs to 
> use multiple different versions of Ksplice on the same system (e.g. 
> because the version built in to the kernel doesn't support a particular 
> patch).

Hmm, I can't agree that we allow module to modify kernel text...
Is that possible to separate kernel-text swapping routine from Ksplice
module? In that case, we don't need to export text_mutex.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

