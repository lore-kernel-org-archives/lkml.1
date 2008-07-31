Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbYGaA5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbYGaA5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbYGaA5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:57:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbYGaA5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:57:35 -0400
Date: Wed, 30 Jul 2008 17:56:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: dump out ftrace buffers to console on panic
Message-Id: <20080730175640.f04f81b5.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0807302020590.19138@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0807301700080.16138@gandalf.stny.rr.com>
	<20080730143028.a8e94161.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0807302020590.19138@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 20:39:47 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> >
> >> +	__raw_spin_lock(&ftrace_dump_lock);
> >> +	dump_running = 0;
> >> +	__raw_spin_unlock(&ftrace_dump_lock);
> >> +
> >> + out:
> >> +	local_irq_restore(flags);
> >> +}
> >> +#endif /* CONFIG_FTRACE_DUMP_ON_OOPS */
> >
> > Do we really need a new config option for this?  Would it hurt too much
> > to make it unconditionally available?
> 
> I don't mind making it unconditionally available. I only added the config 
> option because I thought people would like to turn it off.
> 
> I'll resubmit with the above concerns fixed and without the config option.

Well..  my question about the config option was no more than a question
- I don't know the answer.

Although thinking about it, I guess that anyone who is really squeezy
on space just won't be enabling ftrace at all.  Is there any reason
other than size for disabling this new feature?


