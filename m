Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbZCCAjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbZCCAjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZCCAjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:39:33 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:63795 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbZCCAjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:39:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhwFAA4KrElMQW1W/2dsb2JhbACBWdNEhAYG
Date: Mon, 2 Mar 2009 19:39:28 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] Text Edit Lock - Architecture Independent Code
Message-ID: <20090303003928.GA6106@Krystal>
References: <49AC10E9.1090102@redhat.com> <20090302171914.GB21735@Krystal> <49AC5A87.7000604@redhat.com> <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu> <49AC6DEA.2050304@redhat.com> <20090302234910.GA17956@elte.hu> <20090303000054.GC3906@Krystal> <20090303003237.GA30221@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090303003237.GA30221@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:37:53 up 2 days, 21:04,  3 users,  load average: 0.49, 0.65,
	0.67
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > +/*
> > + * Take and release the kernel text modification lock, used for code patching.
> > + * Users of this lock can sleep.
> > + */
> > +extern void kernel_text_lock(void);
> > +extern void kernel_text_unlock(void);
> 
> Locking APIs with hidden semantics are very ugly. Remember 
> lock_kernel()?
> 
> > +/*
> > + * mutex protecting text section modification (dynamic code patching).
> > + * some users need to sleep (allocating memory...) while they hold this lock.
> > + */
> > +static DEFINE_MUTEX(text_mutex);
> 
> Please update those sites to do an explicit:
> 
> 	mutex_lock(&text_mutex);
> 
> instead.
> 
> That way we save a function call, and we'll also see exactly 
> what type of lock is being taken, etc.
> 

OK. However we'll have to export the text_mutex symbol and use it in
various locations. As long as we are fine with that, I'll provide an
updated patch.

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
