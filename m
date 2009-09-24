Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbZIXODh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbZIXODh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZIXODh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:03:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbZIXODg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:03:36 -0400
Date: Thu, 24 Sep 2009 10:02:29 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Immediate values
Message-ID: <20090924140228.GA2648@redhat.com>
References: <20090924123154.GA12907@Krystal> <20090924123428.GA27282@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924123428.GA27282@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 02:34:28PM +0200, Ingo Molnar wrote:
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi Ingo,
> > 
> > Andi asked me this week when we should expect to see the "immediate 
> > values" make it into mainline. I remember you pulled them at one 
> > point. He would like to use them to encode some very hot-path 
> > variables into the instruction stream.
> > 
> > How should I proceed to get that upstream ? Would a repost be 
> > appropriate ?
> 
> Would have to see it in full context i guess, with before/after 
> measurements, etc.
> 
> 	Ingo

right we've proposed an alternative to the immediate values, which I've
been calling 'jump label', here:

http://marc.info/?l=linux-kernel&m=125200966226921&w=2

The basic idea is that gcc, 4.5 will have support for an 'asm goto'
construct which can refer to c code labels. Thus, we can replace a nop
in the code stream with a 'jmp' instruction to various branch targets.

In terms of a comparison between the two, IMO, I think that the syntax
for the immediate variables can be more readable, since it just looks
like a conditional expression.

The immediate values do a 'mov', 'test' and then a jump, whereas jump
label can just do a jump. So in this respect, I believe jump label can
be more optimal. Additinally, if we want to mark sections 'cold' so they
don't impact the istruction cache, the jump label already has the labels
for doing so. Obviously, a performance comparison would be interesting
as well.

thanks,

-Jason


