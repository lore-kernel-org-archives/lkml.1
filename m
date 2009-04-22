Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZDVWWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZDVWWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbZDVWV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:21:57 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53145 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553AbZDVWV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:21:56 -0400
Date: Wed, 22 Apr 2009 18:20:39 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Jeffrey B Arnold <jbarnold@MIT.EDU>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
In-Reply-To: <20090422091645.GB18226@elte.hu>
Message-ID: <alpine.DEB.1.10.0904221250280.24280@vinegar-pot.mit.edu>
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au> <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu> <20090422091645.GB18226@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009, Ingo Molnar wrote:

> I suspect ksplice could make use of text_mutex?

Yes, this is what I was imagining.  Thanks for pointing this out!  I plan 
to make Ksplice use this for the next version of the Ksplice patch series.

However, since Ksplice can be built as a module, we'll want to 
EXPORT_SYMBOL_GPL(text_mutex).  The comment above text_mutex's definition 
suggests some people would prefer not to have modules patching the kernel 
text, and so this point might be contentious.  I've found support for 
building Ksplice as a module to be a useful feature in case one needs to 
use multiple different versions of Ksplice on the same system (e.g. 
because the version built in to the kernel doesn't support a particular 
patch).

        -Tim Abbott

