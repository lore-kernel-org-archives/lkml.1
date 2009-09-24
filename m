Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbZIXTRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbZIXTRC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:17:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZIXTRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:17:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52004 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZIXTQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:16:59 -0400
Date: Thu, 24 Sep 2009 21:16:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Immediate values
Message-ID: <20090924191642.GA19225@elte.hu>
References: <20090924123154.GA12907@Krystal> <20090924123428.GA27282@elte.hu> <20090924140228.GA2648@redhat.com> <20090924141600.GA22007@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924141600.GA22007@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Jason Baron (jbaron@redhat.com) wrote:
> > 
> > right we've proposed an alternative to the immediate values, which 
> > I've been calling 'jump label', here:
> > 
> > http://marc.info/?l=linux-kernel&m=125200966226921&w=2
> > 
> > The basic idea is that gcc, 4.5 will have support for an 'asm goto' 
> > construct which can refer to c code labels. Thus, we can replace a 
> > nop in the code stream with a 'jmp' instruction to various branch 
> > targets.
> > 
> > In terms of a comparison between the two, IMO, I think that the 
> > syntax for the immediate variables can be more readable, since it 
> > just looks like a conditional expression.
> > 
> > The immediate values do a 'mov', 'test' and then a jump, whereas 
> > jump label can just do a jump. So in this respect, I believe jump 
> > label can be more optimal. Additinally, if we want to mark sections 
> > 'cold' so they don't impact the istruction cache, the jump label 
> > already has the labels for doing so. Obviously, a performance 
> > comparison would be interesting as well.
> 
> For branches, I'm convinced that a "static jump" approach will beat 
> immediate values anytime, because you save the BPB hit completely.
> 
> However, there are other use-cases involving a variable read, and in 
> that case immediate values are useful. Andi has been bugging me for a 
> while to re-post this patchset, I'm pretty sure he has precise ideas 
> about how he would like to use it.

It depends on how significant that usecase is.

Tracepoints used to be the biggest use-case for immediate values, and 
without that the thing becomes rather complex to maintain, for probably 
very little benefit.

	Ingo
