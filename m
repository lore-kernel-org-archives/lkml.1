Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZBVJbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZBVJbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 04:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZBVJb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 04:31:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35759 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZBVJb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 04:31:28 -0500
Date: Sun, 22 Feb 2009 10:31:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: hpa@zytor.com, mingo@redhat.com, torvalds@linux-foundation.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm, kprobes: fault.c, simplify
	notify_page_fault()
Message-ID: <20090222093109.GE6964@elte.hu>
References: <tip-b18018126f422f5b706fd750373425e10e84b486@kernel.org> <499F383B.6060700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499F383B.6060700@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Ingo Molnar wrote:
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Fri, 20 Feb 2009 22:42:57 +0100
> > Commit:     Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 21 Feb 2009 00:09:42 +0100
> > 
> > x86, mm, kprobes: fault.c, simplify notify_page_fault()
> > 
> > Impact: cleanup
> > 
> > Remove an #ifdef from notify_page_fault(). The function still
> > compiles to nothing in the !CONFIG_KPROBES case.
> > 
> > Introduce kprobes_built_in() and kprobe_fault_handler() helpers
> > to allow this - they returns 0 if !CONFIG_KPROBES.
> > 
> > No code changed:
> > 
> >    text	   data	    bss	    dec	    hex	filename
> >    4618	     32	     24	   4674	   1242	fault.o.before
> >    4618	     32	     24	   4674	   1242	fault.o.after
> 
> It seems good for me. Thank you for cleanup!
> 
> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

another very small thing, while we are discussing kprobes:

I always found that the __kprobes annotation is very confusingly 
euphemistic: what those annotations really mean is not 
'kprobes', but 'no kprobes'.

So how about renaming __kprobes to __nokprobes, similar to how 
we have the notrace attribute?

We have about 350 __kprobes annotations in the kernel, so 
renaming it now would not be practical - but any objections 
against me sending Linus a rename patch somewhere late in the 
next merge window that just does this rename?

[ likewise, i'll rename notrace to __notrace to make it visually 
  less intrusive to the return value type. There's a lot less 
  such annotations in the kernel. ]

	Ingo
