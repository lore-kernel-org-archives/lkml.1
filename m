Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbYGQLHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbYGQLHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 07:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbYGQLGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 07:06:55 -0400
Received: from styx.suse.cz ([82.119.242.94]:42915 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755892AbYGQLGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 07:06:54 -0400
Subject: Re: [PATCH 01/23] tracehook: add linux/tracehook.h
From: Petr Tesarik <ptesarik@suse.cz>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       hch@infradead.org
In-Reply-To: <20080717084818.GA5637@martell.zuzino.mipt.ru>
References: <20080717072541.F390E15411D@magilla.localdomain>
	 <20080717072755.E2FBC15411D@magilla.localdomain>
	 <20080717084818.GA5637@martell.zuzino.mipt.ru>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Thu, 17 Jul 2008 13:06:52 +0200
Message-Id: <1216292812.28485.6.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 12:48 +0400, Alexey Dobriyan wrote:
> On Thu, Jul 17, 2008 at 12:27:55AM -0700, Roland McGrath wrote:
> > The aim is to formalize and consolidate all the places that the core
> > kernel code and the arch code now ties into the ptrace implementation.
> > 
> > These patches mostly don't cause any functional change.  They just
> > move the details of ptrace logic out of core code into tracehook.h
> > inlines, where they are mostly compiled away to the same as before.
> 
> > All that changes is that everything is thoroughly documented
> 
> This is fine.
> 
> > and any future reworking of ptrace, or addition of something new,
> > would not have to touch core code all over, just change the tracehook.h
> > inlines.
> 
> And this is suprising wish given one can't predict how exactly those
> "future reworking" will look like.
> 
> > The new linux/ptrace.h inlines are used by the following patches in the
> > new tracehook_*() inlines.  Using these helpers for the ptrace event
> > stops makes it simple to change or disable the old ptrace implementation
> > of these stops conditionally later.
> 
> Call them "utrace_*" from the start?

Ah, maybe justified, because I don't expect any other re-implementation
of the same after utrace is finished, but -- there's still the old
ptrace implementation, so _not_ mentioning utrace seems a bit better to
me.

> > --- a/include/linux/ptrace.h
> > +++ b/include/linux/ptrace.h
> > @@ -121,6 +121,39 @@ static inline void ptrace_unlink(struct task_struct *child)
> >  int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data);
> >  int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
> >  
> > +/**
> > + * task_ptrace - return %PT_* flags that apply to a task
> > + * @task:	pointer to &task_struct in question
> > + *
> > + * Returns the %PT_* flags that apply to @task.
> > + */
> > +static inline int task_ptrace(struct task_struct *task)
> > +{
> > +	return task->ptrace;
> > +}
> 
> Pointless 1:1 wrapper unless you're going to #ifdef ->ptrace later.

And that's exactly what's going to happen. Look at Roland's git. ;)

Petr


