Return-Path: <linux-kernel-owner+w=401wt.eu-S933945AbXJQPfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbXJQPfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758574AbXJQPf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:35:29 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:44730 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbXJQPf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:35:28 -0400
Date: Wed, 17 Oct 2007 11:34:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Remy Bohmer <linux@bohmer.net>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RT] seqlocks: use of PICK_FUNCTION breaks kernel compile when
 CONFIG_GENERIC_TIME is NOT set
In-Reply-To: <1192634645.17527.134.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.58.0710171133490.26554@gandalf.stny.rr.com>
References: <1192632502.17527.129.camel@imap.mvista.com> 
 <1192633836.8265.6.camel@localhost.localdomain> <1192634645.17527.134.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--

On Wed, 17 Oct 2007, Daniel Walker wrote:

> On Wed, 2007-10-17 at 11:10 -0400, Steven Rostedt wrote:
>
> > > >
> > > >  #define read_seqbegin_irqsave(lock, flags)			\
> > > > -do {								\
> > > > +({								\
> > > >  	flags = PICK_SEQ_OP_RET(__read_seqbegin_irqsave_raw,	\
> > > >  		__read_seqbegin_irqsave, lock);			\
> > > > -} while (0)
> > > > +	read_seqbegin(lock);					\
> > > > +})
> >
> > Yes, definitely the raw and unraw functions should be called
> > local_irqsave_raw or something else that makes this obvious to what it
> > is doing.
>
> Hmm.. I'm not sure what else to name them .. Since it's in the seqlock.h
> I don't think it should be called anything "local_irq*" .. It could be
> seq_irqsave_{raw} .

Hmm, what about a __seq_irqsave_raw and __seq_nop?

That way it spells out that irqs are NOT touched if it is not a raw lock.

-- Steve

