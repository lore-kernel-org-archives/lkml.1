Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbXJQP0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbXJQP0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760633AbXJQP0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:26:09 -0400
Received: from h155.mvista.com ([63.81.120.158]:4793 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760028AbXJQP0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:26:08 -0400
Subject: Re: [RT] seqlocks: use of PICK_FUNCTION breaks kernel compile when
	CONFIG_GENERIC_TIME is NOT set
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Remy Bohmer <linux@bohmer.net>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1192633836.8265.6.camel@localhost.localdomain>
References: <1192632502.17527.129.camel@imap.mvista.com>
	 <1192633836.8265.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 08:24:05 -0700
Message-Id: <1192634645.17527.134.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 11:10 -0400, Steven Rostedt wrote:

> > >  
> > >  #define read_seqbegin_irqsave(lock, flags)			\
> > > -do {								\
> > > +({								\
> > >  	flags = PICK_SEQ_OP_RET(__read_seqbegin_irqsave_raw,	\
> > >  		__read_seqbegin_irqsave, lock);			\
> > > -} while (0)
> > > +	read_seqbegin(lock);					\
> > > +})
> 
> Yes, definitely the raw and unraw functions should be called
> local_irqsave_raw or something else that makes this obvious to what it
> is doing.

Hmm.. I'm not sure what else to name them .. Since it's in the seqlock.h
I don't think it should be called anything "local_irq*" .. It could be
seq_irqsave_{raw} . 

Daniel

