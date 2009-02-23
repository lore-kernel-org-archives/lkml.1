Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbZBWSq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbZBWSq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZBWSqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:46:46 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34438 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbZBWSqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:46:45 -0500
Date: Tue, 24 Feb 2009 00:16:16 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm, kprobes: fault.c, simplify
	notify_page_fault()
Message-ID: <20090223184616.GA10588@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <tip-b18018126f422f5b706fd750373425e10e84b486@kernel.org> <499F383B.6060700@redhat.com> <20090222093109.GE6964@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222093109.GE6964@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 10:31:09AM +0100, Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > Ingo Molnar wrote:
> > > Author:     Ingo Molnar <mingo@elte.hu>
> > > AuthorDate: Fri, 20 Feb 2009 22:42:57 +0100
> > > Commit:     Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Sat, 21 Feb 2009 00:09:42 +0100
> > > 
> > > x86, mm, kprobes: fault.c, simplify notify_page_fault()
> > > 
> > > Impact: cleanup
> > > 
> > > Remove an #ifdef from notify_page_fault(). The function still
> > > compiles to nothing in the !CONFIG_KPROBES case.
> > > 
> > > Introduce kprobes_built_in() and kprobe_fault_handler() helpers
> > > to allow this - they returns 0 if !CONFIG_KPROBES.
> > > 
> > > No code changed:
> > > 
> > >    text	   data	    bss	    dec	    hex	filename
> > >    4618	     32	     24	   4674	   1242	fault.o.before
> > >    4618	     32	     24	   4674	   1242	fault.o.after
> > 
> > It seems good for me. Thank you for cleanup!
> > 
> > Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
> 
> another very small thing, while we are discussing kprobes:
> 
> I always found that the __kprobes annotation is very confusingly 
> euphemistic: what those annotations really mean is not 
> 'kprobes', but 'no kprobes'.

Right!

> So how about renaming __kprobes to __nokprobes, similar to how 
> we have the notrace attribute?
> 
> We have about 350 __kprobes annotations in the kernel, so 
> renaming it now would not be practical - but any objections 
> against me sending Linus a rename patch somewhere late in the 
> next merge window that just does this rename?

No issues with that.

Ananth
