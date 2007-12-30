Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbXL3NK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbXL3NK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXL3NKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:10:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55875 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbXL3NKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:10:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on x86-64
Date: Sun, 30 Dec 2007 14:30:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <200712281353.37976.rjw@sisk.pl> <20071229234326.GA17807@ucw.cz>
In-Reply-To: <20071229234326.GA17807@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712301430.08274.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 30 of December 2007, Pavel Machek wrote:
> Hi!
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Document the fact that __save_processor_state() has to save all CPU
> > registers referred to by the kernel in case a different kernel is
> > used to load and restore a hibernation image containing it. 
> 
> 
> > Sigend-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  arch/x86/kernel/suspend_64.c |   20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > Index: linux-2.6/arch/x86/kernel/suspend_64.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/suspend_64.c
> > +++ linux-2.6/arch/x86/kernel/suspend_64.c
> > @@ -19,6 +19,21 @@ extern const void __nosave_begin, __nosa
> >  
> >  struct saved_context saved_context;
> >  
> > +/**
> > + *	__save_processor_state - save CPU registers before creating a
> > + *		hibernation image and before restoring the memory state from it
> > + *	@ctxt - structure to store the registers contents in
> > + *
> > + *	NOTE: If there is a CPU register the modification of which by the
> > + *	boot kernel (ie. the kernel used for loading the hibernation image)
> > + *	might affect the operations of the restored target kernel (ie. the one
> > + *	saved in the hibernation image), then its contents must be saved by this
> > + *	function.  In other words, if kernel A is hibernated and different
> > + *	kernel B is used for loading the hibernation image into memory, the
> > + *	kernel A's __save_processor_state() function must save all registers
> > + *	needed by kernel A, so that it can operate correctly after the resume
> > + *	regardless of what kernel B does in the meantime.
> > + */
> 
> Maybe this warning should be appended to struct saved_context
> definition? Reordering its fields (etc) would be bad news, too,

Hmm, I think they can be reordered without any problem.  It's always the same
kernel using them, although at different times.

> and documentation near data structures is easier to find...

Well, I'll add a coment next to the definition of struct saved_context to
explain what it's for, but IMO the behavior of __save_processor_state() is what
_really_ matters (ie. it doesn't matter how and where exactly it saves the
registers as long as __restore_processor_state() can restore their "old"
values).

Greetings,
Rafael
